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

entity MemMuxB is
    generic(
        ADDR_WIDTH : natural := 19
    );
    port(
        ADDR   : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        LBUB   : out STD_LOGIC;
        
        A_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        A_LBUB : in  STD_LOGIC;
        
        B_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        B_LBUB : in  STD_LOGIC;
        
        Sel    : in  STD_LOGIC
    );
end MemMuxB;

architecture Behavioral of MemMuxB is
    
begin
    
    ADDR <= A_ADDR when Sel = '0' else B_ADDR;
    LBUB   <= A_LBUB when Sel = '0' else B_LBUB;
    
end Behavioral;

