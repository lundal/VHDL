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
	generic (N : integer :=64; O : integer :=32; P : integer :=6);
	Port (
				enabled : in STD_LOGIC;
				active : in STD_LOGIC;
				random_number : in STD_LOGIC_VECTOR (O-1 downto 0);
				input : in  STD_LOGIC_VECTOR (N-1 downto 0);
				chance_input : in STD_LOGIC_VECTOR(P-1 downto 0);
				output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end mutation_core;

architecture Behavioral of mutation_core is
	
	signal reduced_random_numberC : STD_LOGIC_VECTOR( 5 downto 0); --C for control
	signal reduced_random_numberA : STD_LOGIC_VECTOR( 1 downto 0); --A for amount
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

	MUTATE : Process(enabled, active, random_number, input, chance_input, reduced_random_numberC, reduced_random_numberA, reduced_random_number1, reduced_random_number2,
							reduced_random_number3, reduced_random_number4, mutation_amount, mutation_spot1, mutation_spot2, mutation_spot3, mutation_spot4)
	begin
		
		-- Mutation core will only be allowed to run whenever enabled
		-- Mutation will only accour when active
		if (enabled = '1' and active = '1') then
			
			--Setting mutation_result to be equal to input first, then do eventual mutations
			mutation_result <= input;
			
			--6 most significant bits from random_number is used to decide whether there will be mutation or not
			--The value of these bits must be equal to or lower than the control input.
			--For each increasing value set in the control_input, the chance for mutation increases by 1.5625 % (1/64)
			--For example, the closest to 5% is 4.6875%, and the value of the control_input must be 000010
			--3 possible values for reduced_random_numberC is lower or equal: 000000, 000001 and 000010 (3/64 = 4.6875%)
			reduced_random_numberC(5 downto 0) <= random_number(O-1 downto O-6);
			
			if (reduced_random_numberC <= chance_input) then
				--7th and 8th most significant bits from random_number used to determine amount of mutations to be done. 
				--There will be 1-4 mutations (with values 0-3). 
				reduced_random_numberA(1 downto 0) <= random_number(O-7 downto O-8);
				mutation_amount<= TO_INTEGER(UNSIGNED(reduced_random_numberA));
			
				--First mutation
				--Bits 5-0 from random_number used to determine location
				reduced_random_number1(5 downto 0) <= random_number(5 downto 0);
				mutation_spot1 <= TO_INTEGER(UNSIGNED(reduced_random_number1));
				mutation_result(mutation_spot1) <= not input(mutation_spot1);
			
				--Second mutation if value of mutation_amount > 0	
				if (mutation_amount > 0) then
					--Bits 11-6 from random_number used to determine location
					reduced_random_number2(5 downto 0) <= random_number(11 downto 6);
					mutation_spot2 <= TO_INTEGER(UNSIGNED(reduced_random_number2));
					mutation_result(mutation_spot2) <= not input(mutation_spot2);
				end if;
			
				--Third mutation if value of mutation_amount > 1	
				if (mutation_amount > 1) then
					--Bits 17-12 from random_number used to determine location
					reduced_random_number3(5 downto 0) <= random_number(17 downto 12);
					mutation_spot3 <= TO_INTEGER(UNSIGNED(reduced_random_number3));
					mutation_result(mutation_spot3) <= not input(mutation_spot3);
				end if;
			
				--Fourth mutation if value of mutation_amount > 2	
				if (mutation_amount > 2) then
					--Bits 23-18 from random_number used to determine location
					reduced_random_number4(5 downto 0) <= random_number(23 downto 18);
					mutation_spot4 <= TO_INTEGER(UNSIGNED(reduced_random_number4));
					mutation_result(mutation_spot4) <= not input(mutation_spot4);
				end if;
			end if;
		-- If enabled, but not active, the mutation_core will still pass through the input,
		-- but no mutation will happen at all
		elsif enabled = '1' and active = '0' then
			mutation_result <= input;
		else
			mutation_result <= (others => '0');
		end if;
	end process MUTATE;
	
	output <= mutation_result;

end Behavioral;

