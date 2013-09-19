----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:36:02 09/19/2013 
-- Design Name: 
-- Module Name:    flip_flop - Behavioral 
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

entity flip_flop is
    generic (N : NATURAL);
    Port ( clk : in STD_LOGIC;
           reset: in STD_LOGIC;
           enable : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (N-1 downto 0));
end flip_flop;

architecture Behavioral of flip_flop is

begin

    FLIP_FLOP : process (clk, reset)
    begin 
        if reset = '1' then 
            data_out <= (others => '0');
        elsif rising_edge(clk) then 
            if enable = '0' then 
                data_out <= data_in;
            end if;
        end if;
        
    end process FLIP_FLOP;

end Behavioral;

