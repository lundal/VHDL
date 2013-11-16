----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-22 18:05
-- Updated:  2013-10-22 18:25
-- Tested:   Never
--
-- Description:
-- Simulates a memory chip with 19-bit address and 16-bit data bus by using BRAM
-- The main difference is that this component requires a clock signal
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FakeMem is
	port (
		ADDR : in  STD_LOGIC_VECTOR(18 downto 0);
		DATA : inout STD_LOGIC_VECTOR(15 downto 0);
		WE   : in  STD_LOGIC;
		CE   : in  STD_LOGIC;
		CLK  : in  STD_LOGIC -- TODO: Find a way to remove this?
	);
end FakeMem;

architecture Behavioral of FakeMem is
	component BRAM_TDP is
		generic (
			ADDR_WIDTH : natural := 9;
			DATA_WIDTH : natural := 32;
			WE_WIDTH   : natural := 4;
			RAM_SIZE   : string	:= "18Kb";
			WRITE_MODE : string	:= "WRITE_FIRST"
		);
		port (
			A_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
			A_IN   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			A_OUT  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			A_WE   : in  STD_LOGIC;
			A_EN   : in  STD_LOGIC;
			B_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
			B_IN   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			B_OUT  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			B_WE   : in  STD_LOGIC;
			B_EN   : in  STD_LOGIC;
			CLK    : in  STD_LOGIC
		);
	end component;
	
	signal INT_OUT : STD_LOGIC_VECTOR(15 downto 0);
    
    signal NCLK : STD_LOGIC;
begin
	BRAM : BRAM_TDP
	generic map (
		ADDR_WIDTH => 10,
		DATA_WIDTH => 16,
		WE_WIDTH => 2,
		RAM_SIZE => "18Kb",
		WRITE_MODE => "READ_FIRST"
	)
	port map (
		A_ADDR => ADDR(9 downto 0),
		A_IN   => DATA,
		A_OUT  => INT_OUT,
		A_WE   => not WE,
		A_EN   => not CE,
		B_ADDR => (others => '0'),
		B_IN   => (others => '0'),
--		B_OUT  => (others => 'Z'),
		B_WE   => '0',
		B_EN   => '0',
		CLK    => NCLK
	);
	
	DATA <= INT_OUT when (WE = '1') else (others => 'Z');
    
    NCLK <= not CLK;
	
end Behavioral;

