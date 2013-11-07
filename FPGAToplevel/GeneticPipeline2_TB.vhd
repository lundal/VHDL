----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-04 13:42
-- Tested:   NA
--
-- Description:
-- Test bench for GeneticController
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GeneticPipeline2_TB is
end GeneticPipeline2_TB;

architecture Behavioral of GeneticPipeline2_TB is
    
    component GeneticPipeline2 is
        generic (
            NUM_PROC     : natural := 4;
            ADDR_WIDTH   : natural := 9;
            DATA_WIDTH   : natural := 64;
            RANDOM_WIDTH : natural := 32
        );
        port (
            REQUEST_0 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            REQUEST_1 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            ACK       : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            DATA_IN   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            DATA_OUT  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            RESET     : in  STD_LOGIC;
            CLK       : in  STD_LOGIC
        );
    end component;
    
    --Inputs
    signal REQUEST_0 : STD_LOGIC_VECTOR(1-1 downto 0)  := (others => '0');
    signal REQUEST_1 : STD_LOGIC_VECTOR(1-1 downto 0)  := (others => '0');
    signal DATA_IN   : STD_LOGIC_VECTOR(64-1 downto 0) := (others => '1');
    signal RESET     : STD_LOGIC := '0';
    signal CLK       : STD_LOGIC := '0';
    
    --Outputs
    signal ACK      : STD_LOGIC_VECTOR(1-1 downto 0);
    signal DATA_OUT : STD_LOGIC_VECTOR(64-1 downto 0);
    
    -- Clock
    constant clock_period : time := 10 ns;
    signal clock : STD_LOGIC;
    
begin
    
    UUT : GeneticPipeline2
    generic map (
        NUM_PROC => 1,
        ADDR_WIDTH => 9,
        DATA_WIDTH => 64,
        RANDOM_WIDTH => 32
    )
    port map (
        REQUEST_0 => REQUEST_0,
        REQUEST_1 => REQUEST_1,
        ACK       => ACK,
        DATA_IN   => DATA_IN,
        DATA_OUT  => DATA_OUT,
        RESET     => RESET,
        CLK       => clock
    );
    
    CLOCK_SYNTHESIS : process
    begin
        clock <= '1';
        wait for clock_period/2;
        clock <= '0';
        wait for clock_period/2;
    end process;
    
    STIMULUS : process
    begin
        wait for clock_period/2;
        
        RESET <= '1';
        
        wait for clock_period*520;
        
        RESET <= '0';
        
        wait for clock_period*4;
        
        REQUEST_0(0) <= '1';
        REQUEST_1(0) <= '1';
        
        wait for clock_period;
        
        REQUEST_0(0) <= '0';
        REQUEST_1(0) <= '0';
        
        wait;
    end process;
    
end Behavioral;
