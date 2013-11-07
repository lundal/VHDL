--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:56:53 10/10/2013
-- Design Name:   
-- Module Name:   C:/Users/torbjlan/VHDL/FPGAToplevel/crossover_core_xor_tb.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: crossover_core_xor
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
 
ENTITY crossover_core_xor_tb IS
END crossover_core_xor_tb;
 
ARCHITECTURE behavior OF crossover_core_xor_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT crossover_core_xor
    PORT(
         enabled : IN  std_logic;
         random_number1 : IN  std_logic_vector(31 downto 0);
			random_number2 : IN  std_logic_vector(31 downto 0);
         parent1 : IN  std_logic_vector(63 downto 0);
         parent2 : IN  std_logic_vector(63 downto 0);
         child1 : OUT  std_logic_vector(63 downto 0);
         child2 : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enabled : std_logic := '0';
   signal random_number1 : std_logic_vector(31 downto 0) := (others => '0');
	signal random_number2 : std_logic_vector(31 downto 0) := (others => '0');
   signal parent1 : std_logic_vector(63 downto 0) := (others => '0');
   signal parent2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal child1 : std_logic_vector(63 downto 0);
   signal child2 : std_logic_vector(63 downto 0);
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: crossover_core_xor PORT MAP (
          enabled => enabled,
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

		enabled <= '1';
		
		-- Choosing completely different bitpatterns (from now on referred to as "standard parents"):
		parent1 <= "1111111111111111111111111111111111111111111111111111111111111111";
		parent2 <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		--With this starting random_numbers, there should be 4-bit crossovers in children.
		--First four bits are not crossovers, while the four next are, then the four next not, etc.
		random_number1 <= "00001111000011110000111100001111";
		random_number2 <= "00001111000011110000111100001111";
		
		wait for 40 ns;
		
		-- Change in parents should cause change in children
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		wait for 40 ns;

		-- Change in random_number1 should cause change in children
		
		random_number1 <= "00001010000010100000101000001010";

		wait for 40 ns;
		
		-- Change in random_number2 should cause change in children
		
		random_number2 <= "00001110000011111111101000001010";

		wait for 40 ns;
		
		-- While not enabled, output should be only 0's
		enabled <= '0';
		
		wait for 40 ns;
		
		-- Change in parents or random_numbers should have no effect when not enabled
		parent1 <= "1111111111111111111111111111111111111111111111111111111111111111";
		parent2 <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		wait for 20 ns;
		
		random_number1 <= "00001111000011110000111100001111";
		
		wait for 20 ns;
		
		random_number2 <= "00001111000011110000111100001111";
		
		wait for 20 ns;
		
		parent1 <= "1111111100000000000000001111111111111111000000000000000011111111";
		parent2 <= "0000000000000000111111111111111100000000111111111111111100000000";
		
		random_number1 <= "11110000111100001111000011110000";
		random_number2 <= "11110000111100001111000011110000";
		
		wait for 20 ns;
		
		--Reenabling + crossover with same bit values in same bit nr at parents should yields same bits in children
		--(0's in bits 55-52 and 1's in 49-46)
		
		enabled <= '1';
		
		wait for 40 ns;
		
		-- Performing mass crossover with all bit values 1 in random_numbers
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		random_number1 <= (31 downto 0 => '1');
		random_number2 <= (31 downto 0 => '1');
		
		wait for 40 ns;
		
		-- Performing no crossober with all bit values 0 in random_numbers
		random_number1 <= (31 downto 0 => '0');
		random_number2 <= (31 downto 0 => '0');
		
		wait for 40 ns;
		
		-- For the next 65 tests, each bit value in random_number1, and then random_number2, is set one by one, with only one active at the time.
		-- These will test that each single bit is working
		
		-- Number 1-00
		random_number1 <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-01
		random_number1 <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 1-02
		random_number1 <= "00000000000000000000000000000010";
		wait for 40 ns;
		
		-- Number 1-03
		random_number1 <= "00000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 1-04
		random_number1 <= "00000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 1-05
		random_number1 <= "00000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 1-06
		random_number1 <= "00000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 1-07
		random_number1 <= "00000000000000000000000001000000";
		wait for 40 ns;
		
		-- Number 1-08
		random_number1 <= "00000000000000000000000010000000";
		wait for 40 ns;
		
		-- Number 1-09
		random_number1 <= "00000000000000000000000100000000";
		wait for 40 ns;
		
		-- Number 1-10
		random_number1 <= "00000000000000000000001000000000";
		wait for 40 ns;
		
		-- Number 1-11
		random_number1 <= "00000000000000000000010000000000";
		wait for 40 ns;
		
		-- Number 1-12
		random_number1 <= "00000000000000000000100000000000";
		wait for 40 ns;
		
		-- Number 1-13
		random_number1 <= "00000000000000000001000000000000";
		wait for 40 ns;
		
		-- Number 1-14
		random_number1 <= "00000000000000000010000000000000";
		wait for 40 ns;
		
		-- Number 1-15
		random_number1 <= "00000000000000000100000000000000";
		wait for 40 ns;
		
		-- Number 1-16
		random_number1 <= "00000000000000001000000000000000";
		wait for 40 ns;
		
		-- Number 1-17
		random_number1 <= "00000000000000010000000000000000";
		wait for 40 ns;
		
		-- Number 1-18
		random_number1 <= "00000000000000100000000000000000";
		wait for 40 ns;
		
		-- Number 1-19
		random_number1 <= "00000000000001000000000000000000";
		wait for 40 ns;
		
		-- Number 1-20
		random_number1 <= "00000000000010000000000000000000";
		wait for 40 ns;
		
		-- Number 1-21
		random_number1 <= "00000000000100000000000000000000";
		wait for 40 ns;
		
		-- Number 1-22
		random_number1 <= "00000000001000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-23
		random_number1 <= "00000000010000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-24
		random_number1 <= "00000000100000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-25
		random_number1 <= "00000001000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-26
		random_number1 <= "00000010000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-27
		random_number1 <= "00000100000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-28
		random_number1 <= "00001000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-29
		random_number1 <= "00010000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-30
		random_number1 <= "00100000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-31
		random_number1 <= "01000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-32
		random_number1 <= "10000000000000000000000000000000";
		wait for 40 ns;
		
		-- Then 32 for random_number2:
		
		-- Number 1-33
		random_number1 <= "00000000000000000000000000000000";
		random_number2 <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 1-34
		random_number2 <= "00000000000000000000000000000010";
		wait for 40 ns;
		
		-- Number 1-35
		random_number2 <= "00000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 1-36
		random_number2 <= "00000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 1-37
		random_number2 <= "00000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 1-38
		random_number2 <= "00000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 1-39
		random_number2 <= "00000000000000000000000001000000";
		wait for 40 ns;
		
		-- Number 1-40
		random_number2 <= "00000000000000000000000010000000";
		wait for 40 ns;
		
		-- Number 1-41
		random_number2 <= "00000000000000000000000100000000";
		wait for 40 ns;
		
		-- Number 1-42
		random_number2 <= "00000000000000000000001000000000";
		wait for 40 ns;
		
		-- Number 1-43
		random_number2 <= "00000000000000000000010000000000";
		wait for 40 ns;
		
		-- Number 1-44
		random_number2 <= "00000000000000000000100000000000";
		wait for 40 ns;
		
		-- Number 1-45
		random_number2 <= "00000000000000000001000000000000";
		wait for 40 ns;
		
		-- Number 1-46
		random_number2 <= "00000000000000000010000000000000";
		wait for 40 ns;
		
		-- Number 1-47
		random_number2 <= "00000000000000000100000000000000";
		wait for 40 ns;
		
		-- Number 1-48
		random_number2 <= "00000000000000001000000000000000";
		wait for 40 ns;
		
		-- Number 1-49
		random_number2 <= "00000000000000010000000000000000";
		wait for 40 ns;
		
		-- Number 1-50
		random_number2 <= "00000000000000100000000000000000";
		wait for 40 ns;
		
		-- Number 1-51
		random_number2 <= "00000000000001000000000000000000";
		wait for 40 ns;
		
		-- Number 1-52
		random_number2 <= "00000000000010000000000000000000";
		wait for 40 ns;
		
		-- Number 1-53
		random_number2 <= "00000000000100000000000000000000";
		wait for 40 ns;
		
		-- Number 1-54
		random_number2 <= "00000000001000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-55
		random_number2 <= "00000000010000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-56
		random_number2 <= "00000000100000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-57
		random_number2 <= "00000001000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-58
		random_number2 <= "00000010000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-59
		random_number2 <= "00000100000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-60
		random_number2 <= "00001000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-61
		random_number2 <= "00010000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-62
		random_number2 <= "00100000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-63
		random_number2 <= "01000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-64
		random_number2 <= "10000000000000000000000000000000";
		wait for 40 ns;
		
		-- For the next 65 tests, all bits in random_number1 and then random_number2 will be set to 1, one by one, from right to left
		
		-- Number 2-00
		random_number1 <= "00000000000000000000000000000000";
		random_number2 <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 2-01
		random_number1 <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 2-02
		random_number1 <= "00000000000000000000000000000011";
		wait for 40 ns;
		
		-- Number 2-03
		random_number1 <= "00000000000000000000000000000111";
		wait for 40 ns;
		
		-- Number 2-04
		random_number1 <= "00000000000000000000000000001111";
		wait for 40 ns;
		
		-- Number 2-05
		random_number1 <= "00000000000000000000000000011111";
		wait for 40 ns;
		
		-- Number 2-06
		random_number1 <= "00000000000000000000000000111111";
		wait for 40 ns;
		
		-- Number 2-07
		random_number1 <= "00000000000000000000000001111111";
		wait for 40 ns;
		
		-- Number 2-08
		random_number1 <= "00000000000000000000000011111111";
		wait for 40 ns;
		
		-- Number 2-09
		random_number1 <= "00000000000000000000000111111111";
		wait for 40 ns;
		
		-- Number 2-10
		random_number1 <= "00000000000000000000001111111111";
		wait for 40 ns;
		
		-- Number 2-11
		random_number1 <= "00000000000000000000011111111111";
		wait for 40 ns;
		
		-- Number 2-12
		random_number1 <= "00000000000000000000111111111111";
		wait for 40 ns;
		
		-- Number 2-13
		random_number1 <= "00000000000000000001111111111111";
		wait for 40 ns;
		
		-- Number 2-14
		random_number1 <= "00000000000000000011111111111111";
		wait for 40 ns;
		
		-- Number 2-15
		random_number1 <= "00000000000000000111111111111111";
		wait for 40 ns;
		
		-- Number 2-16
		random_number1 <= "00000000000000001111111111111111";
		wait for 40 ns;
		
		-- Number 2-17
		random_number1 <= "00000000000000011111111111111111";
		wait for 40 ns;
		
		-- Number 2-18
		random_number1 <= "00000000000000111111111111111111";
		wait for 40 ns;
		
		-- Number 2-19
		random_number1 <= "00000000000001111111111111111111";
		wait for 40 ns;
		
		-- Number 2-20
		random_number1 <= "00000000000011111111111111111111";
		wait for 40 ns;
		
		-- Number 2-21
		random_number1 <= "00000000000111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-22
		random_number1 <= "00000000001111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-23
		random_number1 <= "00000000011111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-24
		random_number1 <= "00000000111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-25
		random_number1 <= "00000001111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-26
		random_number1 <= "00000011111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-27
		random_number1 <= "00000111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-28
		random_number1 <= "00001111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-29
		random_number1 <= "00011111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-30
		random_number1 <= "00111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-31
		random_number1 <= "01111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-32
		random_number1 <= "11111111111111111111111111111111";
		wait for 40 ns;
		
		-- Then random_number2:
		
		-- Number 2-33
		random_number2 <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 2-34
		random_number2 <= "00000000000000000000000000000011";
		wait for 40 ns;
		
		-- Number 2-35
		random_number2 <= "00000000000000000000000000000111";
		wait for 40 ns;
		
		-- Number 2-36
		random_number2 <= "00000000000000000000000000001111";
		wait for 40 ns;
		
		-- Number 2-37
		random_number2 <= "00000000000000000000000000011111";
		wait for 40 ns;
		
		-- Number 2-38
		random_number2 <= "00000000000000000000000000111111";
		wait for 40 ns;
		
		-- Number 2-39
		random_number2 <= "00000000000000000000000001111111";
		wait for 40 ns;
		
		-- Number 2-40
		random_number2 <= "00000000000000000000000011111111";
		wait for 40 ns;
		
		-- Number 2-41
		random_number2 <= "00000000000000000000000111111111";
		wait for 40 ns;
		
		-- Number 2-42
		random_number2 <= "00000000000000000000001111111111";
		wait for 40 ns;
		
		-- Number 2-43
		random_number2 <= "00000000000000000000011111111111";
		wait for 40 ns;
		
		-- Number 2-44
		random_number2 <= "00000000000000000000111111111111";
		wait for 40 ns;
		
		-- Number 2-45
		random_number2 <= "00000000000000000001111111111111";
		wait for 40 ns;
		
		-- Number 2-46
		random_number2 <= "00000000000000000011111111111111";
		wait for 40 ns;
		
		-- Number 2-47
		random_number2 <= "00000000000000000111111111111111";
		wait for 40 ns;
		
		-- Number 2-48
		random_number2 <= "00000000000000001111111111111111";
		wait for 40 ns;
		
		-- Number 2-49
		random_number2 <= "00000000000000011111111111111111";
		wait for 40 ns;
		
		-- Number 2-50
		random_number2 <= "00000000000000111111111111111111";
		wait for 40 ns;
		
		-- Number 2-51
		random_number2 <= "00000000000001111111111111111111";
		wait for 40 ns;
		
		-- Number 2-52
		random_number2 <= "00000000000011111111111111111111";
		wait for 40 ns;
		
		-- Number 2-53
		random_number2 <= "00000000000111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-54
		random_number2 <= "00000000001111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-55
		random_number2 <= "00000000011111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-56
		random_number2 <= "00000000111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-57
		random_number2 <= "00000001111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-58
		random_number2 <= "00000011111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-59
		random_number2 <= "00000111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-60
		random_number2 <= "00001111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-61
		random_number2 <= "00011111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-62
		random_number2 <= "00111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-63
		random_number2 <= "01111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-64
		random_number2 <= "11111111111111111111111111111111";
		wait for 40 ns;
		
		-- The next 65 tests, all bits in random_number1 then random_number2 will be set to 0, one by one, from right to left
		
		-- Number 3-00
		random_number1 <= "11111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 3-01
		random_number1 <= "11111111111111111111111111111110";
		wait for 40 ns;
		
		-- Number 3-02
		random_number1 <= "11111111111111111111111111111100";
		wait for 40 ns;
		
		-- Number 3-03
		random_number1 <= "11111111111111111111111111111000";
		wait for 40 ns;
		
		-- Number 3-04
		random_number1 <= "11111111111111111111111111110000";
		wait for 40 ns;
		
		-- Number 3-05
		random_number1 <= "11111111111111111111111111100000";
		wait for 40 ns;
		
		-- Number 3-06
		random_number1 <= "11111111111111111111111111000000";
		wait for 40 ns;
		
		-- Number 3-07
		random_number1 <= "11111111111111111111111110000000";
		wait for 40 ns;
		
		-- Number 3-08
		random_number1 <= "11111111111111111111111100000000";
		wait for 40 ns;
		
		-- Number 3-09
		random_number1 <= "11111111111111111111111000000000";
		wait for 40 ns;
		
		-- Number 3-10
		random_number1 <= "11111111111111111111110000000000";
		wait for 40 ns;
		
		-- Number 3-11
		random_number1 <= "11111111111111111111100000000000";
		wait for 40 ns;
		
		-- Number 3-12
		random_number1 <= "11111111111111111111000000000000";
		wait for 40 ns;
		
		-- Number 3-13
		random_number1 <= "11111111111111111110000000000000";
		wait for 40 ns;
		
		-- Number 3-14
		random_number1 <= "11111111111111111100000000000000";
		wait for 40 ns;
		
		-- Number 3-15
		random_number1 <= "11111111111111111000000000000000";
		wait for 40 ns;
		
		-- Number 3-16
		random_number1 <= "11111111111111110000000000000000";
		wait for 40 ns;
		
		-- Number 3-17
		random_number1 <= "11111111111111100000000000000000";
		wait for 40 ns;
		
		-- Number 3-18
		random_number1 <= "11111111111111000000000000000000";
		wait for 40 ns;
		
		-- Number 3-19
		random_number1 <= "11111111111110000000000000000000";
		wait for 40 ns;
		
		-- Number 3-20
		random_number1 <= "11111111111100000000000000000000";
		wait for 40 ns;
		
		-- Number 3-21
		random_number1 <= "11111111111000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-22
		random_number1 <= "11111111110000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-23
		random_number1 <= "11111111100000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-24
		random_number1 <= "11111111000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-25
		random_number1 <= "11111110000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-26
		random_number1 <= "11111100000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-27
		random_number1 <= "11111000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-28
		random_number1 <= "11110000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-29
		random_number1 <= "11100000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-30
		random_number1 <= "11000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-31
		random_number1 <= "10000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-32
		random_number1 <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Then random_number2:
		
		-- Number 3-33
		random_number2 <= "11111111111111111111111111111110";
		wait for 40 ns;
		
		-- Number 3-34
		random_number2 <= "11111111111111111111111111111100";
		wait for 40 ns;
		
		-- Number 3-35
		random_number2 <= "11111111111111111111111111111000";
		wait for 40 ns;
		
		-- Number 3-36
		random_number2 <= "11111111111111111111111111110000";
		wait for 40 ns;
		
		-- Number 3-37
		random_number2 <= "11111111111111111111111111100000";
		wait for 40 ns;
		
		-- Number 3-38
		random_number2 <= "11111111111111111111111111000000";
		wait for 40 ns;
		
		-- Number 3-39
		random_number2 <= "11111111111111111111111110000000";
		wait for 40 ns;
		
		-- Number 3-40
		random_number2 <= "11111111111111111111111100000000";
		wait for 40 ns;
		
		-- Number 3-41
		random_number2 <= "11111111111111111111111000000000";
		wait for 40 ns;
		
		-- Number 3-42
		random_number2 <= "11111111111111111111110000000000";
		wait for 40 ns;
		
		-- Number 3-43
		random_number2 <= "11111111111111111111100000000000";
		wait for 40 ns;
		
		-- Number 3-44
		random_number2 <= "11111111111111111111000000000000";
		wait for 40 ns;
		
		-- Number 3-45
		random_number2 <= "11111111111111111110000000000000";
		wait for 40 ns;
		
		-- Number 3-46
		random_number2 <= "11111111111111111100000000000000";
		wait for 40 ns;
		
		-- Number 3-47
		random_number2 <= "11111111111111111000000000000000";
		wait for 40 ns;
		
		-- Number 3-48
		random_number2 <= "11111111111111110000000000000000";
		wait for 40 ns;
		
		-- Number 3-49
		random_number2 <= "11111111111111100000000000000000";
		wait for 40 ns;
		
		-- Number 3-50
		random_number2 <= "11111111111111000000000000000000";
		wait for 40 ns;
		
		-- Number 3-51
		random_number2 <= "11111111111110000000000000000000";
		wait for 40 ns;
		
		-- Number 3-52
		random_number2 <= "11111111111100000000000000000000";
		wait for 40 ns;
		
		-- Number 3-53
		random_number2 <= "11111111111000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-54
		random_number2 <= "11111111110000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-55
		random_number2 <= "11111111100000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-56
		random_number2 <= "11111111000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-57
		random_number2 <= "11111110000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-58
		random_number2 <= "11111100000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-59
		random_number2 <= "11111000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-60
		random_number2 <= "11110000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-61
		random_number2 <= "11100000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-62
		random_number2 <= "11000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-63
		random_number2 <= "10000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-64
		random_number2 <= "00000000000000000000000000000000";
		wait for 40 ns;
		
      wait;
   end process;

END;
