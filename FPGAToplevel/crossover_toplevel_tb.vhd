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
         clk : IN  std_logic;
         enabled : IN  std_logic;
         control_input : IN  std_logic_vector(1 downto 0);
         random_number : IN  std_logic_vector(31 downto 0);
         parent1 : IN  std_logic_vector(63 downto 0);
         parent2 : IN  std_logic_vector(63 downto 0);
         child1 : OUT  std_logic_vector(63 downto 0);
         child2 : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal enabled : std_logic := '0';
   signal control_input : std_logic_vector(1 downto 0) := (others => '0');
   signal random_number : std_logic_vector(31 downto 0) := (others => '0');
   signal parent1 : std_logic_vector(63 downto 0) := (others => '0');
   signal parent2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal child1 : std_logic_vector(63 downto 0);
   signal child2 : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: crossover_toplevel PORT MAP (
          clk => clk,
          enabled => enabled,
          control_input => control_input,
          random_number => random_number,
          parent1 => parent1,
          parent2 => parent2,
          child1 => child1,
          child2 => child2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 100 ns;
		
		-- The goal with this test is to verify that selecting core based in control input is working
		-- The goal is not to test the cores themselves, therefore there will be minimum changes on
		-- parent inputs and rancom_number.
		-- There will be changes in random_number in order to test the combination with the flip_flop,
		-- and random core selection
		
		enabled <= '1';
		-- Setting inputs:
		parent1 <= "1111111111111111111111111111111111111111111111111111111111111111";
		parent2 <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		-- Setting random_number. Notice that random_number_ff is set in the next clock_cycle
		-- Setting 6 least significant bits to value 49, and 6 next bits to 23. These are useful for split and doublesplit
		random_number <= "00000000000000000000010111110001";
		
		-- Testing selection of core_split first: Setting control_input to "00"
		control_input <= "00";
		
		wait for 40 ns;
		
		-- Now testing selection of core_doublesplit first: Setting control_input to "01"
		control_input <="01";
		
		wait for 40 ns;
		
		-- Now testing selection of core_xor
		control_input <="10";
		
		wait for 45 ns;
		
		-- Changing input on random_number, to verify that random_number is set to random_number_ff during next cycle
		-- This should cause both random_number_inputs to be different at all times on the final implementation, 
		-- when output from PRNG changes at every cycle
		
		random_number <= "00000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Not testing selecting random use of cores:
		-- First two most significant bits in random_number is "00", so expected core is core_split
		
		control_input <= "11";
		
		wait for 40 ns;
		
		-- If the first two most significant bits in random_number is "01", core is still core_split
		random_number <= "01000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Now setting random_number so that core_doublesplit is selected
		-- First two significant bits are "10"
		random_number <= "10000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Now setting random_number so that core_xor is selected
		-- First two significant bits are "11"
		random_number <= "11000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Disabling enabled should set outputs to 0's
		
		enabled <= '0';
		
		wait for 40 ns;
		
		-- Enabling
		
		enabled <= '1';
		
      wait;
   end process;

END;
