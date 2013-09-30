library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crossover_core is
	generic (N : integer :=64);
    Port (
				enabled : in STD_LOGIC;
				random_number: in STD_LOGIC_VECTOR (N-1 downto 0);
				parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				child2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end crossover_core;

architecture Behavioral of crossover_core is

	--6 bits needed to cover 64 different bits
	
	signal reduced_random_number : STD_LOGIC_VECTOR( 5 downto 0); 
	--Used to determine where crossover starts, based on reduced_random_number
	signal crossover_start : INTEGER := 0; 
	signal crossover_result1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal crossover_result2 : STD_LOGIC_VECTOR (N-1 downto 0);
begin

	CROSSOVER : Process(enabled, random_number, reduced_random_number, parent1, parent2, crossover_start)
	begin
	
		-- Crossover core will only be allowed to run whenever enabled
		if enabled='1' then
			
			--6 last bits selected from input random_number, used to select where in parents to start crossover
			reduced_random_number(5 downto 0) <= random_number(5 downto 0);
			crossover_start <= TO_INTEGER(UNSIGNED(reduced_random_number));
			
			--First crossover
			crossover_result1(N-1 downto crossover_start+1) <= parent1(N-1 downto crossover_start+1);
			crossover_result1(crossover_start downto 0) <= parent2(crossover_start downto 0);
			
			--Second crossover
			crossover_result2(N-1 downto crossover_start+1) <= parent2(N-1 downto crossover_start+1);
			crossover_result2(crossover_start downto 0) <= parent1(crossover_start downto 0);
				
		else
			crossover_result1 <= (others => '0');
			crossover_result2 <= (others => '0');
		end if;
	end process CROSSOVER;
	
	child1 <= crossover_result1;
	child2 <= crossover_result2;
	
end Behavioral;

