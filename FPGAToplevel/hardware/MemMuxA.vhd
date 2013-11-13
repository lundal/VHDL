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
        DATA   : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        A_CE   : in  STD_LOGIC;
        A_WE   : in  STD_LOGIC;
        A_DATA : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        B_CE   : in  STD_LOGIC;
        B_WE   : in  STD_LOGIC;
        B_DATA : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        Sel    : in  STD_LOGIC
    );
end MemMuxA;

architecture Behavioral of MemMuxA is
    
begin
    
    CE   <= A_CE when Sel = '0' else B_CE;
    WE   <= A_WE when Sel = '0' else B_WE;
    DATA <= A_DATA when Sel = '0' else B_DATA;
    
    A_DATA <= DATA when Sel = '0' else (others => 'Z');
    B_DATA <= DATA when Sel = '1' else (others => 'Z');
    
end Behavioral;

