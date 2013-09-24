library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity comparator is
    generic (N : integer);
    Port ( in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           signal_out : out  STD_LOGIC_VECTOR (1 downto 0));
end comparator;

architecture Behavioral of comparator is

begin


COMPARATOR : process(in0, in1) 
begin
    if in0 < in1 then 
        signal_out <= "01"; --Less
    elsif in0 = in1 then 
        signal_out <= "00"; --Equal    
    else 
        signal_out <= "10"; -- Greater
        
    end if;
    
end process COMPARATOR;


end Behavioral;

