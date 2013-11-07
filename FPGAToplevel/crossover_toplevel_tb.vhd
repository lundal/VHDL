--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:06:17 11/02/2013
-- Design Name:   
-- Module Name:   C:/Users/torbjlan/VHDL/FPGAToplevel/crossover_toplevel_tb.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: crossover_toplevel
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
 
ENTITY crossover_toplevel_tb IS
END crossover_toplevel_tb;
 
ARCHITECTURE behavior OF crossover_toplevel_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT crossover_toplevel
    PORT(
         control_input : IN  std_logic_vector(2 downto 0);
         random_number : IN  std_logic_vector(63 downto 0);
         parent1 : IN  std_logic_vector(63 downto 0);
         parent2 : IN  std_logic_vector(63 downto 0);
         child1 : OUT  std_logic_vector(63 downto 0);
         child2 : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal control_input : std_logic_vector(2 downto 0) := (others => '0');
   signal random_number : std_logic_vector(63 downto 0) := (others => '0');
   signal parent1 : std_logic_vector(63 downto 0) := (others => '0');
   signal parent2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal child1 : std_logic_vector(63 downto 0);
   signal child2 : std_logic_vector(63 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: crossover_toplevel PORT MAP (
          control_input => control_input,
          random_number => random_number,
          parent1 => parent1,
          parent2 => parent2,
          child1 => child1,
          child2 => child2
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 100 ns;
		
		-- The goal with this test is to verify that selecting core based in control input is working
		-- The goal is not to test the cores themselves, therefore there will be minimum changes on
		-- parent inputs and random_number.
		-- There will be changes in random_number in order to test random core selection
		
		-- Setting inputs:
		parent1 <= "1111111111111111111111111111111111111111111111111111111111111111";
		parent2 <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		-- Setting random_number. Notice that random_number_ff is set in the next clock_cycle
		-- Setting 6 least significant bits to value 49, and 6 next bits to 23. These are useful for split and doublesplit
		random_number <= "0000000000000000000000000000000000000000000000000000010111110001";
		
		-- Testing selection of core_split first: Setting control_input to "00"
		control_input <= "000";
		
		wait for 40 ns;
		
		-- Now testing selection of core_doublesplit first: Setting control_input to "01"
		control_input <="001";
		
		wait for 40 ns;
		
		-- Now testing selection of core_xor
		control_input <="010";
		
		wait for 40 ns;
		
		-- Now testing OFF-selection. Parents should simply be passed on
		control_input <="011";
		
		wait for 40 ns;
		
		-- Now testing selecting random use of cores (also known as "Party Mode"):
		-- First two most significant bits in random_number is "00", so expected core is core_split
		
		control_input <= "100";
		
		wait for 40 ns;
		
		-- Now setting random_number so that core_doublesplit is selected
		-- First two most significant bits are "01"
		random_number <= "0100000000000000000000000000000000000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Now setting random_number so that core_xor is selected
		-- First two most significant bits are "10"
		random_number <= "1000000000000000000000000000000000000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Now setting random_number so that no crossover happens, and the parents are simply passed on
		-- First two significant bits are "11"
		random_number <= "1100000000000000000000000000000000000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Setting control input to any value "1XX" should still enable party mode.
		-- Using random selection of core_split for these tests
		random_number <= "0000000000000000000000000000000000000000000000000000010111110001";
		
		wait for 10 ns;
		
		control_input <= "101";
		
		wait for 10 ns;
		
		control_input <= "110";
		
		wait for 10 ns;
		
		control_input <= "111";
		
      wait;
   end process;

END;
