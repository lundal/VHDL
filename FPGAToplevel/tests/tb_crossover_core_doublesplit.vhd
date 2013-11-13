LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
 
ENTITY tb_crossover_core_doublesplit IS
END tb_crossover_core_doublesplit;
 
ARCHITECTURE behavior OF tb_crossover_core_doublesplit IS 
 
    COMPONENT crossover_core_doublesplit
    PORT(
         enabled : IN  std_logic;
         random_number : IN  std_logic_vector(31 downto 0);
         parent1 : IN  std_logic_vector(63 downto 0);
         parent2 : IN  std_logic_vector(63 downto 0);
         child1 : OUT  std_logic_vector(63 downto 0);
         child2 : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enabled : std_logic := '0';
   signal random_number : std_logic_vector(31 downto 0) := (others => '0');
   signal parent1 : std_logic_vector(63 downto 0) := (others => '0');
   signal parent2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal child1 : std_logic_vector(63 downto 0);
   signal child2 : std_logic_vector(63 downto 0);
 
BEGIN

   uut: crossover_core_doublesplit PORT MAP (
          enabled => enabled,
          random_number => random_number,
          parent1 => parent1,
          parent2 => parent2,
          child1 => child1,
          child2 => child2
        );

 

   stim_proc: process
   begin		
      wait for 100 ns;	
		
		-- INFORMATION: When setting crossover values/bits, 
		-- the first number mentioned is for crossover value based on bits 5-0 in random number,
		-- while the second number mentioned is for crossover value based on bits 11-6 in random number.
		-- These are also know as reduced_random_number1 and reduced_random_number2
		-- This test will regularly use the first number as the lowest one for formal reasons, 
		-- but, as the test will show, it does not matter which one is the highset and lowest
	 	
		-- Choosing completely different bitpatterns (from now on referred to as "standard parents"):
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		-- Choosing 25 (011001) and 50 (110010) as values for opening random number:
		random_number <= "00001111000011110000110010011001";
		
		wait for 40 ns;
		
		enabled <= '1';
		
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
		
		-- While unabled, children should be only 0s
		enabled <='0';
		wait for 40 ns;
		
		-- Change from parents to children should not be possible while not enabled:
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		wait for 40 ns;
		
		-- Re-enabling should allow change:
		enabled <='1';
		wait for 40 ns;
		
		-- Change in random_number should cause change in children.
		-- Setting to 9 (001001) and 11 (001011): 
		random_number <= "00001111000011110000001011001001";
		
		wait for 40 ns;
		
		-- Change from random_number to children should not be possible while not enabled:
		enabled <='0';
		wait for 40 ns;
		
		-- Setting to 12 (001100) and 18 (010010):
		random_number <= "00001111000011110000010010001100";
		
		wait for 40 ns;
		
		-- Re-enabling should allow change:
		enabled <='1';
		wait for 40 ns;
		
		-- Parents and random_number should change multiple times without changing children while not enabled:
		enabled <='0';
		parent1 <= "1111000011110000111100001111000000000000000000000000000000000000";
		parent2 <= "0000111100001111000011110000111111111111111111111111111111111111";
		wait for 40 ns;
		
		random_number <= "00001111111111111111111111111111";
		wait for 40 ns;
		
		-- (Setting back to "Standard parents")
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		wait for 40 ns;
		
		-- (Setting to 25 (011001) and 50 (110010)):
		random_number <= "00001111000011110000110010011001";
		wait for 40 ns;
		
		-- Parents with equal bits in crossover-field should produce same bits in same fields in both children:
		enabled <= '1';
		
		-- (1111 set in bits 29-26, and 0000 set in bits 45-41)
		parent1 <= "1111111111111111000000000000000011111111111111110000000000001111";
		parent2 <= "0000000000000000110000111111111100111100000000001111000011111111";
		
		wait for 40 ns;
	
		-- Changes in bits above bit nr. 11 in random_number should not affect output:
		
		random_number <="11111111111111111111110010011001";
		
		wait for 40 ns;
		
		-- Highest crossover number determines crossover start, not that the "correct" number is highest.
		-- Setting crossover bits to 28 (011100) and 35 (100011):
		
		random_number <= "00001111000011110000100011011100";
		
		-- (Setting back to "Standard parents")
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		wait for 40 ns;
		
		-- Now setting crossover bits to 35 (100011) and 28 (011100).
		-- No changes should occur:
		
		random_number <= "00001111000011110000011100100011";
		
		wait for 40 ns;
		
		-- Now expanding by setting crossover bits to 36 (100100) and 27 (011011).
		-- First number should still be crossover start while second number should be crossover end:
		
		random_number <= "00001111000011110000011011100100";
		
		wait for 40 ns;
		
		-- Now switching the crossover bits to 27 (011011) and 36 (100100).
		-- No change should occur:
		
		random_number <= "00001111000011110000100100011011";
		
		wait for 40 ns;
		
		-- If both crossover numbers are the same, the one and only one bit should have crossover:
		-- Setting both crossover bits to 28 (011100):
		
		random_number <= "00001111000011110000011100011100";
		
		wait for 40 ns;
		
		-- The next three tests will test a "crossover" of the crossover bits. 
		-- Bit nr 1 will be 36 (100100), 37 (100101) and 38 (100110).
		-- Bit nr 2 will be 37 (100101) all the three tests
		-- Expected field: 36 to 37, 37 to 37, 37 to 38
		
		-- Bit nr 1: 36 (100100)
		random_number <= "00001111000011110000100101100100";
		
		wait for 40 ns;
		
		-- Bit nr 1: 37 (100101)
		random_number <= "00001111000011110000100101100101";
		
		wait for 40 ns;
		
		-- Bit nr 1: 38 (100110)
		random_number <= "00001111000011110000100101100110";
		
		wait for 40 ns;
		
		random_number <= (31 downto 0 => '0');
		
		-- Going from bit number 0 to 63 for the next 64 tests. Bit number 2 will always be 0, becoming the lowest number.
		-- Afterwards there will be 63 more tests where bit number 2 will go from 0 to 63. Bit number 1 will stay as bit number 63
		
		-- Bit number 1 tests:
		-- Number 1-00
		random_number <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-01
		random_number <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 1-02
		random_number <= "00000000000000000000000000000010";
		wait for 40 ns;
		
		-- Number 1-03
		random_number <= "00000000000000000000000000000011";
		wait for 40 ns;
		
		-- Number 1-04
		random_number <= "00000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 1-05
		random_number <= "00000000000000000000000000000101";
		wait for 40 ns;
		
		-- Number 1-06
		random_number <= "00000000000000000000000000000110";
		wait for 45 ns;
		
		-- Number 1-07
		random_number <= "00000000000000000000000000000111";
		wait for 40 ns;
		
		-- Number 1-08
		random_number <= "00000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 1-09
		random_number <= "00000000000000000000000000001001";
		wait for 40 ns;
		
		-- Number 1-10
		random_number <= "00000000000000000000000000001010";
		wait for 40 ns;
		
		-- Number 1-11
		random_number <= "00000000000000000000000000001011";
		wait for 40 ns;
		
		-- Number 1-12
		random_number <= "00000000000000000000000000001100";
		wait for 40 ns;
		
		-- Number 1-13
		random_number <= "00000000000000000000000000001101";
		wait for 40 ns;
		
		-- Number 1-14
		random_number <= "00000000000000000000000000001110";
		wait for 40 ns;
		
		-- Number 1-15
		random_number <= "00000000000000000000000000001111";
		wait for 40 ns;
		
		-- Number 1-16
		random_number <= "00000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 1-17
		random_number <= "00000000000000000000000000010001";
		wait for 40 ns;
		
		-- Number 1-18
		random_number <= "00000000000000000000000000010010";
		wait for 40 ns;
		
		-- Number 1-19
		random_number <= "00000000000000000000000000010011";
		wait for 40 ns;
		
		-- Number 1-20
		random_number <= "00000000000000000000000000010100";
		wait for 40 ns;
		
		-- Number 1-21
		random_number <= "00000000000000000000000000010101";
		wait for 40 ns;
		
		-- Number 1-22
		random_number <= "00000000000000000000000000010110";
		wait for 40 ns;
		
		-- Number 1-23
		random_number <= "00000000000000000000000000010111";
		wait for 40 ns;
		
		-- Number 1-24
		random_number <= "00000000000000000000000000011000";
		wait for 40 ns;
		
		-- Number 1-25
		random_number <= "00000000000000000000000000011001";
		wait for 40 ns;
		
		-- Number 1-26
		random_number <= "00000000000000000000000000011010";
		wait for 40 ns;
		
		-- Number 1-27
		random_number <= "00000000000000000000000000011011";
		wait for 40 ns;
		
		-- Number 1-28
		random_number <= "00000000000000000000000000011100";
		wait for 40 ns;
		
		-- Number 1-29
		random_number <= "00000000000000000000000000011101";
		wait for 40 ns;
		
		-- Number 1-30
		random_number <= "00000000000000000000000000011110";
		wait for 40 ns;
		
		-- Number 1-31
		random_number <= "00000000000000000000000000011111";
		wait for 40 ns;
		
		-- Number 1-32
		random_number <= "00000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 1-33
		random_number <= "00000000000000000000000000100001";
		wait for 40 ns;
		
		-- Number 1-34
		random_number <= "00000000000000000000000000100010";
		wait for 40 ns;
		
		-- Number 1-35
		random_number <= "00000000000000000000000000100011";
		wait for 40 ns;
		
		-- Number 1-36
		random_number <= "00000000000000000000000000100100";
		wait for 40 ns;
		
		-- Number 1-37
		random_number <= "00000000000000000000000000100101";
		wait for 40 ns;
		
		-- Number 1-38
		random_number <= "00000000000000000000000000100110";
		wait for 40 ns;
		
		-- Number 1-39
		random_number <= "00000000000000000000000000100111";
		wait for 40 ns;
		
		-- Number 1-40
		random_number <= "00000000000000000000000000101000";
		wait for 40 ns;
		
		-- Number 1-41
		random_number <= "00000000000000000000000000101001";
		wait for 40 ns;
		
		-- Number 1-42
		random_number <= "00000000000000000000000000101010";
		wait for 40 ns;
		
		-- Number 1-43
		random_number <= "00000000000000000000000000101011";
		wait for 40 ns;
		
		-- Number 1-44
		random_number <= "00000000000000000000000000101100";
		wait for 40 ns;
		
		-- Number 1-45
		random_number <= "00000000000000000000000000101101";
		wait for 40 ns;
		
		-- Number 1-46
		random_number <= "00000000000000000000000000101110";
		wait for 40 ns;
		
		-- Number 1-47
		random_number <= "00000000000000000000000000101111";
		wait for 40 ns;
		
		-- Number 1-48
		random_number <= "00000000000000000000000000110000";
		wait for 40 ns;
		
		-- Number 1-49
		random_number <= "00000000000000000000000000110001";
		wait for 40 ns;
		
		-- Number 1-50
		random_number <= "00000000000000000000000000110010";
		wait for 40 ns;
		
		-- Number 1-51
		random_number <= "00000000000000000000000000110011";
		wait for 40 ns;
		
		-- Number 1-52
		random_number <= "00000000000000000000000000110100";
		wait for 40 ns;
		
		-- Number 1-53
		random_number <= "00000000000000000000000000110101";
		wait for 40 ns;
		
		-- Number 1-54
		random_number <= "00000000000000000000000000110110";
		wait for 40 ns;
		
		-- Number 1-55
		random_number <= "00000000000000000000000000110111";
		wait for 40 ns;
		
		-- Number 1-56
		random_number <= "00000000000000000000000000111000";
		wait for 40 ns;
		
		-- Number 1-57
		random_number <= "00000000000000000000000000111001";
		wait for 40 ns;
		
		-- Number 1-58
		random_number <= "00000000000000000000000000111010";
		wait for 40 ns;
		
		-- Number 1-59
		random_number <= "00000000000000000000000000111011";
		wait for 40 ns;
		
		-- Number 1-60
		random_number <= "00000000000000000000000000111100";
		wait for 40 ns;
		
		-- Number 1-61
		random_number <= "00000000000000000000000000111101";
		wait for 40 ns;
		
		-- Number 1-62
		random_number <= "00000000000000000000000000111110";
		wait for 40 ns;
		
		-- Number 1-63, adding extra waiting time
		random_number <= "00000000000000000000000000111111";
		wait for 200 ns;
		
		
		
		
		
		-- Now bit nr 2 will go from 0 to 63 for the next 63 tests, while bit nr 1 is 63
		-- Bit nr 2 is already 0, så starting test with 01:		
		
		-- Number 2-01
		random_number <= "00000000000000000000000001111111";
		wait for 40 ns;
		
		-- Number 2-02
		random_number <= "00000000000000000000000010111111";
		wait for 40 ns;
		
		-- Number 2-03
		random_number <= "00000000000000000000000011111111";
		wait for 40 ns;
		
		-- Number 2-04
		random_number <= "00000000000000000000000100111111";
		wait for 40 ns;
		
		-- Number 2-05
		random_number <= "00000000000000000000000101111111";
		wait for 40 ns;
		
		-- Number 2-06
		random_number <= "00000000000000000000000110111111";
		wait for 40 ns;
		
		-- Number 2-07
		random_number <= "00000000000000000000000111111111";
		wait for 40 ns;
		
		-- Number 2-08
		random_number <= "00000000000000000000001000111111";
		wait for 40 ns;
		
		-- Number 2-09
		random_number <= "00000000000000000000001001111111";
		wait for 40 ns;
		
		-- Number 2-10
		random_number <= "00000000000000000000001010111111";
		wait for 40 ns;
		
		-- Number 2-11
		random_number <= "00000000000000000000001011111111";
		wait for 40 ns;
		
		-- Number 2-12
		random_number <= "00000000000000000000001100111111";
		wait for 40 ns;
		
		-- Number 2-13
		random_number <= "00000000000000000000001101111111";
		wait for 40 ns;
		
		-- Number 2-14
		random_number <= "00000000000000000000001110111111";
		wait for 40 ns;
		
		-- Number 2-15
		random_number <= "00000000000000000000001111111111";
		wait for 40 ns;
		
		-- Number 2-16
		random_number <= "00000000000000000000010000111111";
		wait for 40 ns;
		
		-- Number 2-17
		random_number <= "00000000000000000000010001111111";
		wait for 40 ns;
		
		-- Number 2-18
		random_number <= "00000000000000000000010010111111";
		wait for 40 ns;
		
		-- Number 2-19
		random_number <= "00000000000000000000010011111111";
		wait for 40 ns;
		
		-- Number 2-20
		random_number <= "00000000000000000000010100111111";
		wait for 40 ns;
		
		-- Number 2-21
		random_number <= "00000000000000000000010101111111";
		wait for 40 ns;
		
		-- Number 2-22
		random_number <= "00000000000000000000010110111111";
		wait for 40 ns;
		
		-- Number 2-23
		random_number <= "00000000000000000000010111111111";
		wait for 40 ns;
		
		-- Number 2-24
		random_number <= "00000000000000000000011000111111";
		wait for 40 ns;
		
		-- Number 2-25
		random_number <= "00000000000000000000011001111111";
		wait for 40 ns;
		
		-- Number 2-26
		random_number <= "00000000000000000000011010111111";
		wait for 40 ns;
		
		-- Number 2-27
		random_number <= "00000000000000000000011011111111";
		wait for 40 ns;
		
		-- Number 2-28
		random_number <= "00000000000000000000011100111111";
		wait for 40 ns;
		
		-- Number 2-29
		random_number <= "00000000000000000000011101111111";
		wait for 40 ns;
		
		-- Number 2-30
		random_number <= "00000000000000000000011110111111";
		wait for 40 ns;
		
		-- Number 2-31
		random_number <= "00000000000000000000011111111111";
		wait for 40 ns;
		
		-- Number 2-32
		random_number <= "00000000000000000000100000111111";
		wait for 40 ns;
		
		-- Number 2-33
		random_number <= "00000000000000000000100001111111";
		wait for 40 ns;
		
		-- Number 2-34
		random_number <= "00000000000000000000100010111111";
		wait for 40 ns;
		
		-- Number 2-35
		random_number <= "00000000000000000000100011111111";
		wait for 40 ns;
		
		-- Number 2-36
		random_number <= "00000000000000000000100100111111";
		wait for 40 ns;
		
		-- Number 2-37
		random_number <= "00000000000000000000100101111111";
		wait for 40 ns;
		
		-- Number 2-38
		random_number <= "00000000000000000000100110111111";
		wait for 40 ns;
		
		-- Number 2-39
		random_number <= "00000000000000000000100111111111";
		wait for 40 ns;
		
		-- Number 2-40
		random_number <= "00000000000000000000101000111111";
		wait for 40 ns;
		
		-- Number 2-41
		random_number <= "00000000000000000000101001111111";
		wait for 40 ns;
		
		-- Number 2-42
		random_number <= "00000000000000000000101010111111";
		wait for 40 ns;
		
		-- Number 2-43
		random_number <= "00000000000000000000101011111111";
		wait for 40 ns;
		
		-- Number 2-44
		random_number <= "00000000000000000000101100111111";
		wait for 40 ns;
		
		-- Number 2-45
		random_number <= "00000000000000000000101101111111";
		wait for 40 ns;
		
		-- Number 2-46
		random_number <= "00000000000000000000101110111111";
		wait for 40 ns;
		
		-- Number 2-47
		random_number <= "00000000000000000000101111111111";
		wait for 40 ns;
		
		-- Number 2-48
		random_number <= "00000000000000000000110000111111";
		wait for 40 ns;
		
		-- Number 2-49
		random_number <= "00000000000000000000110001111111";
		wait for 40 ns;
		
		-- Number 2-50
		random_number <= "00000000000000000000110010111111";
		wait for 40 ns;
		
		-- Number 2-51
		random_number <= "00000000000000000000110011111111";
		wait for 40 ns;
		
		-- Number 2-52
		random_number <= "00000000000000000000110100111111";
		wait for 40 ns;
		
		-- Number 2-53
		random_number <= "00000000000000000000110101111111";
		wait for 40 ns;
		
		-- Number 2-54
		random_number <= "00000000000000000000110110111111";
		wait for 40 ns;
		
		-- Number 2-55
		random_number <= "00000000000000000000110111111111";
		wait for 40 ns;
		
		-- Number 2-56
		random_number <= "00000000000000000000111000111111";
		wait for 40 ns;
		
		-- Number 2-57
		random_number <= "00000000000000000000111001111111";
		wait for 40 ns;
		
		-- Number 2-58
		random_number <= "00000000000000000000111010111111";
		wait for 40 ns;
		
		-- Number 2-59
		random_number <= "00000000000000000000111011111111";
		wait for 40 ns;
		
		-- Number 2-60
		random_number <= "00000000000000000000111100111111";
		wait for 40 ns;
		
		-- Number 2-61
		random_number <= "00000000000000000000111101111111";
		wait for 40 ns;
		
		-- Number 2-62
		random_number <= "00000000000000000000111110111111";
		wait for 40 ns;
		
		-- Number 2-63
		random_number <= "00000000000000000000111111111111";
		
		-- End of test
		
      wait;
   end process;

END;
