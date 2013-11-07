----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-03 12:12
-- Tested:   2013-11-04 13:17
--
-- Description:
-- Outputs two consecutive addresses while STORE is high
-- Increments them each time STORE goes low
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Distributor is
    generic (
        ADDR_WIDTH : natural := 9
    );
    port (
        ADDR_A : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        ADDR_B : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        STORE  : in  STD_LOGIC
    );
    -- Assign clock signal
    attribute CLOCK_SIGNAL : string;
    attribute CLOCK_SIGNAL of STORE : signal is "no";
end Distributor;

architecture Behavioral of Distributor is
    
    signal counter : STD_LOGIC_VECTOR(ADDR_WIDTH-2 downto 0) := (others => '0');
    
begin
    
    INCREMENTER : process (STORE)
    begin
        if falling_edge(STORE) then
            counter <= STD_LOGIC_VECTOR(UNSIGNED(counter) + 1);
        end if;
    end process;
    
    ADDR_A <= counter & '0' when STORE = '1' else (others => 'Z');
    ADDR_B <= counter & '1' when STORE = '1' else (others => 'Z');
    
end Behavioral;

