LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
use WORK.CONSTANTS.ALL;
 
ENTITY tb_toplevel IS
END tb_toplevel;
 
ARCHITECTURE behavior OF tb_toplevel IS 
 
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
   signal SCU_CE : std_logic := '1';
   signal SCU_WE : std_logic := '1';
   signal SCU_ADDR : std_logic_vector(18 downto 0) := (others => '0');
   signal SCU_LBUB : std_logic := '1';
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
        
    inst_mem : entity work.fakeinstmem
    port map(
		IMEM_ADDR => IMEM_ADDR,
		IMEM_DATA_LO => IMEM_DATA_LO,
		IMEM_WE_LO => IMEM_WE_LO,
		IMEM_CE_LO => IMEM_CE_LO,
		IMEM_DATA_HI => IMEM_DATA_HI,
		IMEM_WE_HI => IMEM_WE_HI,
		IMEM_CE_HI => IMEM_CE_HI,
        IMEM_LBUB => '1',
        clk => clock
	);
    
--    inst_mem_hi : entity work.fakemem
--    port map(
--		ADDR => IMEM_ADDR,
--		DATA => IMEM_DATA_HI,
--		WE => IMEM_WE_HI,
--		CE => IMEM_CE_HI,
--		CLK => Clock
--	);
--    
--    inst_mem_lo : entity work.fakemem
--    port map(
--		ADDR => IMEM_ADDR,
--		DATA => IMEM_DATA_LO,
--		WE => IMEM_WE_LO,
--		CE => IMEM_CE_LO,
--		CLK => Clock
--	);
    
    data_mem : entity work.fakemem
    port map(
		ADDR => DMEM_ADDR,
		DATA => DMEM_DATA,
		WE => DMEM_WE,
		CE => DMEM_CE,
		CLK => Clock
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
      scu_enable <= '0';
      wait for clock_period*4;
      scu_state <= STATE_INST_LO;
      wait for clock_period * 512;
      scu_state <= STATE_PROC;
      wait for clock_period;
      scu_enable <= '1';
      
      wait for clock_period*100;


      wait;
   end process;

END;
