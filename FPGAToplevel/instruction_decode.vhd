----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:11:39 10/03/2013 
-- Design Name: 
-- Module Name:    instruction_decode - Behavioral 
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

entity instruction_decode is
    Port ( instruction  : in  STD_LOGIC_VECTOR (31 downto 0);
           read_data_1 : out  STD_LOGIC_VECTOR (31 downto 0);
           read_data_2 : out  STD_LOGIC_VECTOR (31 downto 0);
           sign_extend : out  STD_LOGIC_VECTOR (31 downto 0);
           write_register  : out  STD_LOGIC_VECTOR (4 downto 0));
end instruction_decode;

architecture Behavioral of instruction_decode is

begin


end Behavioral;

