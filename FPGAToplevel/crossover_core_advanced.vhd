library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crossover_core_advanced is
	generic (N : integer :=64; O : integer :=32);
    Port (
				enabled : in STD_LOGIC;
				random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
				parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				child2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end crossover_core_advanced;

architecture Behavioral of crossover_core_advanced is

	-- increased_random_number will be used as double-sized duplicate of random_number
	
	signal increased_random_number: STD_LOGIC_VECTOR((O*2)-1 downto 0);

	signal A : INTEGER := 1; 
	
	signal crossover_result1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal crossover_result2 : STD_LOGIC_VECTOR (N-1 downto 0);
begin

	CROSSOVER : Process(enabled, random_number, increased_random_number, parent1, parent2, A)
	begin
	
		-- Crossover core will only be allowed to run whenever enabled
		if enabled='1' then
			
			
			-- A testbench or a system must not try to access bits outside any range
			-- If N and O*2 are not equal, then the smallest range must be used for crossover
			if (N < O*2) then
				A <= N;
			else
				A <= (O*2);
			end if;
	
			--Filling increased_random_number with values from random_number_twice
			increased_random_number((O*2)-1 downto O) <= random_number(O-1 downto 0);
			increased_random_number(O-1 downto 0) <= random_number(O-1 downto 0);
			
--			for i in A-1 downto 0 loop
			for i in N-1 downto 0 loop
				
				-- For each bit in increased_random_number which is 1, there will be a crossover on bit nr i from parents to children
--				if (increased_random_number(i)= '1') then 
--					crossover_result1(i) <= parent2(i);
--					crossover_result2(i) <= parent1(i);
--				else 
--					crossover_result1(i) <= parent1(i);
--					crossover_result2(i) <= parent2(i);
--				end if;

				crossover_result1(i) <= ((parent2(i) and increased_random_number(i) ) xor (parent1(i) and not increased_random_number(i)));
				crossover_result2(i) <= ((parent1(i) and increased_random_number(i) ) xor (parent2(i) and not increased_random_number(i)));
					
			end loop;
			
		else
			crossover_result1 <= (others => '0');
			crossover_result2 <= (others => '0');
		end if;
	end process CROSSOVER;
	
	child1 <= crossover_result1;
	child2 <= crossover_result2;
	
end Behavioral;

