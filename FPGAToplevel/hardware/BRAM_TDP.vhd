							----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:37:44 10/13/2013 
-- Design Name: 
-- Module Name:    BRAM_TDP - Behavioral 
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

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

-- See the configuration table on page 28 of the following pdf to set up correct signal widths
-- http://www.xilinx.com/support/documentation/sw_manuals/xilinx12_4/spartan6_hdl.pdf

entity BRAM_TDP is
	generic (
		ADDR_WIDTH	:	natural := 9;
		DATA_WIDTH	:	natural := 32;
		WE_WIDTH	:	natural := 4;
		RAM_SIZE	:	string	:= "18Kb";
		WRITE_MODE	:	string	:= "WRITE_FIRST"
	);
	port (
		A_ADDR	:	in	STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		A_IN	:	in	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		A_OUT	:	out	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		A_WE	:	in	STD_LOGIC;
		A_EN	:	in	STD_LOGIC;
		B_ADDR	:	in	STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		B_IN	:	in	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		B_OUT	:	out	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		B_WE	:	in	STD_LOGIC;
		B_EN	:	in	STD_LOGIC;
		CLK		:	in	STD_LOGIC
	);
end BRAM_TDP;

architecture Behavioral of BRAM_TDP is
	
	-- WE signals
	signal A_WE_EXT : STD_LOGIC_VECTOR(WE_WIDTH-1 downto 0);
	signal B_WE_EXT : STD_LOGIC_VECTOR(WE_WIDTH-1 downto 0);
	
	component BRAM_TDP_MACRO is
		generic (
			BRAM_SIZE : string;
			DEVICE : string;
			DOA_REG : integer;
			DOB_REG : integer;
			READ_WIDTH_A : integer;
			READ_WIDTH_B : integer;
			SIM_COLLISION_CHECK : string;
			WRITE_MODE_A : string;
			WRITE_MODE_B : string;
			WRITE_WIDTH_A : integer;
			WRITE_WIDTH_B : integer
		);
		port (
			DOA : out std_logic_vector;
			DOB : out std_logic_vector;
			ADDRA : in std_logic_vector;
			ADDRB : in std_logic_vector;
			CLKA : in std_ulogic;
			CLKB : in std_ulogic;
			DIA : in std_logic_vector;
			DIB : in std_logic_vector;
			ENA : in std_ulogic;
			ENB : in std_ulogic;
			REGCEA : in std_ulogic;
			REGCEB : in std_ulogic;
			RSTA : in std_ulogic;
			RSTB : in std_ulogic;
			WEA : in std_logic_vector;
			WEB : in std_logic_vector
		);
	end component;
begin
	GEN_WE_SIGNALS :
	for i in 0 to WE_WIDTH-1 generate
		A_WE_EXT(i) <= A_WE;
		B_WE_EXT(i) <= B_WE;
	end generate;
	
	BRAM_TDP_MACRO_inst : BRAM_TDP_MACRO
	generic map (
		BRAM_SIZE => "18Kb", -- Target BRAM, "9Kb" or "18Kb"
		DEVICE => "SPARTAN6", -- Target Device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
		DOA_REG => 0, -- Optional port A output register (0 or 1)
		DOB_REG => 0, -- Optional port B output register (0 or 1)
		READ_WIDTH_A => DATA_WIDTH, -- Valid values are 1-36
		READ_WIDTH_B => DATA_WIDTH, -- Valid values are 1-36
		SIM_COLLISION_CHECK => "ALL", -- Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE"
		WRITE_MODE_A => WRITE_MODE, -- "WRITE_FIRST", "READ_FIRST" or "NO_CHANGE"
		WRITE_MODE_B => WRITE_MODE, -- "WRITE_FIRST", "READ_FIRST" or "NO_CHANGE"
		WRITE_WIDTH_A => DATA_WIDTH, -- Valid values are 1-36
		WRITE_WIDTH_B => DATA_WIDTH -- Valid values are 1-36
	)
	port map (
		DOA => A_OUT, -- Output port-A data
		DOB => B_OUT, -- Output port-B data
		ADDRA => A_ADDR, -- Input port-A address
		ADDRB => B_ADDR, -- Input port-B address
		CLKA => CLK, -- Input port-A clock
		CLKB => CLK, -- Input port-B clock
		DIA => A_IN, -- Input port-A data
		DIB => B_IN, -- Input port-B data
		ENA => A_EN, -- Input port-A enable
		ENB => B_EN, -- Input port-B enable
		REGCEA => '0', -- Input port-A output register enable
		REGCEB => '0', -- Input port-B output register enable
		RSTA => '0', -- Input port-A reset
		RSTB => '0', -- Input port-B reset
		WEA => A_WE_EXT, -- Input port-A write enable
		WEB => B_WE_EXT -- Input port-B write enable
	);

end Behavioral;

