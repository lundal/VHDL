LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_crossover_toplevel IS
END tb_crossover_toplevel;
 
ARCHITECTURE behavior OF tb_crossover_toplevel IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT crossover_toplevel
    PORT(
         clk : IN  std_logic;
         enabled : IN  std_logic;
         control_input : IN  std_logic_vector(2 downto 0);
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
   signal control_input : std_logic_vector(2 downto 0) := (others => '0');
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
		control_input <= "000";
		
		wait for 40 ns;
		
		-- Now testing selection of core_doublesplit first: Setting control_input to "01"
		control_input <="001";
		
		wait for 40 ns;
		
		-- Now testing selection of core_xor
		control_input <="010";
		
		wait for 46 ns;
		
		-- Changing input on random_number, to verify that random_number is set to random_number_ff during next cycle
		-- This should cause both random_number_inputs to be different at all times on the final implementation, 
		-- when output from PRNG changes at every cycle
		
		random_number <= "00000000111100000000010111110001";
		
		wait for 40 ns;
		
		-- Not testing selecting random use of cores:
		-- First two most significant bits in random_number is "00", so expected core is core_split
		
		control_input <= "011";
		
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
		
		wait for 40 ns;
		
		-- Setting control input to any value "1XX" should disbale crossover altogether.
		-- Output is then same as parents
		control_input <= "100";
		
		wait for 10 ns;
		
		control_input <= "101";
		
		wait for 10 ns;
		
		control_input <= "110";
		
		wait for 10 ns;
		
		control_input <= "111";
		
		wait for 10 ns;
		
      wait;
   end process;

END;
