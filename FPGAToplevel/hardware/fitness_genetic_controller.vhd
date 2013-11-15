library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.CONSTANTS.ALL;

entity fitness_genetic_controller is
    generic ( 
        DATA_WIDTH : integer := 64
    );
    port ( 
        -- To/from genetic pipeline
        REQUEST_0 : out STD_LOGIC;
        REQUEST_1 : out STD_LOGIC;
        ACK       : in  STD_LOGIC;
        DATA_IN   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DATA_OUT  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        -- To/from processor
        OP       : in  STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0);
        FITNESS  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        GENE_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        GENE_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        HALT     : out STD_LOGIC;
        CLK      : in  STD_LOGIC
    );
end fitness_genetic_controller;

architecture Behavioral of fitness_genetic_controller is
    
    type state_type is (Ready, Store);
    signal state : state_type := Ready;
    
    signal request : STD_LOGIC_VECTOR(2-1 downto 0);
    
begin
    
    REQUEST_0 <= request(0);
    REQUEST_1 <= request(1);
    
    STATE_CHANGER : process (CLK, state)
    begin
        if rising_edge(CLK) then
            case state is
                when Ready =>
                    if (ACK = '1' and OP = GENE_OP_STORE) then
                        state <= Store;
                    else
                        state <= Ready;
                    end if;
                when Store =>
                    state <= Ready;
            end case;
        end if;
    end process;
    
    STATE_MACHINE : process (state, request, ACK, OP, FITNESS, GENE_IN)
    begin
        case state is
            when Ready =>
                -- Send request until ack
                if (ACK = '0') then
                    request <= OP;
                else
                    request <= GENE_OP_NONE;
                end if;
                
                -- Send halt if access requires additional cycles
                if (OP = GENE_OP_STORE) then
                    HALT <= '1';
                elsif ((OP = GENE_OP_SETTINGS or OP = GENE_OP_LOAD) and ACK = '0') then
                    HALT <= '1';
                else
                    HALT <= '0';
                end if;
                
                -- Send out fitness/settings if writing and has access
                if ((OP = GENE_OP_STORE or OP = GENE_OP_SETTINGS) and ACK = '1') then
                    DATA_OUT <= FITNESS;
                else
                    DATA_OUT <= (others => 'Z');
                end if;
                
            when Store =>
                request <= GENE_OP_NONE;
                
                -- Release halt: Data is written at tick
                HALT <= '0';
                
                -- Output gene
                DATA_OUT <= GENE_IN;
        end case;
    end process;
    
    GENE_OUT <= DATA_IN;
    
end Behavioral;

