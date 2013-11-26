LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_fitness_memory_controller IS
END tb_fitness_memory_controller;
 
ARCHITECTURE behavior OF tb_fitness_memory_controller IS 
 
    COMPONENT fitness_memory_controller
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         processor_enable : IN std_logic;
			mem_op : IN  std_logic_vector(1 downto 0);
         ack_mem_ctrl : IN  std_logic;
         mem_op_ctrl : OUT  std_logic_vector(1 downto 0);
         request_bus : OUT  std_logic;
         halt : OUT  std_logic;
         addr : IN  std_logic_vector(18 downto 0);
         store_data : IN  std_logic_vector(63 downto 0);
         addr_mem_ctrl : OUT  std_logic_vector(18 downto 0);
         data_mem_ctrl : OUT  std_logic_vector(63 downto 0);
         read_data_mem_ctrl : IN  std_logic_vector(63 downto 0);
         read_data_out : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal processor_enable : std_logic := '0';
	signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal mem_op : std_logic_vector(1 downto 0) := (others => '0');
   signal ack_mem_ctrl : std_logic := '0';
   signal addr : std_logic_vector(18 downto 0) := (others => '0');
   signal store_data : std_logic_vector(63 downto 0) := (others => '0');
   signal read_data_mem_ctrl : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal mem_op_ctrl : std_logic_vector(1 downto 0);
   signal request_bus : std_logic;
   signal halt : std_logic;
   signal addr_mem_ctrl : std_logic_vector(18 downto 0);
   signal data_mem_ctrl : std_logic_vector(63 downto 0);
   signal read_data_out : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: fitness_memory_controller PORT MAP (
          clk => clk,
          reset => reset,
          processor_enable => procssor_enable,
			 mem_op => mem_op,
          ack_mem_ctrl => ack_mem_ctrl,
          mem_op_ctrl => mem_op_ctrl,
          request_bus => request_bus,
          halt => halt,
          addr => addr,
          store_data => store_data,
          addr_mem_ctrl => addr_mem_ctrl,
          data_mem_ctrl => data_mem_ctrl,
          read_data_mem_ctrl => read_data_mem_ctrl,
          read_data_out => read_data_out
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

      -- READ DATA
		--The instruction enters the memory stage
			--1. The pipeline is stalled. 
			--2. The processor request accesss to the bus. 
		mem_op <= "01";
		addr <= "0000000000000000011";
		
		wait for clk_period*10; -- Memory is busy at the moment
		
		-- The processor has granted access to the bus
			--1a. Sets the address on the bus
			--1b. Sets operation signal
			--2. Continue execution
			
		ack_mem_ctrl <= '1';		
		wait for clk_period *4;    -- The memory controller uses four cycles to repsond with the data 
		ack_mem_ctrl <= '0';
		read_data_mem_ctrl <= "0000000000000000000000000000000000000100000000100000000000000000";
		mem_op <= "00"; --new operations enters the pipeline stage
		
		--WRITE Data 
		wait for clk_period*10;
		mem_op <= "11";
		addr <= "0000000000000000011";
		store_data <= "0000000000000000000000000000000000000100000000100000000000000000";
		
		wait for clk_period*5;
		ack_mem_ctrl <= '1';
		wait for clk_period;
		mem_op <= "00";
		
		

      wait;
   end process;

END;
