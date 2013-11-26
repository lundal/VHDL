----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-03 11:09
-- Tested:   Never
--
-- Description:
-- Double data width BRAM (38-72 bit data, 9 bit address)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BRAM_TDP_WIDE is
    generic (
        ADDR_WIDTH : natural := 9;
        DATA_WIDTH : natural := 64;
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
        CLK	   : in  STD_LOGIC
    );
end BRAM_TDP_WIDE;

architecture Behavioral of BRAM_TDP_WIDE is
    
    component BRAM_TDP is
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
    end component;
    
    signal A_IN_H  : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    signal A_IN_L  : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    signal A_OUT_H : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    signal A_OUT_L : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    
    signal B_IN_H  : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    signal B_IN_L  : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    signal B_OUT_H : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    signal B_OUT_L : STD_LOGIC_VECTOR(DATA_WIDTH/2-1 downto 0);
    
begin
    
    HIGH_MEM : BRAM_TDP
    generic map(
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH/2,
        WE_WIDTH   => 4,
        RAM_SIZE   => "18Kb",
        WRITE_MODE => WRITE_MODE
    )
    port map(
        A_ADDR => A_ADDR,
        A_IN   => A_IN_H,
        A_OUT  => A_OUT_H,
        A_WE   => A_WE,
        A_EN   => A_EN,
        B_ADDR => B_ADDR,
        B_IN   => B_IN_H,
        B_OUT  => B_OUT_H,
        B_WE   => B_WE,
        B_EN   => B_EN,
        CLK	   => CLK
    );
    
    LOW_MEM : BRAM_TDP
    generic map(
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH/2,
        WE_WIDTH   => 4,
        RAM_SIZE   => "18Kb",
        WRITE_MODE => WRITE_MODE
    )
    port map(
        A_ADDR => A_ADDR,
        A_IN   => A_IN_L,
        A_OUT  => A_OUT_L,
        A_WE   => A_WE,
        A_EN   => A_EN,
        B_ADDR => B_ADDR,
        B_IN   => B_IN_L,
        B_OUT  => B_OUT_L,
        B_WE   => B_WE,
        B_EN   => B_EN,
        CLK	   => CLK
    );
    
    -- Split input signals
    A_IN_H <= A_IN(DATA_WIDTH-1 downto DATA_WIDTH/2);
    A_IN_L <= A_IN(DATA_WIDTH/2-1 downto 0);
    B_IN_H <= B_IN(DATA_WIDTH-1 downto DATA_WIDTH/2);
    B_IN_L <= B_IN(DATA_WIDTH/2-1 downto 0);
    
    -- Concatenate output signals
    A_OUT <= A_OUT_H & A_OUT_L;
    B_OUT <= B_OUT_H & B_OUT_L;
    
end Behavioral;

