library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity crossover_core is
	generic (N : integer :=64);
    Port (
				clk : in STD_LOGIC;
				enabled : in STD_LOGIC;
				
				random_number: in STD_LOGIC_VECTOR (N-1 downto 0);
				parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				child2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end crossover_core;

architecture Behavioral of crossover_core is

-- Random numbergenerator used for generating random number 
--component PRNG is
--    generic (Width : integer := 32);
--    Port ( clk  : in  STD_LOGIC;
--           reset : in STD_LOGIC;
--           load : in STD_LOGIC;
--           seed :in STD_LOGIC_VECTOR (Width-1 downto 0);
--           rnd_out : out  STD_LOGIC_VECTOR (Width-1 downto 0));
--end component PRNG;

signal reduced_random_number : STD_LOGIC_VECTOR( 5 downto 0); --6 bits needed to cover 64 different bits
signal crossover_start : INTEGER; --Used to determine where crossover starts, based on reduced_random_number
signal crossover_result1 : STD_LOGIC_VECTOR (N-1 downto 0);
signal crossover_result2 : STD_LOGIC_VECTOR (N-1 downto 0);

begin

	CROSSOVER : Process(clk, enabled, random_number, parent1, parent2, crossover_start, crossover_result1, crossover_result2)
	begin
	-- Crossover core will only be allowed to run whenever enabled
	if enabled='1' then
		if rising_edge(clk) then
		
			--6 last bits selected from input random_number, used to select where in parents to start crossover
			reduced_random_number(5 downto 0) <= random_number(5 downto 0);
			crossover_start <= TO_INTEGER(UNSIGNED(random_number));
			
			--First crossover
			crossover_result1(N-1 downto crossover_start+1) <= parent1(N-1 downto crossover_start+1);
			crossover_result1(crossover_start downto 0) <= parent2(crossover_start downto 0);
			
			--Second crossover
			crossover_result2(N-1 downto crossover_start+1) <= parent2(N-1 downto crossover_start+1);
			crossover_result2(crossover_start downto 0) <= parent1(crossover_start downto 0);
			
			--Setting output children to crossover_results
			child1 <= crossover_result1;
			child2 <= crossover_result2;
			
		end if;
	end if;
	end process CROSSOVER;

end Behavioral;

