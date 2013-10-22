----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-22 18:36
-- Updated:  2013-10-22 18:50
-- Tested:   Never
--
-- Description:
-- A 2-port mux for the memory chips
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MemMux is
	port (
		CE     : out STD_LOGIC;
		WE     : out STD_LOGIC;
		ADDR   : out STD_LOGIC_VECTOR(18 downto 0);
		DATA   : inout STD_LOGIC_VECTOR(15 downto 0);
		
		A_CE   : in  STD_LOGIC;
		A_WE   : in  STD_LOGIC;
		A_ADDR : in  STD_LOGIC_VECTOR(18 downto 0);
		A_DATA : inout STD_LOGIC_VECTOR(15 downto 0);
		
		B_CE   : in  STD_LOGIC;
		B_WE   : in  STD_LOGIC;
		B_ADDR : in  STD_LOGIC_VECTOR(18 downto 0);
		B_DATA : inout STD_LOGIC_VECTOR(15 downto 0);
		
		Sel    : in  STD_LOGIC
	);
end MemMux;

architecture Behavioral of MemMux is
	
begin
	
	CE   <= A_CE when Sel = '0' else B_CE;
	WE   <= A_WE when Sel = '0' else B_WE;
	ADDR <= A_ADDR when Sel = '0' else B_ADDR;
	DATA <= A_DATA when Sel = '0' else B_DATA;
	
	A_DATA <= DATA when Sel = '0' else (others => 'Z');
	B_DATA <= DATA when Sel = '1' else (others => 'Z');
	
end Behavioral;

