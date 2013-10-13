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
use IEEE.STD_LOGIC_SIGNED.ALL;

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
          read_data1            : out STD_LOGIC_VECTOR(63 downto 0);
          read_data2            : out STD_LOGIC_VECTOR(63 downto 0);
          immediate_value_out   : out STD_LOGIC_VECTOR(31 downto 0);
          immediate_address_out : out STD_LOGIC_VECTOR(31 downto 0)
          rs                    : out STD_LOGIC_VECTOR(4 downto 0);
          rt                    : out STD_LOGIC_VECTOR(4 downto 0);
          rd                    : out STD_LOGIC_VECTOR(4 downto 0);
          );
          
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
          RT                 : out STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
          condition_out      : out STD_LOGIC_VECTOR(2 downto 0));
end component;

-- Signal declerations
signal rd_addr           : std_logic_vector(4 downto 0);
signal rs_addr           : std_logic_vector(4 downto 0);
signal rd_addr           : std_logic_vector(4 downto 0);
signal immediate_value   : std_logic_vector(9 downto 0);
signal immediate_address : std_logic_vector(18 downto 0);
signal condition         : std_logic_vector(2 downto 0);



begin

REGISTER_FILE_MAP : register_file
port map (CLK => clk, 
          RESET => reset, 
          RW => reg_write, 
          RS_ADDR => rs_addr, 
          RT_ADDR => rt_addr, 
          RD_ADDR => write_register, 
          WRITE_DATA => write_data, 
          RS => read_data1, 
          RT => read_data2);
          
          
FETCH : process(processor_enable, instruction) 
begin 
    if processor_enable = '1' then
       rd_addr <= instruction(23 downto 19);
       rs_addr <= instruction(18 downto 14);
       rt_addr <= instruction(13 downto 9);
       immediate_value <= instruction(13 downto 4)
       immediate_address <= instruction(18 downto 0)
       condition <= instruction(31 downto 28);
     
     elsif processor_enable = '0' then
        rd_addr  <= (others => '0');
        rs_addr <= (others => '0');
        rt_addr <= (others => '0');
        immediate_value <= (others => '0');
        imediate_address <= (others => '0');
        condition <= (others => '0');
     end if;
end process FETCH;


SIGN_EXTEND_IMMEDIATE_VALUE : process(immediate_value) 
begin 
     immediate_value_out <= SXT(immediate_value, 32);   
    
end process SIGN_EXTEND_IMMEDIATE_VALUE;


SIGN_EXTEND_IMMEDIATE_ADDRESS : process(immediate_address)
begin 
    immediate_address_out <= SXT(immediate_address, 32);
end process SIGN_EXTEND_IMMEDIATE_ADDRESS;

--OUTPUT
condition_out <= condition;
rs <= rs_addr;
rt <= rt_addr;
rd <= rd_addr;






end Behavioral;

