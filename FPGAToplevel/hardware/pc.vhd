library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pc is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           pc_update  : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (19-1 downto 0);
           addr_out : out  STD_LOGIC_VECTOR (19-1 downto 0));
end pc;

architecture Behavioral of pc is

begin

PROGRAM_COUNTER : process(clk, reset)
    begin 
        addr_out <= (others => '0');
        if reset = '1' then 
            addr_out <= (others => '0');
         elsif rising_edge(clk) then 
            if pc_update = '1' then 
                addr_out <= addr;
            end if;
         end if;
  end process PROGRAM_COUNTER;


end Behavioral;

