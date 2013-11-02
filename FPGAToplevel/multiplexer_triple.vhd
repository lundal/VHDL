library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multiplexer_triple is
    generic(N : integer := 64);
    Port ( sel : in  STD_LOGIC_VECTOR (1 downto 0);
           in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end multiplexer_triple;

architecture Behavioral of multiplexer_triple is

begin

MULTIPLEXER : process (sel, in0, in1, in2) 
begin 
     if sel = "01" then 
         output <= in1;
     elsif sel = "10" then 
         output <= in2;
	  else
			output <= in0;
     end if;
    
 end process MULTIPLEXER;

end Behavioral;
