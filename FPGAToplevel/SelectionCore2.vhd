----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-31 12:16
-- Tested:   2013-10-31 16:47
--
-- Description:
-- Compares NUMBER genes and outputs the best
-- RANDOM is used to decide the genes that are compared
-- Latches are required for RANDOM to keep things speedy
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SelectionCore2 is
    generic(
        ADDR_SIZE    : natural := 9;
        DATA_SIZE    : natural := 64;
        COUNTER_SIZE : natural := 4
    );
    port(
        ADDR   : out STD_LOGIC_VECTOR(ADDR_SIZE-1 downto 0);
        RANDOM : in  STD_LOGIC_VECTOR(ADDR_SIZE-2 downto 0);
        DATA   : in  STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
        BEST   : out STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
        NUMBER : in  STD_LOGIC_VECTOR(COUNTER_SIZE-1 downto 0);
        ENABLE : in  STD_LOGIC;
        DONE   : out STD_LOGIC;
        CLK    : in  STD_LOGIC
    );
    -- Assign clock signal
    attribute CLOCK_SIGNAL : string;
    attribute CLOCK_SIGNAL of CLK : signal is "yes";
end SelectionCore2;

architecture Behavioral of SelectionCore2 is
    
    -- State Machine
    type StateType is (Ready, Compare, Update);
    signal State        : StateType := Ready;
    
    -- Control signals
    signal StoreGene    : STD_LOGIC := '0';
    signal StoreFitness : STD_LOGIC := '0';
    signal Better       : STD_LOGIC := '0';
    
    -- Internal signals
    signal Done_Int     : STD_LOGIC := '0';
    signal Random_Int   : STD_LOGIC_VECTOR(ADDR_SIZE-2 downto 0) := (others => '0');
    
    -- Best signals
    signal BestGene     : STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0) := (others => '0');
    signal BestFitness  : STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0) := (others => '0');
    
    -- Counter signals
    signal Counter      : STD_LOGIC_VECTOR(COUNTER_SIZE-1 downto 0) := (others => '0');
    
begin
    
    STATE_CHANGER : process(CLK, State)
    begin
        if rising_edge(CLK) then
            case State is
                when Ready =>
                    if ENABLE = '1' then
                        State <= Compare;
                        
                    else
                        State <= Ready;
                    end if;
                    
                    -- Reset Counter
                    Counter <= (COUNTER_SIZE-1 downto 0 => '0');
                
                when Compare =>
                    if Done_Int = '1' then
                        State <= Ready;
                    elsif StoreFitness = '1' then
                        State <= Update;
                    else
                        State <= Compare;
                    end if;
                    
                    -- Increment Counter
                    Counter <= STD_LOGIC_VECTOR(UNSIGNED(Counter) + "1");
                
                when Update =>
                    State <= Compare;
            end case;
        end if;
    end process;
    
    STATE_MACHINE : process(State, ENABLE, RANDOM, COUNTER, NUMBER, Random_Int, Better)
    begin
        case State is
            when Ready =>
                -- Static signals
                StoreFitness <= '0';
                StoreGene <= '0';
                Done_Int <= '0';
                
                -- Dynamic signals
                if (ENABLE = '1') then
                    -- Fetch new addresses
                    Random_Int <= RANDOM;
                    ADDR <= Random_Int & '0';
                end if;
            
            when Compare =>
                -- Static signals
                StoreGene <= '0';
                
                -- Dynamic signals
                if (Counter >= NUMBER) then
                    StoreFitness <= '0';
                    Done_Int <= '1';
                    
                elsif (Counter = (COUNTER_SIZE-1 downto 0 => '0') or Better = '1') then
                    StoreFitness <= '1';
                    Done_Int <= '0';
                    
                    -- Next address
                    ADDR <= Random_Int & '1';
                else
                    StoreFitness <= '0';
                    Done_Int <= '0';
                    
                    -- Fetch new addresses
                    Random_Int <= RANDOM;
                    ADDR <= Random_Int & '0';
                end if;
            
            when Update =>
                -- Static signals
                StoreFitness <= '0';
                StoreGene <= '1';
                Done_Int <= '0';
                
                -- Fetch new addresses
                Random_Int <= RANDOM;
                ADDR <= Random_Int & '0';
            
        end case;
    end process;
    
    FF_BEST_GENE : process(DATA, StoreGene, CLK)
    begin
        if rising_edge(CLK) and StoreGene = '1' then
            BestGene <= DATA;
        end if;
    end process;
    
    FF_BEST_FITNESS : process(DATA, StoreFitness, CLK)
    begin
        if rising_edge(CLK) and StoreFitness = '1' then
            BestFitness <= DATA;
        end if;
    end process;
    
    -- Compare Fitness
    Better <= '1' when DATA > BestFitness else '0';
    
    -- Propagate Signals
    BEST <= BestGene;
    DONE <= Done_Int;
    
end Behavioral;

