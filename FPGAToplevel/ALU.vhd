----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:41 09/21/2013 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	
	generic(N : integer := 64);
	
	type ALU_FUNC is STD_LOGIC_VECTOR(3 downto 0);
	type ALU_DATA_BUS is STD_LOGIC_VECTOR(N-1 downto 0);
	
	type ALU_FLAGS is
	record
		Carry		:	STD_LOGIC;
		Overflow	:	STD_LOGIC;
		Zero		:	STD_LOGIC;
		Negative	:	STD_LOGIC;
	end record;
	
    port(
		X		:	in	ALU_DATA_BUS;
		Y		:	in	ALU_DATA_BUS;
		R		:	out	ALU_DATA_BUS;
		FLAGS	:	out	ALU_FLAGS
	);
	
end ALU;

architecture Behavioral of ALU is
	
	-- Result signals
	signal R_ADD	:	ALU_DATA_BUS;
	signal R_SUB	:	ALU_DATA_BUS;
	signal R_MUL	:	ALU_DATA_BUS;
	signal R_AND	:	ALU_DATA_BUS;
	signal R_OR		:	ALU_DATA_BUS;
	signal R_XOR	:	ALU_DATA_BUS;
	
begin


end Behavioral;

