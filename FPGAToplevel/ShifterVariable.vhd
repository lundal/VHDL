----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:32 09/26/2013 
-- Design Name: 
-- Module Name:    Shifter - Behavioral 
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

library WORK;

entity ShifterVariable is
	generic (
		N : natural := 64;
		M : natural := 6
	);
    port (
		I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		Left	:	in	STD_LOGIC;
		Arith	:	in	STD_LOGIC;
		Count	:	in	STD_LOGIC_VECTOR(M-1 downto 0)
	);
end ShifterVariable;

architecture Behavioral of ShifterVariable is
	
	component Shifter is
		generic (
			N : natural := 64;
			M : natural := 1
		);
		port (
			I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
			Left	:	in	STD_LOGIC;
			Arith	:	in	STD_LOGIC;
			Enable	:	in	STD_LOGIC
		);
	end component;
	
	type ResA is array (M downto 0) of STD_LOGIC_VECTOR(N-1 downto 0);
	
	signal Res : ResA := (others => (others =>'0'));
	
begin
	
	Res(0) <= I;
	
	GEN_SHIFTERS :
	for i in 0 to M-1 generate
		GEN_SHIFTER : Shifter
			generic map (
				N => N,
				M => 2 ** i
			)
			port map (
				I => Res(i),
				O => Res(i+1),
				Left => Left,
				Arith => Arith,
				Enable => Count(i)
			);
	end generate;
	
	O <= Res(M);

end Behavioral;

