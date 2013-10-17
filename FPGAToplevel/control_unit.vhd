----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:41 09/21/2013 
-- Design Name: 
-- Module Name:    Control Unit - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity control_unit is
	port (
		OP_CODE		:	in	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0);
		ALU_SOURCE	:	out	STD_LOGIC;
		IMM_SOURCE	:	out STD_LOGIC;
		MEM_WRITE	:	out	STD_LOGIC;
		REG_WRITE	:	out	STD_LOGIC;
		MEM_TO_REG	:	out	STD_LOGIC;
		REG_DEST	:	out	STD_LOGIC
	);
end entity;