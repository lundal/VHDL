library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity pc is
    generic ( default : natural);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           pc_update  : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (19-1 downto 0);
           addr_out : out  STD_LOGIC_VECTOR (19-1 downto 0));
end pc;

architecture Behavioral of pc is

begin

PROGRAM_COUNTER : process(clk, reset, pc_update, addr)
    begin 
        --addr_out <= (others => '0');
        if reset = '1' then 
            addr_out <= std_logic_vector(to_unsigned(default, 19)); 
         elsif rising_edge(clk) then 
            if pc_update = '1' then 
                addr_out <= addr;
            end if;
         end if;
  end process PROGRAM_COUNTER;


end Behavioral;

