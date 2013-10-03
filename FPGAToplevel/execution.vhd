----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:13:36 10/03/2013 
-- Design Name: 
-- Module Name:    execution - Behavioral 
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

entity execution is
    Port ( read_data_1 : in  STD_LOGIC_VECTOR (31 downto 0);
           read_data_2 : in  STD_LOGIC_VECTOR (31 downto 0);
           sign_extend : in  STD_LOGIC_VECTOR (31 downto 0));
end execution;

architecture Behavioral of execution is

begin


end Behavioral;

