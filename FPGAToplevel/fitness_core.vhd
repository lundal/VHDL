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
          dmem_data_out       : out STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
          dmem_write_enable   : out STD_LOGIC);

end fitness_core;

architecture Behavioral of fitness_core is

begin


end Behavioral;

