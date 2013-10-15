----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:35:08 10/12/2013 
-- Design Name: 
-- Module Name:    fitness_core - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fitness_core is
    generic (
    MEM_ADDR_BUS : integer := 32;
    MEM_DATA_BUS : integer := 32;
    N            : integer := 32
    );
    
    port( clk                 : in  STD_LOGIC;
          reset               : in  STD_LOGIC;
          processor_enable    : in  STD_LOGIC;
          imem_address        : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          imem_data_in        : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_data_in        : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_address        : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_address_wr     : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_data_out       : out STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_write_enable   : out STD_LOGIC);

end fitness_core;

architecture Behavioral of fitness_core is

--Component declerations



--STAGE 1 - FETCH instruction
component IF_ID 
    generic(N : integer := 32);
    Port ( clk       : in  STD_LOGIC;
           reset     : in  STD_LOGIC;
           data_in1  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           data_in2  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           data_out1 : out STD_LOGIC_VECTOR(N-1 downto 0);
           data_out2 : out STD_LOGIC_VECTOR(N-1 downto 0)
           );
end component;

component fetch_stage is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           pc_update : in STD_LOGIC;
           pc_src : in STD_LOGIC;
           pc_input : in STD_LOGIC_VECTOR(31 downto 0);
           pc_incremented : out STD_LOGIC_VECTOR(31 downto 0);
           pc_signal : out STD_LOGIC_VECTOR(31 downto 0));
end component;


--STAGE 2 - DECODE instruction
component control_unit is
    Port ( reset : in  STD_LOGIC;
           op_code : in  STD_LOGIC_VECTOR (5 downto 0);
           reg_dst : out  STD_LOGIC_VECTOR (1 downto 0);
           alu_src : out  STD_LOGIC;
           branch : out  STD_LOGIC;
           mem_read : out  STD_LOGIC;
           mem_write  : out  STD_LOGIC;
           reg_write : out  STD_LOGIC;
           mem_to_reg : out  STD_LOGIC);
end component;

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
          immediate_address_out : out STD_LOGIC_VECTOR(31 downto 0);
          rs                    : out STD_LOGIC_VECTOR(4 downto 0);
          rt                    : out STD_LOGIC_VECTOR(4 downto 0);
          rd                    : out STD_LOGIC_VECTOR(4 downto 0);
          condition_out         : out STD_LOGIC_VECTOR(3 downto 0));
--STAGE 3 - Execute instruction 




--Signal declerations


begin


end Behavioral;

