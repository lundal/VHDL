----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:16 09/30/2013 
-- Design Name: 
-- Module Name:    shift_left - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_left is
    generic(N : integer := 32);
    Port ( bus_in  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           bus_out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end shift_left;

architecture Behavioral of shift_left is

begin

bus_out <= bus_in sll 2; 

end Behavioral;

