LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Toplevel
    PORT(
         SCU_ENABLE : IN  std_logic;
         SCU_STATE : IN  std_logic_vector(1 downto 0);
         SCU_CE : IN  std_logic;
         SCU_WE : IN  std_logic;
         SCU_DATA : INOUT  std_logic_vector(15 downto 0);
         SCU_ADDR : IN  std_logic_vector(18 downto 0);
         SCU_LBUB : IN  std_logic;
         IMEM_CE_HI : OUT  std_logic;
         IMEM_CE_LO : OUT  std_logic;
         IMEM_WE_HI : OUT  std_logic;
         IMEM_WE_LO : OUT  std_logic;
         IMEM_DATA_HI : INOUT  std_logic_vector(15 downto 0);
         IMEM_DATA_LO : INOUT  std_logic_vector(15 downto 0);
         IMEM_ADDR : OUT  std_logic_vector(18 downto 0);
         IMEM_LBUB : OUT  std_logic;
         DMEM_CE : OUT  std_logic;
         DMEM_WE : OUT  std_logic;
         DMEM_DATA : INOUT  std_logic_vector(15 downto 0);
         DMEM_ADDR : OUT  std_logic_vector(18 downto 0);
         DMEM_LBUB : OUT  std_logic;
         Clock : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SCU_ENABLE : std_logic := '0';
   signal SCU_STATE : std_logic_vector(1 downto 0) := (others => '0');
   signal SCU_CE : std_logic := '0';
   signal SCU_WE : std_logic := '0';
   signal SCU_ADDR : std_logic_vector(18 downto 0) := (others => '0');
   signal SCU_LBUB : std_logic := '0';
   signal Clock : std_logic := '0';

	--BiDirs
   signal SCU_DATA : std_logic_vector(15 downto 0);
   signal IMEM_DATA_HI : std_logic_vector(15 downto 0);
   signal IMEM_DATA_LO : std_logic_vector(15 downto 0);
   signal DMEM_DATA : std_logic_vector(15 downto 0);

 	--Outputs
   signal IMEM_CE_HI : std_logic;
   signal IMEM_CE_LO : std_logic;
   signal IMEM_WE_HI : std_logic;
   signal IMEM_WE_LO : std_logic;
   signal IMEM_ADDR : std_logic_vector(18 downto 0);
   signal IMEM_LBUB : std_logic;
   signal DMEM_CE : std_logic;
   signal DMEM_WE : std_logic;
   signal DMEM_ADDR : std_logic_vector(18 downto 0);
   signal DMEM_LBUB : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Toplevel PORT MAP (
          SCU_ENABLE => SCU_ENABLE,
          SCU_STATE => SCU_STATE,
          SCU_CE => SCU_CE,
          SCU_WE => SCU_WE,
          SCU_DATA => SCU_DATA,
          SCU_ADDR => SCU_ADDR,
          SCU_LBUB => SCU_LBUB,
          IMEM_CE_HI => IMEM_CE_HI,
          IMEM_CE_LO => IMEM_CE_LO,
          IMEM_WE_HI => IMEM_WE_HI,
          IMEM_WE_LO => IMEM_WE_LO,
          IMEM_DATA_HI => IMEM_DATA_HI,
          IMEM_DATA_LO => IMEM_DATA_LO,
          IMEM_ADDR => IMEM_ADDR,
          IMEM_LBUB => IMEM_LBUB,
          DMEM_CE => DMEM_CE,
          DMEM_WE => DMEM_WE,
          DMEM_DATA => DMEM_DATA,
          DMEM_ADDR => DMEM_ADDR,
          DMEM_LBUB => DMEM_LBUB,
          Clock => Clock
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clock_period*10;
        
      scu_enable <= '0';
      scu_ce <= '1';
      scu_lbub <= '1';
      scu_we <= '1';
      wait for clock_period * 4;
      scu_state <= "10"; -- instmemlow
      scu_addr <= X"0000";
      scu_ce <= '0';
      scu_we <='0';
      scu_data <= X"BABE";
      wait for clock_period;
      scu_state <= "01"; -- instmemhigh
      scu_data <= X"CAFE";
      wait for clock_period;
      scu_state <= "00"; -- processor
      scu_enable <= '1';
      
      
      
      

      wait;
   end process;

END;
