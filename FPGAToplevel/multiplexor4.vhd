----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:42:57 10/24/2013 
-- Design Name: 
-- Module Name:    multiplexor4 - Behavioral 
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
use work.CONSTANTS.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplexor4 is
    Port ( sel 	: in  STD_LOGIC_VECTOR (1 downto 0);
           in0 	: in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           in1 	: in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           in2 	: in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           in3 	: in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           output : out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0));
end multiplexor4;

architecture Behavioral of multiplexor4 is

begin


MULTIPLEXOR4 : process(sel) 
begin 
	case sel is 
	when "00" =>
		output <= in0;
	when "01" =>
		output <= in1;
   when "10" => 
		output <= in2;
	when "11" =>
		output <= in3;
	when others => 
		output <= (others => '0');
	end case;
end process;

end Behavioral;

