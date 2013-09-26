----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:02:36 09/17/2013 
-- Design Name: 
-- Module Name:    Multiplier - Behavioral 
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

entity Multiplier is
	generic (
		N : natural := 64
	);
    port (
		A			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		B			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		Result		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		Overflow	:	out	STD_LOGIC
	);
end Multiplier;
	
architecture Behavioral of Multiplier is

	signal Res		:	STD_LOGIC_VECTOR (2*N-1 downto 0);
	signal Res_High	:	STD_LOGIC_VECTOR (N-1 downto 0);
	signal Res_Low	:	STD_LOGIC_VECTOR (N-1 downto 0);
	
begin

	Multiply: process(A, B, Res, Res_Low, Res_High) begin
		Res <= A * B;
		
		-- Check for overflow
		-- All extra bits should be equal to sign
		if Res(2*N-1 downto N-1) = (N downto 0 => '0') then
			Overflow <= '0';
		elsif Res(2*N-1 downto N-1) = (N downto 0 => '1') then
			Overflow <= '0';
		else
			Overflow <= '1';
		end if;
		
		Result <= Res(N-1 downto 0);
		
	end process Multiply;

end Behavioral;

