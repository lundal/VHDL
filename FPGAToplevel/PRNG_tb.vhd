LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY PRNG_tb IS
END PRNG_tb;
 
ARCHITECTURE behavior OF PRNG_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PRNG
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         load : IN  std_logic;
         seed : IN  std_logic_vector(31 downto 0);
         rnd_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal load : std_logic := '0';
   signal seed : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal rnd_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PRNG PORT MAP (
          clk => clk,
          reset => reset,
          load => load,
          seed => seed,
          rnd_out => rnd_out
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
      reset <= '0';
      wait for clk_period*5;
      reset <= '1';

      -- insert stimulus here 
		
		--Random number generator should be produsing different outputs at each clock cyccle
		
		wait for clk_period*5;
		reset<='0';
		
		wait for clk_period*4;
		
		--Activating load signal
		load<='1';
		
		wait for clk_period*4;
		
		--Dectivating load signal and resetting
		load<='0';
		reset<='1';
		
		wait for clk_period*2;
		
		--Activating load signal and havind a seed-value
		reset<='0';
		seed<= "00001010000010100000101000001010";
		load<='1';
		
		wait for clk_period*4;
		
		--Deactivating load, keep pouring out random generated outputs
		load<='0';

      wait;
   end process;

END;
