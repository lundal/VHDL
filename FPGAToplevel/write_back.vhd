----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:15:19 10/03/2013 
-- Design Name: 
-- Module Name:    write_back - Behavioral 
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

entity write_back is
    Port ( 
				--Control signals in 
				to_reg : in std_logic_vector(TO_REG_OP_WIDTH-1 downto 0);
				call   : in std_logic;
				
				--Bus signals in 
				gene_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
				res_in  : in std_logic_vector(DATA_WIDTH-1 downto 0);
				data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
				RDA_in 	: in std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
				
				-- Bus signals out
				WBA 		: out std_logic_vector();
				WBB 		: out std_logic_vector()
				
end write_back;

architecture Behavioral of write_back is

begin


end Behavioral;

