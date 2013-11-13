library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Multiplier is
	generic (
		N : natural := 32
	);
    port (
		A			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		B			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		Result		:	out	STD_LOGIC_VECTOR(2*N-1 downto 0)
	);
end Multiplier;
	
architecture Behavioral of Multiplier is
begin

    process (A, B)
    begin
        Result <= A * B;
    end process;

end Behavioral;

