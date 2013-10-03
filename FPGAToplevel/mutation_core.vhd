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

	-- Random_Number must be at least 24 bits to work, since 24 least significant bits are being specifically used
	-- Random_Number is recommended to be at least 30 bits in order to avoid overlap use of bit-areas
	generic (N : integer :=64; O : integer :=32);
	Port (
				enabled : in STD_LOGIC;
				random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
				input : in  STD_LOGIC_VECTOR (N-1 downto 0);
				output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end mutation_core;

architecture Behavioral of mutation_core is
	
	signal reduced_random_numberC : STD_LOGIC_VECTOR( 3 downto 0); --C for control
	signal reduced_random_numberA : STD_LOGIC_VECTOR( 1 downto 0); --A for amount
	signal reduced_random_number1 : STD_LOGIC_VECTOR( 5 downto 0); 
	signal reduced_random_number2 : STD_LOGIC_VECTOR( 5 downto 0); 
	signal reduced_random_number3 : STD_LOGIC_VECTOR( 5 downto 0); 
	signal reduced_random_number4 : STD_LOGIC_VECTOR( 5 downto 0); 
	
	signal mutation_control : INTEGER := 1; -- 0 will enable mutation, setting initiation to 1
	signal mutation_amount : INTEGER := 0;
	
	signal mutation_spot1 : INTEGER := 0;
	signal mutation_spot2 : INTEGER := 0;
	signal mutation_spot3 : INTEGER := 0;
	signal mutation_spot4 : INTEGER := 0;
	
	signal mutation_result : STD_LOGIC_VECTOR (N-1 downto 0);
	
begin

	MUTATE : Process(enabled, input, random_number, reduced_random_numberC, reduced_random_numberA, reduced_random_number1, reduced_random_number2,
							reduced_random_number3, reduced_random_number4, mutation_control, mutation_amount, mutation_spot1, mutation_spot2, 
							mutation_spot3, mutation_spot4)
	begin
		
		-- Mutation core will only be allowed to run whenever enabled
		if enabled='1' then
			
			--Setting mutation_result to be equal to input first, then do eventual mutations
			mutation_result <= input;
			
			--Out of 16 numbers in range 0-15, number must be 0 for mutation. That gives 6,25 % chance for mutation, 
			--4 most significant bits from random_number is used for this operation
			reduced_random_numberC(3 downto 0) <= random_number(O-1 downto O-4);
			mutation_control<= TO_INTEGER(UNSIGNED(reduced_random_numberC));
			
			if (mutation_control = 0) then
				--5th and 6th most significant bits from random_number used to determine amount of mutations to be done. 
				--It will be 1-4 mutations (with values 0-3). 
				reduced_random_numberA(1 downto 0) <= random_number(O-5 downto O-6);
				mutation_amount<= TO_INTEGER(UNSIGNED(reduced_random_numberA));
			
				--First mutation
				--Bits 7-2 from random_number used to determine location
				reduced_random_number1(5 downto 0) <= random_number(7 downto 2);
				mutation_spot1 <= TO_INTEGER(UNSIGNED(reduced_random_number1));
				mutation_result(mutation_spot1) <= not input(mutation_spot1);
			
				--Second mutation if value of mutation_amount > 0	
				if (mutation_amount > 0) then
					--Bits 13-8 from random_number used to determine location
					reduced_random_number2(5 downto 0) <= random_number(13 downto 8);
					mutation_spot2 <= TO_INTEGER(UNSIGNED(reduced_random_number2));
					mutation_result(mutation_spot2) <= not input(mutation_spot2);
				end if;
			
				--Third mutation if value of mutation_amount > 1	
				if (mutation_amount > 1) then
					--Bits 19-14 from random_number used to determine location
					reduced_random_number3(5 downto 0) <= random_number(19 downto 14);
					mutation_spot3 <= TO_INTEGER(UNSIGNED(reduced_random_number3));
					mutation_result(mutation_spot3) <= not input(mutation_spot3);
				end if;
			
				--Fourth mutation if value of mutation_amount > 2	
				if (mutation_amount > 2) then
					--Bits 25-20 from random_number used to determine location
					reduced_random_number4(5 downto 0) <= random_number(25 downto 20);
					mutation_spot4 <= TO_INTEGER(UNSIGNED(reduced_random_number4));
					mutation_result(mutation_spot4) <= not input(mutation_spot4);
				end if;
			end if;
		else
			mutation_result <= (others => '0');
		end if;
	end process MUTATE;
	
	output <= mutation_result;

end Behavioral;

