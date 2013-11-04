library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crossover_core_doublesplit is
	generic (N : integer :=64; O : integer :=32);
    Port (
				enabled : in STD_LOGIC;
				random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
				parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				child2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
    -- Assign clock signal
    attribute CLOCK_SIGNAL : string;
    attribute CLOCK_SIGNAL of enabled       : signal is "no";
    attribute CLOCK_SIGNAL of random_number : signal is "no";
    attribute CLOCK_SIGNAL of parent1       : signal is "no";
    attribute CLOCK_SIGNAL of parent2       : signal is "no";
end crossover_core_doublesplit;

architecture Behavioral of crossover_core_doublesplit is

	-- 12 bits are needed for two numbers to cover 64 different bits
	signal reduced_random_number1 : STD_LOGIC_VECTOR( 5 downto 0); 
	signal reduced_random_number2 : STD_LOGIC_VECTOR( 5 downto 0);
	
	-- Used to determine where crossover starts, based on reduced_random_number
	-- They are crossover_split_start will point out a more significant bit for start 
	-- while crossover_split_end will point out a less significant bit for end (in worst case: same bit)
	signal crossover_split_start : INTEGER := 0; 
	signal crossover_split_end : INTEGER := 0; 
	
	signal crossover_result1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal crossover_result2 : STD_LOGIC_VECTOR (N-1 downto 0);
begin

	CROSSOVER : Process(enabled, random_number, reduced_random_number1, reduced_random_number2, parent1, parent2, 
	crossover_split_start, crossover_split_end)
	begin
	
		-- Crossover core will only be allowed to run whenever enabled
		if enabled='1' then
			
			--12 last bits selected from input random_number, used to select 2 spots in parents to start crossover and to end it
			reduced_random_number1(5 downto 0) <= random_number(5 downto 0);			
			reduced_random_number2(5 downto 0) <= random_number(11 downto 6);
			
			-- Setting highest reduced_random_number to crossover_split_start, and lowest reduced random_number to crossover_split_end
			if (reduced_random_number2 >= reduced_random_number1) then
				crossover_split_end <= TO_INTEGER(UNSIGNED(reduced_random_number1));
				crossover_split_start <= TO_INTEGER(UNSIGNED(reduced_random_number2));
			else
				crossover_split_end <= TO_INTEGER(UNSIGNED(reduced_random_number2));
				crossover_split_start <= TO_INTEGER(UNSIGNED(reduced_random_number1));
			end if;
			
			--First crossover
			crossover_result1(N-1 downto crossover_split_start+1) <= parent1(N-1 downto crossover_split_start+1);
			crossover_result1(crossover_split_start downto crossover_split_end) <= parent2(crossover_split_start downto crossover_split_end);
			crossover_result1(crossover_split_end-1 downto 0) <= parent1(crossover_split_end-1 downto 0);
				
			--Second crossover
			crossover_result2(N-1 downto crossover_split_start+1) <= parent2(N-1 downto crossover_split_start+1);
			crossover_result2(crossover_split_start downto crossover_split_end) <= parent1(crossover_split_start downto crossover_split_end);
			crossover_result2(crossover_split_end-1 downto 0) <= parent2(crossover_split_end-1 downto 0);
			
		else
			crossover_result1 <= (others => '0');
			crossover_result2 <= (others => '0');
		end if;
	end process CROSSOVER;
	
	child1 <= crossover_result1;
	child2 <= crossover_result2;
	
end Behavioral;

