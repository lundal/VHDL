LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
 
ENTITY tb_fitness_core IS
END tb_fitness_core;
 
ARCHITECTURE behavior OF tb_fitness_core IS 
 
    COMPONENT fitness_core
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         processor_enable : IN  std_logic;
         halt_inst : IN  std_logic;
         imem_address : OUT  std_logic_vector(31 downto 0);
         imem_data_in : IN  std_logic_vector(31 downto 0);
         request_bus_data : OUT  std_logic;
         ack_mem_ctrl : IN  std_logic;
         dmem_data_in : IN  std_logic_vector(63 downto 0);
         dmem_address : OUT  std_logic_vector(18 downto 0);
         dmem_address_wr : OUT  std_logic_vector(63 downto 0);
         dmem_data_out : OUT  std_logic_vector(63 downto 0);
         dmem_write_enable : OUT  std_logic;
         pmem_data_out : OUT  std_logic_vector(63 downto 0);
         pmem_data_in : IN  std_logic_vector(63 downto 0);
         pipeline_settings_out : OUT  std_logic_vector(2 downto 0);
         request_bus_rated : OUT  std_logic_vector(1 downto 0);
         ack_gene_ctrl : IN  std_logic;
         request_bus_unrated : OUT  std_logic;
         gen_pipeline_settings : IN  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal processor_enable : std_logic := '0';
   signal halt_inst : std_logic := '0';
   signal imem_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal ack_mem_ctrl : std_logic := '0';
   signal dmem_data_in : std_logic_vector(63 downto 0) := (others => '0');
   signal pmem_data_in : std_logic_vector(63 downto 0) := (others => '0');
   signal ack_gene_ctrl : std_logic := '0';
   signal gen_pipeline_settings : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal imem_address : std_logic_vector(31 downto 0);
   signal request_bus_data : std_logic;
   signal dmem_address : std_logic_vector(18 downto 0);
   signal dmem_address_wr : std_logic_vector(63 downto 0);
   signal dmem_data_out : std_logic_vector(63 downto 0);
   signal dmem_write_enable : std_logic;
   signal pmem_data_out : std_logic_vector(63 downto 0);
   signal pipeline_settings_out : std_logic_vector(2 downto 0);
   signal request_bus_rated : std_logic_vector(1 downto 0);
   signal request_bus_unrated : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fitness_core PORT MAP (
          clk => clk,
          reset => reset,
          processor_enable => processor_enable,
          halt_inst => halt_inst,
          imem_address => imem_address,
          imem_data_in => imem_data_in,
          request_bus_data => request_bus_data,
          ack_mem_ctrl => ack_mem_ctrl,
          dmem_data_in => dmem_data_in,
          dmem_address => dmem_address,
          dmem_address_wr => dmem_address_wr,
          dmem_data_out => dmem_data_out,
          dmem_write_enable => dmem_write_enable,
          pmem_data_out => pmem_data_out,
          pmem_data_in => pmem_data_in,
          pipeline_settings_out => pipeline_settings_out,
          request_bus_rated => request_bus_rated,
          ack_gene_ctrl => ack_gene_ctrl,
          request_bus_unrated => request_bus_unrated,
          gen_pipeline_settings => gen_pipeline_settings
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
      processor_enable <= '0';
      halt_inst <= '0';
      ack_mem_ctrl <= '1';
      dmem_data_in <= X"0000000000000000";
      pmem_data_in <= X"0000000000000000";
      ack_gene_ctrl <= '0';
      gen_pipeline_settings <= "000";
      wait for 100 ns;	
      
      imem_data_in <= "11111100000010000000000000000000";
      wait for clk_period;
      reset <= '0';
      processor_enable <= '1';
      
      test("0", "pc should start at zero", imem_address, "0000000000000000000");
      
      imem_data_in <= "11111100000100000000000000010000"; 
      wait for clk_period;
      test("1", "pc address 1", imem_address, "0000000000000000001");
      
      imem_data_in <= "11111100000110000000000000000000";
      wait for clk_period;
      test("2", "pc address 2", imem_address, "0000000000000000010");
      
      imem_data_in <= "11111000000010000100000000100000";
      wait for clk_period;
      test("3", "pc address 3", imem_address, "0000000000000000011");
      
      imem_data_in <= "11110001000010001100000000000000";
      wait for clk_period;
      test("4", "pc address 4", imem_address, "0000000000000000100");
      
      imem_data_in <= "11111100000110001100000000010000";
      wait for clk_period;
      test("5", "pc address 5", imem_address, "0000000000000000101");
      
      imem_data_in <= "11111000000100000100000000100000";
      wait for clk_period;
      test("6", "pc address 6", imem_address, "0000000000000000110");
      test("6", "data address", dmem_address, X"0000000000000000");
      test("7", "fib number", dmem_data_out, X"0000000000000001");
      
      imem_data_in <= "11110001000100001100000000000000";
      wait for clk_period;
      test("7", "pc address 7", imem_address, "0000000000000000111");
      
      imem_data_in <= "11111100000110001100000000010000";
      wait for clk_period;
      test("8", "pc address 8", imem_address, "0000000000000001000");
      
      imem_data_in <= "11110010000000000000000000000100";
      wait for clk_period;
      test("9", "pc address 9", imem_address, "0000000000000001001");


      --Outputs
--   signal imem_address : std_logic_vector(31 downto 0);
--   signal request_bus_data : std_logic;
--   signal dmem_address : std_logic_vector(18 downto 0);
--   signal dmem_address_wr : std_logic_vector(63 downto 0);
--   signal dmem_data_out : std_logic_vector(63 downto 0);
--   signal dmem_write_enable : std_logic;
--   signal pmem_data_out : std_logic_vector(63 downto 0);
--   signal pipeline_settings_out : std_logic_vector(2 downto 0);
--   signal request_bus_unrated : std_logic;
--   signal request_bus_rated : std_logic_vector(1 downto 0);
    

      wait;
   end process;

END;
