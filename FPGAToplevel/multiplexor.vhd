library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multiplexor is
    generic(N : integer);
    Port ( sel : in  STD_LOGIC;
           in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end multiplexer;

architecture Behavioral of multiplexer is

begin


MULTIPLEXER : process (sel, in0, in1) 
begin 
    if sel = '1' then 
        output <= in1;
    else 
        output <= in0;
    end if;
    
 end process MULTIPLEXER;

end Behavioral;
