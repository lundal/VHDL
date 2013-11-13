----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-04 13:17
-- Tested:   NA
--
-- Description:
-- Test bench for Distributor
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_distributor is
end tb_istributor;

architecture Behavioral of tb_distributor is
    
    component Distributor is
        generic (
            ADDR_WIDTH : natural := 9
        );
        port (
            ADDR_A : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            ADDR_B : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            STORE  : in  STD_LOGIC
        );
    end component;
    
    -- Inputs
    signal STORE : STD_LOGIC;
    
    -- Outputs
    signal ADDR_A : STD_LOGIC_VECTOR(3-1 downto 0);
    signal ADDR_B : STD_LOGIC_VECTOR(3-1 downto 0);
    
    -- Clock
    constant clock_period : time := 10 ns;
    signal clock : STD_LOGIC;
    
begin
    
    UUT : Distributor
    generic map (
        ADDR_WIDTH => 3
    )
    port map (
        ADDR_A => ADDR_A,
        ADDR_B => ADDR_B,
        STORE  => STORE
    );
    
    CLOCK_SYNTHESIS : process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;
    
    STORE <= clock;
    
end Behavioral;

