----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:39:10 09/30/2013 
-- Design Name: 
-- Module Name:    ID_EX - Behavioral 
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

entity ID_EX is
    Port ( clk : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           read_data_1 : in  STD_LOGIC_VECTOR (0 downto 0);
           read_data_2 : in  STD_LOGIC_VECTOR (0 downto 0);
           sign_extended : in  STD_LOGIC_VECTOR (0 downto 0);
           instruction : in  STD_LOGIC_VECTOR (0 downto 0);
           instruction_20_16 : in  STD_LOGIC_VECTOR (0 downto 0);
           instruction_15_11  : in  STD_LOGIC_VECTOR (0 downto 0));
end ID_EX;

architecture Behavioral of ID_EX is

begin


end Behavioral;

