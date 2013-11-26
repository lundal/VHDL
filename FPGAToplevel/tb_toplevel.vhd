LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
use work.test_utils.all;
use WORK.CONSTANTS.ALL;
 
ENTITY tb_toplevel IS
END tb_toplevel;
 
ARCHITECTURE behavior OF tb_toplevel IS 

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
   
type mem is array (0 to 55) of std_logic_vector(16-1 downto 0);

constant hi : mem := (
    0 => "0000000000000000",
    1  => "1111001000000000",
    2  => "1111001000000000",
    3  => "1111001000000000",
    4  => "1111001000000000",
    5  => "1111001000000000",
    6  => "1111001000000000",
    7  => "1111001000000000",
    8  => "1111001000000000",
    9  => "1111001000000000",
    10  => "1111001000000000",
    11  => "1111001000000000",
    12  => "1111001000000000",
    13  => "1111110000001000",
    14  => "1111110000010000",
    15  => "1111110000011000",
    16  => "1111110000100000",
    17  => "1111110000001000",
    18  => "1111110000010000",
    19  => "1111110000011000",
    20  => "1111100000101001",
    21  => "1111100000101001",
    22  => "1111100000101001",
    23  => "1111100000101001",
    24  => "1111101100101000",
    25  => "1111110010101000",
    26  => "1111110010110101",
    27  => "1111110010111101",
    28  => "1111110000001000",
    29  => "1111110000010000",
    30  => "1111110000011000",
    31  => "1111110011001000",
    32  => "1111110011001110",
    33  => "1111100100101000",
    34  => "0000100000000000",
    35  => "1111100001011001",
    36  => "1111100001100001",
    37  => "1111110001100011",
    38  => "1111100001101001",
    39  => "1111110001101011",
    40  => "1111100010000000",
    41  => "0110100010000000",
    42  => "1111100010001000",
    43  => "0110100010001000",
    44  => "1111100010010000",
    45  => "0110100010010000",
    46  => "1111100001111100",
    47  => "1111100001111011",
    48  => "1111100000110110",
    49  => "1111101000000001",
    50  => "1111100000000001",
    51  => "0110001000000000",
    52  => "1111110001000001",
    53  => "1111110001001001",
    54  => "1111001000000000",
    55  => "0000000000000000"
);
constant lo : mem := (
    0 => "0000000000000000",
    1  => "0000000000001101",
    2  => "0000000000001101",
    3  => "0000000000001101",
    4  => "0000000000001101",
    5  => "0000000000001101",
    6  => "0000000000001101",
    7  => "0000000000001101",
    8  => "0000000000001101",
    9  => "0000000000001101",
    10  => "0000000000001101",
    11  => "0000000000001101",
    12  => "0000000000001101",
    13  => "0000000000010000",
    14  => "0000000001000000",
    15  => "0000000001000000",
    16  => "0000010000000000",
    17  => "0100000100000111",
    18  => "1000000010110111",
    19  => "1100000010000111",
    20  => "0100001000000100",
    21  => "0100010000000100",
    22  => "0100011000000100",
    23  => "0100100000000100",
    24  => "0000000000000000",
    25  => "0000111111110000",
    26  => "0100000010000111",
    27  => "1000000010000111",
    28  => "0000111111110000",
    29  => "0000000000000000",
    30  => "0000111111110000",
    31  => "0000000000010001",
    32  => "0100000000011000",
    33  => "0000000000000000",
    34  => "0000000000000000",
    35  => "0110101000000101",
    36  => "0110110000000101",
    37  => "0000000010001000",
    38  => "0110111000000101",
    39  => "0100000100001000",
    40  => "0101011000000001",
    41  => "0010000000000001",
    42  => "1001100000000001",
    43  => "0010001000000001",
    44  => "1101101000000001",
    45  => "0010010000000001",
    46  => "0010001000000000",
    47  => "1110010000000000",
    48  => "0101111000000001",
    49  => "1000101000000000",
    50  => "1001001000000001",
    51  => "0000000000100001",
    52  => "0100000000000100",
    53  => "1000000000000100",
    54  => "0000000000100001",
    55  => "0000000000000000"
);
    
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
    uut: entity work.Toplevel
    GENERIC MAP (
        NUM_PROC => 2
    )
    PORT MAP (
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
