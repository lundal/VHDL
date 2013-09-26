----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:49:58 09/26/2013 
-- Design Name: 
-- Module Name:    SignExtender - Behavioral 
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

entity SignExtender is
	generic (
		N : natural := 32;
		M : natural := 64
	);
	port (
		I	:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		O	:	out	STD_LOGIC_VECTOR(M-1 downto 0)
	);
end SignExtender;

architecture Behavioral of SignExtender is

begin
	
	O(N-1 downto 0) <= I(N-1 downto 0);
	O(M-1 downto N) <= (others => I(N-1));
	
end Behavioral;

