                            --------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:46:59 10/31/2013
-- Design Name:   
-- Module Name:   C:/Users/perthol/VHDL/FPGAToplevel/SelectionCore2_TB.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SelectionCore2
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SelectionCore2_TB IS
END SelectionCore2_TB;
 
ARCHITECTURE behavior OF SelectionCore2_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SelectionCore2
        generic(
            ADDR_SIZE    : natural := 9;
            DATA_SIZE    : natural := 64;
            COUNTER_SIZE : natural := 4
        );
        port(
            ADDR   : out STD_LOGIC_VECTOR(ADDR_SIZE-1 downto 0);
            RANDOM : in  STD_LOGIC_VECTOR(ADDR_SIZE-2 downto 0);
            DATA   : in  STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
            BEST   : out STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
            NUMBER : in  STD_LOGIC_VECTOR(COUNTER_SIZE-1 downto 0);
            ENABLE : in  STD_LOGIC;
            DONE   : out STD_LOGIC;
            CLK    : in  STD_LOGIC
        );
    END COMPONENT;
    
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
    
    --Inputs
    signal RANDOM : std_logic_vector(9-2 downto 0) := (others => '0');
    signal DATA   : std_logic_vector(32-1 downto 0) := (others => '0');
    signal NUMBER : std_logic_vector(4-1 downto 0) := (others => '0');
    signal ENABLE : std_logic := '0';
    signal CLK    : std_logic := '0';

    --Outputs
    signal ADDR : std_logic_vector(9-1 downto 0);
    signal BEST : std_logic_vector(32-1 downto 0);
    signal DONE : std_logic;

    -- Pool signals
    signal a_addr : std_logic_vector(9-1 downto 0) := (others => '0');
    signal a_in   : std_logic_vector(32-1 downto 0) := (others => '0');
    signal a_out  : std_logic_vector(32-1 downto 0);
    signal a_we   : std_logic := '0';
    signal a_ce   : std_logic := '0';
    signal b_addr : std_logic_vector(9-1 downto 0) := (others => '0');
    signal b_in   : std_logic_vector(32-1 downto 0) := (others => '0');
    signal b_out  : std_logic_vector(32-1 downto 0);
    signal b_we   : std_logic := '0';
    signal b_ce   : std_logic := '0';

    -- Clock period definitions
    constant CLK_period : time := 100 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
    uut: SelectionCore2
    generic map(
        ADDR_SIZE    => 9,
        DATA_SIZE    => 32,
        COUNTER_SIZE => 4
    )
    PORT MAP (
        ADDR => ADDR,
        RANDOM => RANDOM,
        DATA => DATA,
        BEST => BEST,
        NUMBER => NUMBER,
        ENABLE => ENABLE,
        DONE => DONE,
        CLK => CLK
    );
    
    POOL : BRAM_TDP
    generic map (
        ADDR_WIDTH => 9,
        DATA_WIDTH => 32,
        WE_WIDTH   => 4,
        RAM_SIZE   => "18Kb",
        WRITE_MODE => "WRITE_FIRST"
    )
    port map(
        A_ADDR => a_addr,
        A_IN   => a_in,
        A_OUT  => a_out,
        A_WE   => a_we,
        A_EN   => a_ce,
        B_ADDR => b_addr,
        B_IN   => b_in,
        B_OUT  => b_out,
        B_WE   => b_we,
        B_EN   => b_ce,
        CLK    => CLK
    );

    -- Clock process definitions
    CLK_process : process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    
    b_addr <= ADDR;
    DATA <= b_out;
    NUMBER <= "0100";

    -- Stimulus process
    stim_proc : process
        begin		
        -- Hold reset state for 10 cycles
        wait for CLK_period*10;
        
        -- Enable BRAM
        a_ce <= '1';
        b_ce <= '1';
        
        -- Write mode
        a_we <= '1';
        
        -- Load data
        a_addr <= "000000000";
        a_in <= "00000000000000000000000000000001";
        wait for CLK_period;
        a_addr <= "000000001";
        a_in <= "00000000000000000000000000000010";
        wait for CLK_period;
        a_addr <= "000000010";
        a_in <= "00000000000000000000000000000100";
        wait for CLK_period;
        a_addr <= "000000011";
        a_in <= "00000000000000000000000000001000";
        wait for CLK_period;
        a_addr <= "000000100";
        a_in <= "00000000000000000000000000010000";
        wait for CLK_period;
        a_addr <= "000000101";
        a_in <= "00000000000000000000000000100000";
        wait for CLK_period;
        a_addr <= "000000110";
        a_in <= "00000000000000000000000001000000";
        wait for CLK_period;
        a_addr <= "000000111";
        a_in <= "00000000000000000000000010000000";
        wait for CLK_period;
        a_addr <= "000001000";
        a_in <= "00000000000000000000000100000000";
        wait for CLK_period;
        a_addr <= "000001001";
        a_in <= "00000000000000000000001000000000";
        wait for CLK_period;
        a_addr <= "000001010";
        a_in <= "00000000000000000000010000000000";
        wait for CLK_period;
        a_addr <= "000001011";
        a_in <= "00000000000000000000100000000000";
        wait for CLK_period;
        a_addr <= "000001100";
        a_in <= "00000000000000000001000000000000";
        wait for CLK_period;
        a_addr <= "000001101";
        a_in <= "00000000000000000010000000000000";
        wait for CLK_period;
        a_addr <= "000001110";
        a_in <= "00000000000000000100000000000000";
        wait for CLK_period;
        a_addr <= "000001111";
        a_in <= "00000000000000001000000000000000";
        wait for CLK_period;
        a_addr <= "000010000";
        a_in <= "00000000000000010000000000000000";
        wait for CLK_period;
        a_addr <= "000010001";
        a_in <= "00000000000000100000000000000000";
        wait for CLK_period;
        a_addr <= "000010010";
        a_in <= "00000000000001000000000000000000";
        wait for CLK_period;
        a_addr <= "000010011";
        a_in <= "00000000000010000000000000000000";
        wait for CLK_period;
        a_addr <= "000010100";
        a_in <= "00000000000100000000000000000000";
        wait for CLK_period;
        a_addr <= "000010101";
        a_in <= "00000000001000000000000000000000";
        wait for CLK_period;
        a_addr <= "000010110";
        a_in <= "00000000010000000000000000000000";
        wait for CLK_period;
        a_addr <= "000010111";
        a_in <= "00000000100000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011000";
        a_in <= "00000001000000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011001";
        a_in <= "00000010000000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011010";
        a_in <= "00000100000000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011011";
        a_in <= "00001000000000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011100";
        a_in <= "00010000000000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011101";
        a_in <= "00100000000000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011110";
        a_in <= "01000000000000000000000000000000";
        wait for CLK_period;
        a_addr <= "000011111";
        a_in <= "10000000000000000000000000000000";
        wait for CLK_period;
        
        -- Read mode
        a_we <= '0';
        
        -- Disconnect from BRAM
        a_addr <= "000000000";
        
        -- Wait 3 cycles
        wait for CLK_period*3;
        
        -- Start Selection Core
        ENABLE <= '1';
        
        -- Generate "random numbers"
        RANDOM <= "00001101"; -- 2
        wait for CLK_period;
        RANDOM <= "00000011";
        wait for CLK_period;
            ENABLE <= '0';-- Tell Selection core to stop when done
        RANDOM <= "00000111"; -- 4
        wait for CLK_period;
        RANDOM <= "00000001";
        wait for CLK_period;
        RANDOM <= "00001110"; -- 1
        wait for CLK_period;
        RANDOM <= "00001001"; -- 3
        wait for CLK_period;
        RANDOM <= "00000010";
        wait for CLK_period;
        RANDOM <= "00000100"; -- 5
        wait for CLK_period;
        
        -- Since Number = 4, it should be done by now
        
        wait for CLK_period*4;
        
        -- Start Selection Core
        ENABLE <= '1';
        
        -- Generate "random numbers"
        RANDOM <= "00000001"; -- 8
        wait for CLK_period;
        RANDOM <= "00000011"; -- 7
        wait for CLK_period;
            ENABLE <= '0';-- Tell Selection core to stop when done
        RANDOM <= "00000101"; -- 6
        wait for CLK_period;
        RANDOM <= "00000110"; -- 5
        wait for CLK_period;
        RANDOM <= "00001001"; -- 4
        wait for CLK_period;
        RANDOM <= "00001010"; -- 3
        wait for CLK_period;
        RANDOM <= "00001100"; -- 2
        wait for CLK_period;
        RANDOM <= "00001111"; -- 1
        wait for CLK_period;
        
        -- Since Number = 4, it should be done by now
        
        wait;
    end process;

END;
