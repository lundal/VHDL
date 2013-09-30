----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:40:13 09/27/2013 
-- Design Name: 
-- Module Name:    mutation_core - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mutation_core is

	-- Must be at least 24 bits, since least significant bits are being used
	generic (N : integer :=64);
	Port (
				enabled : in STD_LOGIC;
				random_number: in STD_LOGIC_VECTOR (N-1 downto 0);
				input : in  STD_LOGIC_VECTOR (N-1 downto 0);
				output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end mutation_core;

architecture Behavioral of mutation_core is
	
	signal reduced_random_numberA : STD_LOGIC_VECTOR( 1 downto 0); 
	signal reduced_random_number1 : STD_LOGIC_VECTOR( 5 downto 0); 
	signal reduced_random_number2 : STD_LOGIC_VECTOR( 5 downto 0); 
	signal reduced_random_number3 : STD_LOGIC_VECTOR( 5 downto 0); 
	signal reduced_random_number4 : STD_LOGIC_VECTOR( 5 downto 0); 
	
	signal mutation_amount : INTEGER := 0;
	
	signal mutation_spot1 : INTEGER := 0;
	signal mutation_spot2 : INTEGER := 0;
	signal mutation_spot3 : INTEGER := 0;
	signal mutation_spot4 : INTEGER := 0;
	
	signal mutation_result : STD_LOGIC_VECTOR (N-1 downto 0);
	
begin

	MUTATE : Process(enabled, input, random_number, reduced_random_numberA, reduced_random_number1, reduced_random_number2,
							reduced_random_number3, reduced_random_number4, mutation_amount, mutation_spot1, mutation_spot2, 
							mutation_spot3, mutation_spot4)
	begin
	
		-- Mutation core will only be allowed to run whenever enabled
		if enabled='1' then
			
			--Setting mutation_result to be equal to input
			mutation_result <= input;
			
			--2 most significant bits used to determine amount of mutations to be done. It will be 1-4 mutations
			reduced_random_numberA(1 downto 0) <= random_number(N-1 downto N-2);
			mutation_amount<= TO_INTEGER(UNSIGNED(reduced_random_numberA));
			
			--First mutation will always happen
			reduced_random_number1(5 downto 0) <= random_number(5 downto 0);
			mutation_spot1 <= TO_INTEGER(UNSIGNED(reduced_random_number1));
			mutation_result(mutation_spot1) <= not input(mutation_spot1);
			
			--Second mutation if mutation_amount > 0	
			if (mutation_amount > 0) then
				reduced_random_number2(5 downto 0) <= random_number(11 downto 6);
				mutation_spot2 <= TO_INTEGER(UNSIGNED(reduced_random_number2));
				mutation_result(mutation_spot2) <= not input(mutation_spot2);
			end if;
			
			--Third mutation if mutation_amount > 1	
			if (mutation_amount > 1) then
				reduced_random_number3(5 downto 0) <= random_number(17 downto 12);
				mutation_spot3 <= TO_INTEGER(UNSIGNED(reduced_random_number3));
				mutation_result(mutation_spot3) <= not input(mutation_spot3);
			end if;
			
			--Fourth mutation if mutation_amount > 2	
			if (mutation_amount > 2) then
				reduced_random_number4(5 downto 0) <= random_number(23 downto 18);
				mutation_spot4 <= TO_INTEGER(UNSIGNED(reduced_random_number4));
				mutation_result(mutation_spot4) <= not input(mutation_spot4);
			end if;
			
		else
			mutation_result <= (others => '0');
		end if;
	end process MUTATE;
	
	output <= mutation_result;

end Behavioral;

