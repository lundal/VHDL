----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:44 10/12/2013 
-- Design Name: 
-- Module Name:    pc - Behavioral 
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

entity pc is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           pc_update  : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (31 downto 0);
           addr_out : out  STD_LOGIC_VECTOR (31 downto 0));
end pc;

architecture Behavioral of pc is

begin

PROGRAM_COUNTER : process(clk, reset)
    begin 
        if reset = '1' then 
            addr_out <= (others => '0');
         elsif rising_edge(clk) then 
            if pc_update = '1' then 
                addr_out <= addr;
            end if;
         end if;
  end process PROGRAM_COUNTER;


end Behavioral;

