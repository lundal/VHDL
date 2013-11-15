----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-14 00:47
-- Tested:   Never
--
-- Description:
-- TODO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory_data_controller is
    generic (
        NUM_PROC   : natural := 4;
        ADDR_WIDTH : natural := 19;
        DATA_WIDTH : natural := 64
    );
    port (
        -- Control signals
        REQUEST_0 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        REQUEST_1 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        ACK       : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        
        -- Buses
        PROC_ADDR     : in  STD_LOGIC_VECTOR(ADDR_WIDTH-2-1 downto 0);
        PROC_DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        PROC_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        -- Memory
        MEM_ADDR   : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        MEM_DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0);
        MEM_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0);
        MEM_ENABLE : out STD_LOGIC;
        MEM_WRITE  : out STD_LOGIC;
        MEM_LBUB   : out STD_LOGIC;
        
        ENABLE : in  STD_LOGIC;
        CLK : in  STD_LOGIC
    );
end memory_data_controller;

architecture Behavioral of memory_data_controller is
    
    signal counter : STD_LOGIC_VECTOR(2-1 downto 0) := (others => '0');
    
    -- Internal control signals
    signal read_0 : STD_LOGIC := '0';
    signal read_1 : STD_LOGIC := '0';
    signal read_2 : STD_LOGIC := '0';
    signal read_3 : STD_LOGIC := '0';
    signal fetch : STD_LOGIC := '0';
    signal increment : STD_LOGIC := '0';
    
    -- Flip-Flop data
    signal read_0_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal read_1_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal read_2_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal read_3_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal write_data : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal write_out : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal addr : STD_LOGIC_VECTOR(ADDR_WIDTH-2-1 downto 0) := (others => '0');
    
    -- State machine
    type state_type is (Choose, ReadFetch, Read, WriteFetch, Write0, Write1, Write2);
    signal state : state_type := Choose;
    
    -- Request signals
    signal request_int : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal has_request : STD_LOGIC;
    
begin
    
    FF_READ_0 : process (CLK, read_0, MEM_DATA_IN)
    begin 
        if rising_edge(CLK) and read_0 ='1' then 
            read_0_data <= MEM_DATA_IN;
        end if;
    end process;
    
    FF_READ_1 : process (CLK, read_1, MEM_DATA_IN)
    begin 
        if rising_edge(CLK) and read_1 ='1' then 
            read_1_data <= MEM_DATA_IN;
        end if;
    end process;
    
    FF_READ_2 : process (CLK, read_2, MEM_DATA_IN)
    begin 
        if rising_edge(CLK) and read_2 ='1' then 
            read_2_data <= MEM_DATA_IN;
        end if;
    end process;
    
    FF_READ_3 : process (CLK, read_3, MEM_DATA_IN)
    begin 
        if rising_edge(CLK) and read_3 ='1' then 
            read_3_data <= MEM_DATA_IN;
        end if;
    end process;

    INCREMENTER : process (CLK, increment)
    begin
        if rising_edge(CLK) and increment = '0' then
            counter <= STD_LOGIC_VECTOR(UNSIGNED(counter) + 1);
        end if;
    end process;
    
    DECODER : process (counter)
    begin
        -- Default values
        read_0 <= '0';
        read_1 <= '0';
        read_2 <= '0';
        read_3 <= '0';
        
        if counter = "00" then
            read_0 <= '1';
        elsif counter = "01" then
            read_1 <= '1';
        elsif counter = "10" then
            read_2 <= '1';
        else
            read_3 <= '1';
        end if;
    end process;
    
    FF_DATA_IN : process (CLK, fetch, PROC_DATA_IN)
    begin 
        if rising_edge(CLK) and fetch ='1' then 
            write_data <= PROC_DATA_IN;
        end if;
    end process;
    
    FF_ADDR : process (CLK, fetch, PROC_ADDR)
    begin 
        if rising_edge(CLK) and fetch ='1' then 
            addr <= PROC_ADDR;
        end if;
    end process;
    
    -- MUX: Write out
    write_out <= write_data(DATA_WIDTH*4/4-1 downto DATA_WIDTH*3/4) when counter = "00" else
                 write_data(DATA_WIDTH*3/4-1 downto DATA_WIDTH*2/4) when counter = "01" else
                 write_data(DATA_WIDTH*2/4-1 downto DATA_WIDTH*1/4) when counter = "10" else
                 write_data(DATA_WIDTH*1/4-1 downto DATA_WIDTH*0/4);
    
    -- Tristate
    MEM_DATA_OUT <= write_out;
    
    -- Memory address
    MEM_ADDR <= addr & counter;
    
    -- Concatenate output
    PROC_DATA_OUT <= read_0_data & read_1_data & read_2_data & read_3_data;
    
    -- Request signals
    request_int <= REQUEST_0 or REQUEST_1;
    has_request <= '0' when request_int = (NUM_PROC-1 downto 0 => '0') else '1';
    
    STATE_CHANGER : process (CLK, state, ENABLE, has_request, request_int)
		variable chosen : integer range 0 to NUM_PROC := 0;
    begin
        if rising_edge(CLK) then
            case state is
                when Choose =>
                    -- Reset ack
                    ACK <= (others => '0');
                    
                    if (ENABLE = '1') then
                        -- Check if there exists a request
                        if (has_request = '1') then
                            
                            -- Go to next (to prevent starvation)
                            if (chosen = NUM_PROC) then
                                chosen := 0;
                            else
                                chosen := chosen + 1;
                            end if;
                            
                            -- Choose next (or return to original if none)
                            for i in 0 to NUM_PROC-1 loop
                                if request_int(chosen) = '0' then
                                    if (chosen = NUM_PROC) then
                                        chosen := 0;
                                    else
                                        chosen := chosen + 1;
                                    end if;
                                end if;
                            end loop;
                            
                            -- Send ack
                            ACK(chosen) <= '1';
                            
                        end if;
                        
                        if REQUEST_0(chosen) = '1' then
                            state <= ReadFetch;
                        elsif REQUEST_1(chosen) = '1' then
                            state <= WriteFetch;
                        else
                            state <= Choose;
                        end if;
                    else
                        state <= Choose;
                    end if;
                
                when ReadFetch =>
                    -- Reset ack
                    ACK(chosen) <= '0';
                    
                    state <= Read;
                
                when Read =>
                    if counter = "11" then
                        state <= Choose;
                    else
                        state <= Read;
                    end if;
                
                when WriteFetch =>
                    state <= Write0;
                
                when Write0 =>
                    state <= Write1;
                
                when Write1 =>
                    state <= Write2;
                
                when Write2 =>
                    if counter = "11" then
                        state <= Choose;
                    else
                        state <= Write0;
                    end if;
                
            end case;
        end if;
    end process;
    
    STATE_MACHINE : process (CLK, state)
    begin
        -- Defaults
        fetch <= '1';
        increment <= '0';
        
        case state is
            when Choose =>
                MEM_ENABLE <= '1';
                MEM_WRITE <= '1';
                MEM_LBUB <= '1';
            
            when ReadFetch =>
                MEM_ENABLE <= '0';
                MEM_WRITE <= '1';
                MEM_LBUB <= '0';
            
            when Read =>
                MEM_ENABLE <= '0';
                MEM_WRITE <= '1';
                MEM_LBUB <= '0';
                
                increment <= '1';
            
            when WriteFetch =>
                MEM_ENABLE <= '1';
                MEM_WRITE <= '1';
                MEM_LBUB <= '1';
                
                fetch <= '1';
            
            when Write0 =>
                MEM_ENABLE <= '1';
                
                if falling_edge(CLK) then
                    MEM_WRITE <= '0';
                    MEM_LBUB <= '0';
                end if;
            
            when Write1 =>
                MEM_ENABLE <= '0';
                MEM_WRITE <= '0';
                MEM_LBUB <= '0';
            
            when Write2 =>
                MEM_ENABLE <= '1';
                MEM_WRITE <= '1';
                MEM_LBUB <= '1';
                
                increment <= '1';
            
        end case;
    end process;
end Behavioral;
