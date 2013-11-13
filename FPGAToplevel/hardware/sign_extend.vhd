----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:39 09/30/2013 
-- Design Name: 
-- Module Name:    sign_extend - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sign_extend is
    generic(IN_N : integer := 16;
            OUT_N : integer := 32
    );
    Port ( bus_in  : in  STD_LOGIC_VECTOR (IN_N-1 downto 0);
           bus_out : out  STD_LOGIC_VECTOR (OUT_N-1 downto 0)
    );
end sign_extend;

architecture Behavioral of sign_extend is

begin
    
    bus_out <= SXT(bus_in, IN_N);

end Behavioral;

