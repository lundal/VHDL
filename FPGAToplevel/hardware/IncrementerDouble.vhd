----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-05 17:00
-- Tested:   Never
--
-- Description:
-- Outputs two consecutive numbers
-- Increments each number by 2 each rising edge of input signal
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IncrementerDouble is
    generic (
        NUM_WIDTH : natural := 4
    );
    port (
        NUM_A     : out STD_LOGIC_VECTOR(NUM_WIDTH-1 downto 0);
        NUM_B     : out STD_LOGIC_VECTOR(NUM_WIDTH-1 downto 0);
        INCREMENT : in  STD_LOGIC
    );
end IncrementerDouble;

architecture Behavioral of IncrementerDouble is
    
    signal counter : STD_LOGIC_VECTOR(NUM_WIDTH-2 downto 0) := (others => '0');
    
begin
    
    INCREMENTER : process (INCREMENT)
    begin
        if rising_edge(INCREMENT) then
            counter <= STD_LOGIC_VECTOR(UNSIGNED(counter) + 1);
        end if;
    end process;
    
    NUM_A <= counter & '0';
    NUM_B <= counter & '1';
    
end Behavioral;

