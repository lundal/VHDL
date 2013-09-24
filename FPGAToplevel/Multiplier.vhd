library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity Multiplier is
    Port ( A : in  STD_LOGIC_VECTOR (63 downto 0);
           B : in  STD_LOGIC_VECTOR (63 downto 0);
           Result : out  STD_LOGIC_VECTOR (63 downto 0);
			  Overflow : out STD_LOGIC
			);
end Multiplier;
	
architecture Behavioral of Multiplier is

	signal Res : STD_LOGIC_VECTOR (127 downto 0);
	signal Res_High : STD_LOGIC_VECTOR (63 downto 0);
	signal Res_Low : STD_LOGIC_VECTOR (63 downto 0);
	
begin

	Multiply: process(A, B, Res, Res_Low, Res_High) begin
		Res <= A * B;
		Res_High <= Res(127 downto 64);
		Res_Low <= Res(63 downto 0);
		
		-- Check for overflow
		-- All extra bits should be equal to sign
		if Res(127 downto 63) = (64 downto 0 => '0') then
			Overflow <= '0';
		elsif Res(127 downto 63) = (64 downto 0 => '1') then
			Overflow <= '0';
		else
			Overflow <= '1';
		end if;
		
		Result <= Res_Low;
		
	end process Multiply;

end Behavioral;

