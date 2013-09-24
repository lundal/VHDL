library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity Adder is
    generic (N : integer);
    Port (
				A : in  STD_LOGIC_VECTOR(N-1 downto 0);
				B : in  STD_LOGIC_VECTOR (N-1 downto 0);
				res : out  STD_LOGIC_VECTOR (N-1 downto 0);
				overflow : out STD_LOGIC);
end Adder;

architecture Behavioral of Adder is

		Signal same_sign : STD_LOGIC;
		Signal sign_check : STD_LOGIC;
		Signal result : STD_LOGIC_VECTOR (N-1 downto 0);

begin
	ADD: process (A, B, same_sign, sign_check, result) is
		begin
		
		-- Overflow may only happen when both MSBs from A and Bare the same 
		-- If both are same, then same_sign and sign_check will be set to '1'
		-- Same_sign and sign_check are used to control overflow.
		if (A(N-1) = B(N-1)) then
			same_sign <= '1'; 
			sign_check <= A(N-1);
		else
			same_sign <='0';
		end if;
		
		result <= A + B;							
		
		-- When same_sign is '1', overflow is possible and will be controlled
		if (same_sign = '1') then 
		-- Result based on output res used for overflow control
		--	result <= A + B;							
		-- Change in MSB between result and old inputs means overflow (sich_check is a copy used for the control)
			if(sign_check /= result(N-1)) then 
				overflow <= '1';
			else
				overflow <= '0';
			end if;
		else
			overflow <= '0';
		end if;
		
		res <= result;	
		
		end process;
end Behavioral;

