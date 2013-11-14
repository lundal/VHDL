library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use Work.CONSTANTS.all;

entity fitness_memory_controller is
    generic (
        ADDR_WIDTH : natural := 17;
        DATA_WIDTH : natural := 64
    );
    port (
        -- Control signals
        REQUEST_0 : out STD_LOGIC;
        REQUEST_1 : out STD_LOGIC;
        ACK       : in  STD_LOGIC;
        
        -- Processor
        ADDR_IN  : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        -- Memory
        MEM_ADDR     : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        MEM_DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        MEM_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        OP   : in  MEM_OP_TYPE;
        HALT : out STD_LOGIC;
        CLK  : in  STD_LOGIC
    );
end fitness_memory_controller;

architecture Behavioral of fitness_memory_controller is
    
    -- State machine
    type state_type is (Idle, Write, ReadRequest, ReadWait);
    signal state : state_type := Idle;
    
    -- Internal signals
    signal op_int : MEM_OP_TYPE;
begin

    STATE_CHANGER : process (CLK, state, OP, ACK)
    begin
        if rising_edge(CLK) then
            case state is
                when Idle =>
                    if (OP = MEM_WRITE) then
                        state <= Write;
                    elsif (OP = MEM_READ) then
                        state <= ReadRequest;
                    else
                        state <= Idle;
                    end if;
                
                when Write =>
                    if (ACK = '1') then
                        state <= Idle;
                    else
                        state <= Write;
                    end if;
                
                when ReadRequest =>
                    if (ACK = '1') then
                        state <= ReadWait;
                    else
                        state <= ReadRequest;
                    end if;
                
                when ReadWait =>
                    if (ACK = '1') then
                        state <= ReadWait;
                    else
                        state <= Idle;
                    end if;
                
            end case;
        end if;
    end process;
    
    STATE_MACHINE : process (CLK, state, OP, ADDR_IN, DATA_IN, ack)
    begin
        case state is
            when Idle =>
                op_int <= OP;
                
                MEM_ADDR <= (others => 'Z');
                MEM_DATA_OUT <= (others => 'Z');
                
                if (OP /= MEM_NOP) then
                    HALT <= '1';
                else
                    HALT <= '0';
                end if;
            
            when Write =>
                if (ACK = '1') then
                    op_int <= MEM_NOP;
                    
                    MEM_ADDR <= ADDR_IN;
                    MEM_DATA_OUT <= DATA_IN;
                    
                    HALT <= '0';
                else
                    op_int <= MEM_WRITE;
                    
                    MEM_ADDR <= (others => 'Z');
                    MEM_DATA_OUT <= (others => 'Z');
                    
                    HALT <= '1';
                end if;
            
            when ReadRequest =>
                MEM_DATA_OUT <= (others => 'Z');
                
                HALT <= '1';
                
                if (ACK = '1') then
                    op_int <= MEM_NOP;
                    
                    MEM_ADDR <= ADDR_IN;
                else
                    op_int <= MEM_READ;
                    
                    MEM_ADDR <= (others => 'Z');
                end if;
                
            when ReadWait =>
                MEM_DATA_OUT <= (others => 'Z');
                
                op_int <= MEM_NOP;
                
                if (ACK = '1') then
                    MEM_ADDR <= ADDR_IN;
                    
                    HALT <= '1';
                else
                    MEM_ADDR <= (others => 'Z');
                    
                    HALT <= '0';
                end if;
            
        end case;
    end process;
    
    TRANSLATOR : process(op_int)
    begin
        case op_int is
            when MEM_NOP =>
                REQUEST_0 <= '0';
                REQUEST_1 <= '0';
            when MEM_READ =>
                REQUEST_0 <= '1';
                REQUEST_1 <= '0';
            when MEM_WRITE =>
                REQUEST_0 <= '0';
                REQUEST_1 <= '1';
        end case;
    end process;
    
    DATA_OUT <= MEM_DATA_IN;
    
end Behavioral;

