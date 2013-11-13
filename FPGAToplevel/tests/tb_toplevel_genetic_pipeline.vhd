LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_toplevel_genetic_pipeline IS
END tb_toplevel_genetic_pipeline;
 
ARCHITECTURE behavior OF tb_toplevel_genetic_pipeline IS 
 
    COMPONENT toplevel_genetic_pipeline
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         genetic_pipeline_enable : IN  std_logic;
         data_in : IN  std_logic_vector(63 downto 0);
         rated_pool_addr : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal genetic_pipeline_enable : std_logic := '0';
   signal data_in : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal rated_pool_addr : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: toplevel_genetic_pipeline PORT MAP (
          clk => clk,
          reset => reset,
          genetic_pipeline_enable => genetic_pipeline_enable,
          data_in => data_in,
          rated_pool_addr => rated_pool_addr
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
      reset <= '1';
      wait for 100 ns;	
      reset <= '0';
      wait for clk_period*10;
      genetic_pipeline_enable <= '1';
      
      --Fake memory
      wait for clk_period*1;
      data_in <= "0000000000000000000000000000000000000000000000000000000000000001";
      wait for clk_period*2;
      data_in <= "0000000000000000000000000000000000000000000000000000000000000010";



       

      -- insert stimulus here 

      wait;
   end process;

END;
