----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-05 17:03
-- Tested:   Never
--
-- Description:
-- Increments the number by one each rising edge of input signal
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IncrementerDouble is
    generic (
        NUM_WIDTH : natural := 4
    );
    port (
        NUM       : out STD_LOGIC_VECTOR(NUM_WIDTH-1 downto 0);
        INCREMENT : in  STD_LOGIC
    );
end IncrementerDouble;

architecture Behavioral of IncrementerDouble is
    
    signal counter : STD_LOGIC_VECTOR(NUM_WIDTH-1 downto 0) := (others => '0');
    
begin
    
    INCREMENTER : process (INCREMENT)
    begin
        if rising_edge(INCREMENT) then
            counter <= STD_LOGIC_VECTOR(UNSIGNED(counter) + 1);
        end if;
    end process;
    
    NUM <= counter;
    
end Behavioral;

