library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crossover_core_xor is
    generic (
        N : integer := 64
    );
    port (
        random_number : in  STD_LOGIC_VECTOR(N-1 downto 0);
        parent1       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        parent2       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        child1        : out STD_LOGIC_VECTOR(N-1 downto 0);
        child2        : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end crossover_core_xor;

architecture Behavioral of crossover_core_xor is
	signal mask1 : STD_LOGIC_VECTOR(N-1 downto 0);
    signal mask2 : STD_LOGIC_VECTOR(N-1 downto 0);
begin
	
    mask1 <= random_number;
    mask2 <= not mask1;
    
    child1 <= (parent1 and mask2) or (parent2 and mask1);
    child2 <= (parent1 and mask1) or (parent2 and mask2);
    
end Behavioral;
