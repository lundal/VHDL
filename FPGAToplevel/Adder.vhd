----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:48 09/17/2013 
-- Design Name: 
-- Module Name:    Adder - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Adder is
    Port (
				A : in  STD_LOGIC_VECTOR(63 downto 0);
				B : in  STD_LOGIC_VECTOR (63 downto 0);
				res : out  STD_LOGIC_VECTOR (63 downto 0);
				overflow : out STD_LOGIC);
end Adder;

architecture Behavioral of Adder is

		Signal same_sign : STD_LOGIC;
		Signal sign_check : STD_LOGIC;
		Signal result : STD_LOGIC_VECTOR (63 downto 0);

begin
	ADD: process (A, B, same_sign, sign_check, result) is
		begin
		
		-- Overflow may only happen when both MSBs from A and Bare the same 
		-- If both are same, then same_sign and sign_check will be set to '1'
		-- Same_sign and sign_check are used to control overflow.
		if (A(63) = B(63)) then
			same_sign <= '1'; 
			sign_check <= A(63);
		else
			same_sign <='0';
		end if;
		
		result <= A + B;							
		
		-- When same_sign is '1', overflow is possible and will be controlled
		if (same_sign = '1') then 
		-- Result based on output res used for overflow control
		--	result <= A + B;							
		-- Change in MSB between result and old inputs means overflow (sich_check is a copy used for the control)
			if(sign_check /= result(63)) then 
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

