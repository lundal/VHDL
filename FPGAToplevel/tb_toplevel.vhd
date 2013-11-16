LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
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
   
    type mem is array (0 to 19) 
    constant hi : mem := (
        0 => "0000000000000000",
        1  => "1111001000000000",
        2  => "0000100000000000",
        3  => "0000100000000000",
        4  => "0000100000000000",
        5  => "0000100000000000",
        6  => "0000100000000000",
        7  => "0000100000000000",
        8  => "0000100000000000",
        9  => "1111001000000000",
        10  => "1111010000011000",
        11  => "1111010000001000",
        12  => "1111010000010000",
        13  => "1111110000011000",
        14  => "1111110000011000",
        15  => "1111100000001000",
        16  => "1111100000010000",
        17  => "1111100000000000",
        18  => "0010001000000000",
        19  => "1111001000000000",
        20  => "0000000000000000"
    );
    constant lo : mem := (
        0 => "0000000000000000",
        1  => "0000000000001010",
        2  => "0000000000000000",
        3  => "0000000000000000",
        4  => "0000000000000000",
        5  => "0000000000000000",
        6  => "0000000000000000",
        7  => "0000000000000000",
        8  => "0000000000000000",
        9  => "0000000000001001",
        10  => "0000000000000000",
        11  => "0000000000000000",
        12  => "0000000000000001",
        13  => "1100000000010000",
        14  => "1100000000010000",
        15  => "0100000000100000",
        16  => "0100000000100000",
        17  => "0000000000110001",
        18  => "0000000000001101",
        19  => "0000000000010100",
        20  => "0000000000000000"
    );
    
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
        
--    inst_mem : entity work.fakeinstmem
--    port map(
--		IMEM_ADDR => IMEM_ADDR,
--		IMEM_DATA_LO => IMEM_DATA_LO,
--		IMEM_WE_LO => IMEM_WE_LO,
--		IMEM_CE_LO => IMEM_CE_LO,
--		IMEM_DATA_HI => IMEM_DATA_HI,
--		IMEM_WE_HI => IMEM_WE_HI,
--		IMEM_CE_HI => IMEM_CE_HI,
--        IMEM_LBUB => '1',
--        clk => clock
--	);
    
    inst_mem_hi : entity work.fakemem
    port map(
		ADDR => IMEM_ADDR,
		DATA => IMEM_DATA_HI,
		WE => IMEM_WE_HI,
		CE => IMEM_CE_HI,
		CLK => Clock
	);
    
    inst_mem_lo : entity work.fakemem
    port map(
		ADDR => IMEM_ADDR,
		DATA => IMEM_DATA_LO,
		WE => IMEM_WE_LO,
		CE => IMEM_CE_LO,
		CLK => Clock
	);
    
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
		Clock <= '1';
		wait for Clock_period/2;
		Clock <= '0';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
      -- Hold some cycles
      wait for clock_period*4;
      
      scu_ce <= '0';
      scu_we <= '0';
      
      -- Flash inst high
      scu_state <= STATE_INST_HI;
      
      inst_hi :
      for i in hi'range loop
         scu_addr <= std_logic_vector(to_unsigned(i, 19));
         scu_data <= hi(i);
         wait for clock_period;
      end loop;
      
      -- Flash inst low
      scu_state <= STATE_INST_LO;
      
      inst_lo :
      for i in lo'range loop
         scu_addr <= std_logic_vector(to_unsigned(i, 19));
         scu_data <= lo(i);
         wait for clock_period;
      end loop;
      
      scu_data <= (others => 'Z');
      
      scu_ce <= '1';
      scu_we <= '1';
      
      -- Hold reset more to clear caches
      wait for clock_period*256;
      
      scu_state <= STATE_PROC;
      
      wait for clock_period;
      
      scu_enable <= '1';

      wait;
   end process;

END;
