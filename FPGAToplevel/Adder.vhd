library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Adder is
	
    generic (N : integer := 64);
	
    port (
		A			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		B			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		R			:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		CARRY_IN	:	in	STD_LOGIC;
		OVERFLOW	:	out	STD_LOGIC
	);
		
end Adder;

architecture Behavioral of Adder is
	
	signal result : STD_LOGIC_VECTOR(N-1 downto 0);
		
begin
	
	ADD : process (A, B, result, CARRY_IN) is
		begin
		
		-- Add, add, add, away!
		result <= A + B + CARRY_IN;
		
		-- Overflow if the sign bit of A and B is equal, but result differs.
		-- OVERFLOW <= ( (not A(N-1)) xor B(N-1)) and (A(N-1) xor result(N-1));
		if (A(N-1) = B(N-1)) and (B(N-1) /= result(N-1)) then
			OVERFLOW <= '1';
		else
			OVERFLOW <= '0';
		end if;
		
		-- Onwards!
		R <= result;
		
	end process;
	
end Behavioral;

