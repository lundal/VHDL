--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:56:53 10/10/2013
-- Design Name:   
-- Module Name:   C:/Users/torbjlan/VHDL/FPGAToplevel/crossover_core_advanced_tb.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: crossover_core_advanced
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
 
ENTITY crossover_core_advanced_tb IS
END crossover_core_advanced_tb;
 
ARCHITECTURE behavior OF crossover_core_advanced_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT crossover_core_advanced
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
 
	-- Instantiate the Unit Under Test (UUT)
   uut: crossover_core_advanced PORT MAP (
          enabled => enabled,
          random_number => random_number,
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
		
		--With this starting random_number, there should be 4-bit crossovers in children.
		--First four bits are not crossovers, while the four next are, then the four next not, etc.
		random_number <= "00001111000011110000111100001111";
		
		wait for 40 ns;
		
		-- Change in parents should cause change in children
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		wait for 40 ns;

		-- Change in random_number should cause change in children
		
		random_number <= "00001010000010100000101000001010";

		wait for 40 ns;
		
		-- While not enabled, output should be only 0's
		enabled <= '0';
		
		wait for 40 ns;
		
		-- Change in parents or random_number should have no effect when not enabled
		parent1 <= "1111111111111111111111111111111111111111111111111111111111111111";
		parent2 <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		wait for 20 ns;
		
		random_number <= "00001111000011110000111100001111";
		
		wait for 20 ns;
		
		parent1 <= "1111111100000000000000001111111111111111000000000000000011111111";
		parent2 <= "0000000000000000111111111111111100000000111111111111111100000000";
		
		random_number <= "11110000111100001111000011110000";
		
		wait for 20 ns;
		
		--Reenabling + crossover with same bit values in same bit nr at parents should yields same bits in children
		--(0's in bits 55-52 and 1's in 49-46)
		
		enabled <= '1';
		
		wait for 40 ns;
		
		-- Performing mass crossover with all bit values 1 in random_number
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		random_number <= (31 downto 0 => '1');
		
		wait for 40 ns;
		
		-- Performing no crossober with all bit values 0 in random_number
		random_number <= (31 downto 0 => '0');
		
		wait for 40 ns;
		
		-- For the next 33 tests, each bit value in the random_number is set one by one, with only one active at the time:
		-- These will test that each single bit is working
		
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
		random_number <= "00000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 1-04
		random_number <= "00000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 1-05
		random_number <= "00000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 1-06
		random_number <= "00000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 1-07
		random_number <= "00000000000000000000000001000000";
		wait for 40 ns;
		
		-- Number 1-08
		random_number <= "00000000000000000000000010000000";
		wait for 40 ns;
		
		-- Number 1-09
		random_number <= "00000000000000000000000100000000";
		wait for 40 ns;
		
		-- Number 1-10
		random_number <= "00000000000000000000001000000000";
		wait for 40 ns;
		
		-- Number 1-11
		random_number <= "00000000000000000000010000000000";
		wait for 40 ns;
		
		-- Number 1-12
		random_number <= "00000000000000000000100000000000";
		wait for 40 ns;
		
		-- Number 1-13
		random_number <= "00000000000000000001000000000000";
		wait for 40 ns;
		
		-- Number 1-14
		random_number <= "00000000000000000010000000000000";
		wait for 40 ns;
		
		-- Number 1-15
		random_number <= "00000000000000000100000000000000";
		wait for 40 ns;
		
		-- Number 1-16
		random_number <= "00000000000000001000000000000000";
		wait for 40 ns;
		
		-- Number 1-17
		random_number <= "00000000000000010000000000000000";
		wait for 40 ns;
		
		-- Number 1-18
		random_number <= "00000000000000100000000000000000";
		wait for 40 ns;
		
		-- Number 1-19
		random_number <= "00000000000001000000000000000000";
		wait for 40 ns;
		
		-- Number 1-20
		random_number <= "00000000000010000000000000000000";
		wait for 40 ns;
		
		-- Number 1-21
		random_number <= "00000000000100000000000000000000";
		wait for 40 ns;
		
		-- Number 1-22
		random_number <= "00000000001000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-23
		random_number <= "00000000010000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-24
		random_number <= "00000000100000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-25
		random_number <= "00000001000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-26
		random_number <= "00000010000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-27
		random_number <= "00000100000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-28
		random_number <= "00001000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-29
		random_number <= "00010000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-30
		random_number <= "00100000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-31
		random_number <= "01000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 1-32
		random_number <= "10000000000000000000000000000000";
		wait for 40 ns;
		
		-- For the next 33 tests, all bits in random_number will be set to 1, one by one, from right to left
		
		-- Number 2-00
		random_number <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 2-01
		random_number <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 2-02
		random_number <= "00000000000000000000000000000011";
		wait for 40 ns;
		
		-- Number 2-03
		random_number <= "00000000000000000000000000000111";
		wait for 40 ns;
		
		-- Number 2-04
		random_number <= "00000000000000000000000000001111";
		wait for 40 ns;
		
		-- Number 2-05
		random_number <= "00000000000000000000000000011111";
		wait for 40 ns;
		
		-- Number 2-06
		random_number <= "00000000000000000000000000111111";
		wait for 40 ns;
		
		-- Number 2-07
		random_number <= "00000000000000000000000001111111";
		wait for 40 ns;
		
		-- Number 2-08
		random_number <= "00000000000000000000000011111111";
		wait for 40 ns;
		
		-- Number 2-09
		random_number <= "00000000000000000000000111111111";
		wait for 40 ns;
		
		-- Number 2-10
		random_number <= "00000000000000000000001111111111";
		wait for 40 ns;
		
		-- Number 2-11
		random_number <= "00000000000000000000011111111111";
		wait for 40 ns;
		
		-- Number 2-12
		random_number <= "00000000000000000000111111111111";
		wait for 40 ns;
		
		-- Number 2-13
		random_number <= "00000000000000000001111111111111";
		wait for 40 ns;
		
		-- Number 2-14
		random_number <= "00000000000000000011111111111111";
		wait for 40 ns;
		
		-- Number 2-15
		random_number <= "00000000000000000111111111111111";
		wait for 40 ns;
		
		-- Number 2-16
		random_number <= "00000000000000001111111111111111";
		wait for 40 ns;
		
		-- Number 2-17
		random_number <= "00000000000000011111111111111111";
		wait for 40 ns;
		
		-- Number 2-18
		random_number <= "00000000000000111111111111111111";
		wait for 40 ns;
		
		-- Number 2-19
		random_number <= "00000000000001111111111111111111";
		wait for 40 ns;
		
		-- Number 2-20
		random_number <= "00000000000011111111111111111111";
		wait for 40 ns;
		
		-- Number 2-21
		random_number <= "00000000000111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-22
		random_number <= "00000000001111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-23
		random_number <= "00000000011111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-24
		random_number <= "00000000111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-25
		random_number <= "00000001111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-26
		random_number <= "00000011111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-27
		random_number <= "00000111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-28
		random_number <= "00001111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-29
		random_number <= "00011111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-30
		random_number <= "00111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-31
		random_number <= "01111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 2-32
		random_number <= "11111111111111111111111111111111";
		wait for 40 ns;
		
		-- The next 33 tests, all bits in random_numberwill be set to 0, one by one, from right to left
		
		-- Number 3-00
		random_number <= "11111111111111111111111111111111";
		wait for 40 ns;
		
		-- Number 3-01
		random_number <= "11111111111111111111111111111110";
		wait for 40 ns;
		
		-- Number 3-02
		random_number <= "11111111111111111111111111111100";
		wait for 40 ns;
		
		-- Number 3-03
		random_number <= "11111111111111111111111111111000";
		wait for 40 ns;
		
		-- Number 3-04
		random_number <= "11111111111111111111111111110000";
		wait for 40 ns;
		
		-- Number 3-05
		random_number <= "11111111111111111111111111100000";
		wait for 40 ns;
		
		-- Number 3-06
		random_number <= "11111111111111111111111111000000";
		wait for 40 ns;
		
		-- Number 3-07
		random_number <= "11111111111111111111111110000000";
		wait for 40 ns;
		
		-- Number 3-08
		random_number <= "11111111111111111111111100000000";
		wait for 40 ns;
		
		-- Number 3-09
		random_number <= "11111111111111111111111000000000";
		wait for 40 ns;
		
		-- Number 3-10
		random_number <= "11111111111111111111110000000000";
		wait for 40 ns;
		
		-- Number 3-11
		random_number <= "11111111111111111111100000000000";
		wait for 40 ns;
		
		-- Number 3-12
		random_number <= "11111111111111111111000000000000";
		wait for 40 ns;
		
		-- Number 3-13
		random_number <= "11111111111111111110000000000000";
		wait for 40 ns;
		
		-- Number 3-14
		random_number <= "11111111111111111100000000000000";
		wait for 40 ns;
		
		-- Number 3-15
		random_number <= "11111111111111111000000000000000";
		wait for 40 ns;
		
		-- Number 3-16
		random_number <= "11111111111111110000000000000000";
		wait for 40 ns;
		
		-- Number 3-17
		random_number <= "11111111111111100000000000000000";
		wait for 40 ns;
		
		-- Number 3-18
		random_number <= "11111111111111000000000000000000";
		wait for 40 ns;
		
		-- Number 3-19
		random_number <= "11111111111110000000000000000000";
		wait for 40 ns;
		
		-- Number 3-20
		random_number <= "11111111111100000000000000000000";
		wait for 40 ns;
		
		-- Number 3-21
		random_number <= "11111111111000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-22
		random_number <= "11111111110000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-23
		random_number <= "11111111100000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-24
		random_number <= "11111111000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-25
		random_number <= "11111110000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-26
		random_number <= "11111100000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-27
		random_number <= "11111000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-28
		random_number <= "11110000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-29
		random_number <= "11100000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-30
		random_number <= "11000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-31
		random_number <= "10000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 3-32
		random_number <= "00000000000000000000000000000000";
		wait for 40 ns;
		
      wait;
   end process;

END;
