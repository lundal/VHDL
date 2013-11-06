library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crossover_core_split is
    generic (
        N : integer := 64;
        R : integer := 6
    );
    port (
        random_number : in  STD_LOGIC_VECTOR(R-1 downto 0);
        parent1       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        parent2       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        child1        : out STD_LOGIC_VECTOR(N-1 downto 0);
        child2        : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end crossover_core_split;

architecture Behavioral of crossover_core_split is
        signal split : INTEGER := 0; 
begin
    
    split <= TO_INTEGER(UNSIGNED(random_number));
    
    child1 <= parent1(N-1 downto split+1) & parent2(split downto 0);
    child2 <= parent2(N-1 downto split+1) & parent1(split downto 0);
        
end Behavioral;