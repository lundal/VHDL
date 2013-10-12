----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:39:11 10/12/2013 
-- Design Name: 
-- Module Name:    decode_stage - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decode_stage is
    port( clk                   : in STD_LOGIC;
          reset                 : in STD_LOGIC;
          processor_enable      : in STD_LOGIC;
          reg_write             : in STD_LOGIC;
          instruction           : in STD_LOGIC_VECTOR(31 downto 0);
          write_data            : in STD_LOGIC_VECTOR(63 downto 0);
          write_register        : in STD_LOGIC_VECTOR(4 downto 0);
          rs                    : out STD_LOGIC_VECTOR(63 downto 0);
          rt                    : out STD_LOGIC_VECTOR(63 downto 0);
          extended_immediate    : out STD_LOGIC_VECTOR(31 downto 0);
          ins_20_16             : out STD_LOGIC_VECTOR(4 downto 0);
          ins_15_11             : out STD_LOGIC_VECTOR(4 downto 0));
end decode_stage;

architecture Behavioral of decode_stage is

-- COMPONENT declerations
component register_file 
    port (CLK                : in  STD_LOGIC;
          RESET              : in  STD_LOGIC;
          RW                 : in  STD_LOGIC; 
          RS_ADDR            : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0); 
          RT_ADDR            : in  STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
          RD_ADDR            : in  STD_LOGIC_VECTOR(RADDR_BUS-1 downto 0);
          WRITE_DATA         : in  STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
          RS                 : out STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
          RT                 : out STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0));
end component;

-- Signal declerations
signal ins_25_0_signal : std_logic_vector(25 downto 0);
signal ins_25_21_signal : std_logic_vector(4 downto 0);
signal ins_20_16_signal : std_logic_vector(4 downto 0);
signal ins_15_11_signal : std_logic_vector(4 downto 0);
signal ins_15_0_signal : std_logic_vector(15 downto 0);
signal extended_immediate_signal : std_logic_vector(31 downto 0);



begin

REGISTER_FILE_MAP : register_file
port map (CLK => clk, 
          RESET => reset, 
          RW => reg_write, 
          RS_ADDR => ins_25_21_signal, 
          RT_ADDR => ins_20_16_signal, 
          RD_ADDR => write_register, 
          WRITE_DATA => write_data, 
          RS => rs, 
          RT => rt);
          
          
FETCH : process(processor_enable, instruction) 
begin 
    if processor_enable = '1' then
        ins_25_0_signal  <= instruction(25 downto 0);
        ins_25_21_signal <= instruction(25 downto 21);
        ins_20_16_signal <= instruction(20 downto 16);
        ins_15_11_signal <= instruction(15 downto 11);
        ins_15_0_signal  <= instruction(15 downto 0);
     elsif processor_enable = '0' then
        ins_25_0_signal  <= (others => '0');
        ins_25_21_signal <= (others => '0');
        ins_20_16_signal <= (others => '0');
        ins_15_11_signal <= (others => '0');
        ins_15_0_signal  <= (others => '0');
     end if;
end process FETCH;


SIGN_EXTEND : process(ins_15_0_signal) 
begin 
     extended_immediate <= SXT(ins_15_0_signal, 32);   
    
end process SIGN_EXTEND;


-- PASS potential write registers to the next stage
ins_20_16 <= ins_20_16_signal;
ins_15_11 <= ins_15_11_signal;






end Behavioral;

