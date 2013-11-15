LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_data_controller IS
END tb_data_controller;
 
ARCHITECTURE behavior OF tb_data_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory_data_controller
    PORT(
         REQUEST_0 : IN  std_logic_vector(3 downto 0);
         REQUEST_1 : IN  std_logic_vector(3 downto 0);
         ACK : OUT  std_logic_vector(3 downto 0);
         PROC_ADDR : IN  std_logic_vector(16 downto 0);
         PROC_DATA_IN : IN  std_logic_vector(63 downto 0);
         PROC_DATA_OUT : OUT  std_logic_vector(63 downto 0);
         MEM_ADDR : OUT  std_logic_vector(18 downto 0);
         MEM_DATA : INOUT  std_logic_vector(15 downto 0);
         MEM_ENABLE : OUT  std_logic;
         MEM_WRITE : OUT  std_logic;
         MEM_LBUB : OUT  std_logic;
         ENABLE : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal REQUEST_0 : std_logic_vector(3 downto 0) := (others => '0');
   signal REQUEST_1 : std_logic_vector(3 downto 0) := (others => '0');
   signal PROC_ADDR : std_logic_vector(16 downto 0) := (others => '0');
   signal PROC_DATA_IN : std_logic_vector(63 downto 0) := (others => '0');
   signal ENABLE : std_logic := '0';
   signal CLK : std_logic := '0';

	--BiDirs
   signal MEM_DATA : std_logic_vector(15 downto 0);

 	--Outputs
   signal ACK : std_logic_vector(3 downto 0);
   signal PROC_DATA_OUT : std_logic_vector(63 downto 0);
   signal MEM_ADDR : std_logic_vector(18 downto 0);
   signal MEM_ENABLE : std_logic;
   signal MEM_WRITE : std_logic;
   signal MEM_LBUB : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memory_data_controller PORT MAP (
          REQUEST_0 => REQUEST_0,
          REQUEST_1 => REQUEST_1,
          ACK => ACK,
          PROC_ADDR => PROC_ADDR,
          PROC_DATA_IN => PROC_DATA_IN,
          PROC_DATA_OUT => PROC_DATA_OUT,
          MEM_ADDR => MEM_ADDR,
          MEM_DATA => MEM_DATA,
          MEM_ENABLE => MEM_ENABLE,
          MEM_WRITE => MEM_WRITE,
          MEM_LBUB => MEM_LBUB,
          ENABLE => ENABLE,
          CLK => CLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
      
       REQUEST_0 <= "0000";
       REQUEST_1 <= "0000";
       --signal PROC_ADDR
       --signal PROC_DATA_IN
       ENABLE <= '0';

      wait;
   end process;

END;
