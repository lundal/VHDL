----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:18 10/17/2013 
-- Design Name: 
-- Module Name:    FitnessMemCtrl - Behavioral 
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
use WORK.CONSTANTS.ALL;

entity FitnessMemCtrl is
	port(
		signal OP			:	in		MEM_OP;
		signal HALT			:	out		std_logic;
		signal PROC_ADDR	:	in		std_logic_vector(INST_WIDTH-1 downto 0);
		signal PROC_DATA	:	inout	std_logic_vector(DATA_WIDTH-1 downto 0);
		signal BUS_ADDR		:	out		std_logic_vector(INST_WIDTH-1 downto 0);
		signal BUS_DATA		:	inout	std_logic_vector(DATA_WIDTH-1 downto 0);
		signal BUS_WRITE	:	out		std_logic;
		signal REQ			:	out		std_logic;
		signal ACK			:	out		std_logic
	);
end FitnessMemCtrl;

architecture Behavioral of FitnessMemCtrl is
	type state_type is (idle, request, active);
	signal state : state_type := idle;
begin


end Behavioral;

