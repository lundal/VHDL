----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-24 14:08
-- Tested:   Never
--
-- Description:
-- A 2-port mux for the great memory mux
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MemMuxA is
    generic(
        DATA_WIDTH : natural := 16
    );
    port(
        CE     : out STD_LOGIC;
        WE     : out STD_LOGIC;
        DATA_IN : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        A_CE   : in  STD_LOGIC;
        A_WE   : in  STD_LOGIC;
        A_DATA_IN : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        A_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        B_CE   : in  STD_LOGIC;
        B_WE   : in  STD_LOGIC;
        B_DATA_IN : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        B_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        Sel    : in  STD_LOGIC
    );
end MemMuxA;

architecture Behavioral of MemMuxA is
    
begin
    
    CE   <= A_CE when Sel = '0' else B_CE;
    WE   <= A_WE when Sel = '0' else B_WE;
    
    DATA_OUT <= A_DATA_IN when Sel = '0' else B_DATA_IN;
    
    A_DATA_OUT <= DATA_IN;
    B_DATA_OUT <= DATA_IN;
    
end Behavioral;

