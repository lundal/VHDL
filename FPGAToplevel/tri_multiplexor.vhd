----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:26:06 10/13/2013 
-- Design Name: 
-- Module Name:    tri_multiplexor - Behavioral 
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

entity tri_multiplexor is
    generic (N : integer);
    Port ( sel    : in  STD_LOGIC_VECTOR (1 downto 0);
           in0    : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1    : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in2    : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end tri_multiplexor;

architecture Behavioral of tri_multiplexor is

begin

TRI_MUX : process(sel)
    begin 
        case sel is 
        when "00" => 
            output <= in0;
        when "01" => 
            output <= in1;
        when "10" => 
            output <= in2;
        when others => 
            output <= (others => '0');
        end case;
end process TRI_MUX;
        
        
        
        


end Behavioral;

