----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:33:35 09/20/2013 
-- Design Name: 
-- Module Name:    comparator - Behavioral 
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

entity comparator is
    generic (N : integer)
    Port ( in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           signal_out : out  STD_LOGIC_VECTOR (1 downto 0));
end comparator;

architecture Behavioral of comparator is

begin


COMPARATOR : process(in0, in1) 
begin
    if in0 < in1 then 
        signal_out => "01"; --Less
    elsif in0 = in1 then 
        signal_out <= "00"; --Equal    
    else 
        signal_out <= "10"; -- Greater
    
end process COMPARATOR;


end Behavioral;

