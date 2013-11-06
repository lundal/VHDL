--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:37:01 10/03/2013
-- Design Name:   
-- Module Name:   C:/Users/torbjlan/VHDL/FPGAToplevel/crossover_core_doublesplit_tb.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: crossover_core_doublesplit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY crossover_core_doublesplit_tb IS
END crossover_core_doublesplit_tb;
 
ARCHITECTURE behavior OF crossover_core_doublesplit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT crossover_core_doublesplit
    PORT(
         random_number1 : IN  std_logic_vector(5 downto 0);
			random_number2 : IN  std_logic_vector(5 downto 0);
         parent1 : IN  std_logic_vector(63 downto 0);
         parent2 : IN  std_logic_vector(63 downto 0);
         child1 : OUT  std_logic_vector(63 downto 0);
         child2 : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal random_number1 : std_logic_vector(5 downto 0) := (others => '0');
	signal random_number2 : std_logic_vector(5 downto 0) := (others => '0');
   signal parent1 : std_logic_vector(63 downto 0) := (others => '0');
   signal parent2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal child1 : std_logic_vector(63 downto 0);
   signal child2 : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: crossover_core_doublesplit PORT MAP (
          random_number1 => random_number1,
			 random_number2 => random_number2,
          parent1 => parent1,
          parent2 => parent2,
          child1 => child1,
          child2 => child2
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		-- Choosing completely different bitpatterns (from now on referred to as "standard parents"):
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		-- Choosing 25 (011001) and 50 (110010) as values for opening random numbers:
		random_number1 <= "011001";
		random_number2 <= "110010";
		
		wait for 40 ns;
		
		-- Change in parents outside crossover field should cause equal non-crossover change in children.
		parent1 <= "1001111111111111000000000000000011111111111111110000000000011110";
		parent2 <= "0110000000000000111111111111111100000000000000001111111111100001";
		
		wait for 40 ns;
		
		-- Change in parents innside crossover field should cause crossovered change in children:
		parent1 <= "1001111111111111000000111000000011000111111111110000000000011110";
		parent2 <= "0110000000000000111111000111111100111000000000001111111111100001";
				
		wait for 40 ns;
		
		-- Change in parents crossing the crossover field start/end should cause change in children
		--	where outside crossoverfield is equal to parents, while inside is crossovered:
		parent1 <= "1111111111000000111111110000000011100000000111110000000000000000";
		parent2 <= "0000000000111111000000001111111100011111111000001111111111111111";
		
		wait for 40 ns;
		
		-- Change in random_numbers should cause change in children.
		-- Setting random_number1 to 9 (001001) 
		random_number1 <= "001001";
		
		wait for 40 ns;
		
		-- Setting random_number2 to 11 (001011): 
		random_number2 <="001011";
		
		wait for 40 ns;
		
		-- Setting back to 25 (011001) and 50 (110010)):
		random_number1 <= "011001";
		random_number2 <= "110010";

		-- Parents with equal bits in crossover-field should produce same bits in same fields in both children:
		-- (1111 set in bits 29-26, and 0000 set in bits 45-41)
		parent1 <= "1111111111111111000000000000000011111111111111110000000000001111";
		parent2 <= "0000000000000000110000111111111100111100000000001111000011111111";
				
		wait for 40 ns;
		
		-- Highest crossover number determines crossover split start, not that the "correct" number is highest.
		-- Setting crossover bits to 28 (011100) and 35 (100011):
		
		random_number1 <= "011100";
		random_number2 <= "100011";
		
		-- (Setting back to "Standard parents")
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		wait for 40 ns;
		
		-- Now setting crossover bits to 35 (100011) and 28 (011100).
		-- No changes should occur:
		
		random_number1 <= "100011";
		random_number2 <= "011100";
		
		wait for 40 ns;
		
		-- Now expanding by setting crossover bits to 36 (100100) and 27 (011011).
		-- First number should still be crossover start while second number should be crossover end:
		
		random_number1 <= "100100";
		random_number2 <= "011011";
		
		wait for 40 ns;
		
		-- Now switching the crossover bits to 27 (011011) and 36 (100100).
		-- No change should occur:
		
		random_number1 <= "011011";
		random_number2 <= "100100";
		
		wait for 40 ns;
		
		-- If both random_numbers are the same, the one and only one bit should have crossover:
		-- Setting both crossover bits to 28 (011100):
		
		random_number1 <= "011100";
		random_number2 <= "011100";
		
		wait for 40 ns;
		
		-- The next three tests will test a "crossover" of the crossover bits. 
		-- Bit nr 1 will be 36 (100100), 37 (100101) and 38 (100110).
		-- Bit nr 2 will be 37 (100101) for all the three tests
		-- Expected field: 36 to 37, 37 to 37, 37 to 38
		
		-- Bit nr 1: 36 (100100)
		random_number1 <= "100100";
		random_number2 <= "100101";
		
		wait for 40 ns;
		
		-- Bit nr 1: 37 (100101)
		random_number1 <= "100101";
		
		wait for 40 ns;
		
		-- Bit nr 1: 38 (100110)
		random_number1 <= "100110";
		
		wait for 40 ns;
		
		random_number1 <= (5 downto 0 => '0');
		random_number2 <= (5 downto 0 => '0');
		
		-- Going from bit number 0 to 63 for the next 64 tests. Bit number 2 will always be 0, becoming the lowest number.
		-- Afterwards there will be 63 more tests where bit number 2 will go from 0 to 63. Bit number 1 will stay as bit number 63
		
		-- Bit number 1 tests:
		-- Number 1-00
		random_number1 <="000000";
		wait for 40 ns;
		
		-- Number 1-01
		random_number1 <="000001";
		wait for 40 ns;
		
		-- Number 1-02
		random_number1 <="000010";
		wait for 40 ns;
		
		-- Number 1-03
		random_number1 <="000011";
		wait for 40 ns;
		
		-- Number 1-04
		random_number1 <="000100";
		wait for 40 ns;
		
		-- Number 1-05
		random_number1 <="000101";
		wait for 40 ns;
		
		-- Number 1-06
		random_number1 <="000110";
		wait for 45 ns;
		
		-- Number 1-07
		random_number1 <="000111";
		wait for 40 ns;
		
		-- Number 1-08
		random_number1 <="001000";
		wait for 40 ns;
		
		-- Number 1-09
		random_number1 <="001001";
		wait for 40 ns;
		
		-- Number 1-10
		random_number1 <="001010";
		wait for 40 ns;
		
		-- Number 1-11
		random_number1 <="001011";
		wait for 40 ns;
		
		-- Number 1-12
		random_number1 <="001100";
		wait for 40 ns;
		
		-- Number 1-13
		random_number1 <="001101";
		wait for 40 ns;
		
		-- Number 1-14
		random_number1 <="001110";
		wait for 40 ns;
		
		-- Number 1-15
		random_number1 <="001111";
		wait for 40 ns;
		
		-- Number 1-16
		random_number1 <="010000";
		wait for 40 ns;
		
		-- Number 1-17
		random_number1 <="010001";
		wait for 40 ns;
		
		-- Number 1-18
		random_number1 <="010010";
		wait for 40 ns;
		
		-- Number 1-19
		random_number1 <="010011";
		wait for 40 ns;
		
		-- Number 1-20
		random_number1 <="010100";
		wait for 40 ns;
		
		-- Number 1-21
		random_number1 <="010101";
		wait for 40 ns;
		
		-- Number 1-22
		random_number1 <="010110";
		wait for 40 ns;
		
		-- Number 1-23
		random_number1 <="010111";
		wait for 40 ns;
		
		-- Number 1-24
		random_number1 <="011000";
		wait for 40 ns;
		
		-- Number 1-25
		random_number1 <="011001";
		wait for 40 ns;
		
		-- Number 1-26
		random_number1 <="011010";
		wait for 40 ns;
		
		-- Number 1-27
		random_number1 <="011011";
		wait for 40 ns;
		
		-- Number 1-28
		random_number1 <="011100";
		wait for 40 ns;
		
		-- Number 1-29
		random_number1 <="011101";
		wait for 40 ns;
		
		-- Number 1-30
		random_number1 <="011110";
		wait for 40 ns;
		
		-- Number 1-31
		random_number1 <="011111";
		wait for 40 ns;
		
		-- Number 1-32
		random_number1 <="100000";
		wait for 40 ns;
		
		-- Number 1-33
		random_number1 <="100001";
		wait for 40 ns;
		
		-- Number 1-34
		random_number1 <="100010";
		wait for 40 ns;
		
		-- Number 1-35
		random_number1 <="100011";
		wait for 40 ns;
		
		-- Number 1-36
		random_number1 <="100100";
		wait for 40 ns;
		
		-- Number 1-37
		random_number1 <="100101";
		wait for 40 ns;
		
		-- Number 1-38
		random_number1 <="100110";
		wait for 40 ns;
		
		-- Number 1-39
		random_number1 <="100111";
		wait for 40 ns;
		
		-- Number 1-40
		random_number1 <="101000";
		wait for 40 ns;
		
		-- Number 1-41
		random_number1 <="101001";
		wait for 40 ns;
		
		-- Number 1-42
		random_number1 <="101010";
		wait for 40 ns;
		
		-- Number 1-43
		random_number1 <="101011";
		wait for 40 ns;
		
		-- Number 1-44
		random_number1 <="101100";
		wait for 40 ns;
		
		-- Number 1-45
		random_number1 <="101101";
		wait for 40 ns;
		
		-- Number 1-46
		random_number1 <="101110";
		wait for 40 ns;
		
		-- Number 1-47
		random_number1 <="101111";
		wait for 40 ns;
		
		-- Number 1-48
		random_number1 <="110000";
		wait for 40 ns;
		
		-- Number 1-49
		random_number1 <="110001";
		wait for 40 ns;
		
		-- Number 1-50
		random_number1 <="110010";
		wait for 40 ns;
		
		-- Number 1-51
		random_number1 <="110011";
		wait for 40 ns;
		
		-- Number 1-52
		random_number1 <="110100";
		wait for 40 ns;
		
		-- Number 1-53
		random_number1 <="110101";
		wait for 40 ns;
		
		-- Number 1-54
		random_number1 <="110110";
		wait for 40 ns;
		
		-- Number 1-55
		random_number1 <="110111";
		wait for 40 ns;
		
		-- Number 1-56
		random_number1 <="111000";
		wait for 40 ns;
		
		-- Number 1-57
		random_number1 <="111001";
		wait for 40 ns;
		
		-- Number 1-58
		random_number1 <="111010";
		wait for 40 ns;
		
		-- Number 1-59
		random_number1 <="111011";
		wait for 40 ns;
		
		-- Number 1-60
		random_number1 <="111100";
		wait for 40 ns;
		
		-- Number 1-61
		random_number1 <="111101";
		wait for 40 ns;
		
		-- Number 1-62
		random_number1 <="111110";
		wait for 40 ns;
		
		-- Number 1-63, adding extra waiting time
		random_number1 <="111111";
		wait for 200 ns;
		
		
		-- Now bit nr 2 will go from 0 to 63 for the next 63 tests, while bit nr 1 is 63
		-- Bit nr 2 is already 0, så starting test with 01:		
		
		-- Number 2-01
		random_number2 <="000001";
		wait for 40 ns;
		
		-- Number 2-02
		random_number2 <="000010";
		wait for 40 ns;
		
		-- Number 2-03
		random_number2 <="000011";
		wait for 40 ns;
		
		-- Number 2-04
		random_number2 <="000100";
		wait for 40 ns;
		
		-- Number 2-05
		random_number2 <="000101";
		wait for 40 ns;
		
		-- Number 2-06
		random_number2 <="000110";
		wait for 40 ns;
		
		-- Number 2-07
		random_number2 <="000111";
		wait for 40 ns;
		
		-- Number 2-08
		random_number2 <="001000";
		wait for 40 ns;
		
		-- Number 2-09
		random_number2 <="001001";
		wait for 40 ns;
		
		-- Number 2-10
		random_number2 <="001010";
		wait for 40 ns;
		
		-- Number 2-11
		random_number2 <="001011";
		wait for 40 ns;
		
		-- Number 2-12
		random_number2 <="001100";
		wait for 40 ns;
		
		-- Number 2-13
		random_number2 <="001101";
		wait for 40 ns;
		
		-- Number 2-14
		random_number2 <="001110";
		wait for 40 ns;
		
		-- Number 2-15
		random_number2 <="001111";
		wait for 40 ns;
		
		-- Number 2-16
		random_number2 <="010000";
		wait for 40 ns;
		
		-- Number 2-17
		random_number2 <="010001";
		wait for 40 ns;
		
		-- Number 2-18
		random_number2 <="010010";
		wait for 40 ns;
		
		-- Number 2-19
		random_number2 <="010011";
		wait for 40 ns;
		
		-- Number 2-20
		random_number2 <="010100";
		wait for 40 ns;
		
		-- Number 2-21
		random_number2 <="010101";
		wait for 40 ns;
		
		-- Number 2-22
		random_number2 <="010110";
		wait for 40 ns;
		
		-- Number 2-23
		random_number2 <="010111";
		wait for 40 ns;
		
		-- Number 2-24
		random_number2 <="011000";
		wait for 40 ns;
		
		-- Number 2-25
		random_number2 <="011001";
		wait for 40 ns;
		
		-- Number 2-26
		random_number2 <="011010";
		wait for 40 ns;
		
		-- Number 2-27
		random_number2 <="011011";
		wait for 40 ns;
		
		-- Number 2-28
		random_number2 <="011100";
		wait for 40 ns;
		
		-- Number 2-29
		random_number2 <="011101";
		wait for 40 ns;
		
		-- Number 2-30
		random_number2 <="011110";
		wait for 40 ns;
		
		-- Number 2-31
		random_number2 <="011111";
		wait for 40 ns;
		
		-- Number 2-32
		random_number2 <="100000";
		wait for 40 ns;
		
		-- Number 2-33
		random_number2 <="100001";
		wait for 40 ns;
		
		-- Number 2-34
		random_number2 <="100010";
		wait for 40 ns;
		
		-- Number 2-35
		random_number2 <="100011";
		wait for 40 ns;
		
		-- Number 2-36
		random_number2 <="100100";
		wait for 40 ns;
		
		-- Number 2-37
		random_number2 <="100101";
		wait for 40 ns;
		
		-- Number 2-38
		random_number2 <="100110";
		wait for 40 ns;
		
		-- Number 2-39
		random_number2 <="100111";
		wait for 40 ns;
		
		-- Number 2-40
		random_number2 <="101000";
		wait for 40 ns;
		
		-- Number 2-41
		random_number2 <="101001";
		wait for 40 ns;
		
		-- Number 2-42
		random_number2 <="101010";
		wait for 40 ns;
		
		-- Number 2-43
		random_number2 <="101011";
		wait for 40 ns;
		
		-- Number 2-44
		random_number2 <="101100";
		wait for 40 ns;
		
		-- Number 2-45
		random_number2 <="101101";
		wait for 40 ns;
		
		-- Number 2-46
		random_number2 <="101110";
		wait for 40 ns;
		
		-- Number 2-47
		random_number2 <="101111";
		wait for 40 ns;
		
		-- Number 2-48
		random_number2 <="110000";
		wait for 40 ns;
		
		-- Number 2-49
		random_number2 <="110001";
		wait for 40 ns;
		
		-- Number 2-50
		random_number2 <="110010";
		wait for 40 ns;
		
		-- Number 2-51
		random_number2 <="110011";
		wait for 40 ns;
		
		-- Number 2-52
		random_number2 <="110100";
		wait for 40 ns;
		
		-- Number 2-53
		random_number2 <="110101";
		wait for 40 ns;
		
		-- Number 2-54
		random_number2 <="110110";
		wait for 40 ns;
		
		-- Number 2-55
		random_number2 <="110111";
		wait for 40 ns;
		
		-- Number 2-56
		random_number2 <="111000";
		wait for 40 ns;
		
		-- Number 2-57
		random_number2 <="111001";
		wait for 40 ns;
		
		-- Number 2-58
		random_number2 <="111010";
		wait for 40 ns;
		
		-- Number 2-59
		random_number2 <="111011";
		wait for 40 ns;
		
		-- Number 2-60
		random_number2 <="111100";
		wait for 40 ns;
		
		-- Number 2-61
		random_number2 <="111101";
		wait for 40 ns;
		
		-- Number 2-62
		random_number2 <="111110";
		wait for 40 ns;
		
		-- Number 2-63
		random_number2 <="111111";
		
		-- End of test
		
      wait;
   end process;

END;
