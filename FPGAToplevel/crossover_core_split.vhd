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
    component ShifterVariable is
        generic (
            N : natural := 64;
            M : natural := 6
        );
        port (
            I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
            O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
            Left	:	in	STD_LOGIC;
            Arith	:	in	STD_LOGIC;
            Count	:	in	STD_LOGIC_VECTOR(M-1 downto 0)
        );
    end component;
    
	signal shifted : STD_LOGIC_VECTOR(N-1 downto 0);
    signal mask1 : STD_LOGIC_VECTOR(N-1 downto 0);
    signal mask2 : STD_LOGIC_VECTOR(N-1 downto 0);
begin
    SHIFTER : ShifterVariable
    generic map (
        N => N,
        M => R
    )
    port map (
        I     => (others => '1'),
        O     => shifted,
        Left  => '1',
        Arith => '0',
        Count => random_number
    );
    
    mask1 <= shifted(N-2 downto 0) & '0';
    mask2 <= not mask1;
    
    child1 <= (parent1 and mask2) or (parent2 and mask1);
    child2 <= (parent1 and mask1) or (parent2 and mask2);
	
end Behavioral;
