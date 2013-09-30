--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:03:28 09/30/2013
-- Design Name:   
-- Module Name:   C:/Users/perthol/VHDL/FPGAToplevel/tb_alu.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
library WORK;
use WORK.ALU_CONSTANTS.ALL;
 
ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT ALU
	PORT(
		X : IN  std_logic_vector(63 downto 0);
		Y : IN  std_logic_vector(63 downto 0);
		R : OUT  std_logic_vector(63 downto 0);
		FUNC : IN  std_logic_vector(3 downto 0);
		FLAGS : OUT  ALU_FLAGS
	);
	END COMPONENT;


	--Inputs
	signal X : std_logic_vector(63 downto 0) := (others => '0');
	signal Y : std_logic_vector(63 downto 0) := (others => '0');
	signal FUNC : std_logic_vector(3 downto 0) := (others => '0');

	--Outputs
	signal R : std_logic_vector(63 downto 0);
	signal FLAGS : ALU_FLAGS;
	
	--Test
	signal DESIRED_R : std_logic_vector(63 downto 0);
	signal DESIRED_FLAGS : ALU_FLAGS;
	signal ERROR : std_logic;
	signal TEST : std_logic_vector(7 downto 0);
	
BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP (
		X => X,
		Y => Y,
		R => R,
		FUNC => FUNC,
		FLAGS => FLAGS
	);
	
	-- Error tester
	error_proc: process(R, DESIRED_R, FLAGS, DESIRED_FLAGS)
	begin
		if (R = DESIRED_R) and (FLAGS = DESIRED_FLAGS) then
			ERROR <= '0';
		else
			ERROR <= '1';
		end if;
	end process;
	
	-- Stimulus process
	stim_proc: process
	begin
		-- Reset
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_NA;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00000000";
		
		wait for 10 ns;
		
		-- Add: 0 + 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00000001";
		
		wait for 10 ns;
		
		-- Add: LONG.MAX + LONG.MIN = -1
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= (63 => '1', 62 downto 0 => '0');
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00000010";
		
		wait for 10 ns;
		
		-- Add: X + 0 = X (3851083069309589044 + 0 = 3851083069309589044)
		X <= "0011010101110001110010111010010111001010101110000001011000110100";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= "0011010101110001110010111010010111001010101110000001011000110100";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00000011";
		
		wait for 10 ns;
		
		-- Add: 0 + X = X (0 + -5372288967545186764 = -5372288967545186764)
		X <= ZERO64;
		Y <= "1011010101110001110010111010010111001010101110000001011000110100";
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= "1011010101110001110010111010010111001010101110000001011000110100";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00000100";
		
		-- Add: LONG.MAX + 1 = LONG.MIN + OVERFLOW
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= (63 downto 1 => '0', 0 => '1');
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= (63 => '1', 62 downto 0 => '0');
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'1');
		TEST <= "00000101";
		
		wait for 10 ns;
		
		-- Add: LONG.MIN + -1 = LONG.MAX + OVERFLOW
		X <= (63 => '1', 62 downto 0 => '0');
		Y <= ONE64;
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= (63 => '0', 62 downto 0 => '1');
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'1');
		TEST <= "00000110";
		
		wait for 10 ns;
		
		-- Sub: 0 + 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00000111";
		
		wait for 10 ns;
		
		-- Sub: LONG.MAX - LONG.MAX = 0
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= (63 => '0', 62 downto 0 => '1');
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001000";
		
		wait for 10 ns;
		
		-- Sub: LONG.MIN - LONG.MIN = 0
		X <= (63 => '1', 62 downto 0 => '0');
		Y <= (63 => '1', 62 downto 0 => '0');
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001001";
		
		wait for 10 ns;
		
		-- Sub: X - 0 = X (3851083069309589044 - 0 = 3851083069309589044)
		X <= "0011010101110001110010111010010111001010101110000001011000110100";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= "0011010101110001110010111010010111001010101110000001011000110100";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00001001";
		
		wait for 10 ns;
		
		-- Sub: 0 - X = -X (0 - -3851083069309589044 = 3851083069309589044)
		X <= ZERO64;
		Y <= "0011010101110001110010111010010111001010101110000001011000110100";
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= "1100101010001110001101000101101000110101010001111110100111001100";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00001010";
		
		wait for 10 ns;
		
		-- Sub: LONG.MIN - 1 = LONG.MAX + OVERFLOW
		X <= (63 => '1', 62 downto 0 => '0');
		Y <= (63 downto 1 => '0', 0 => '1');
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= (63 => '0', 62 downto 0 => '1');
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'1');
		TEST <= "00001011";
		
		wait for 10 ns;
		
		-- Sub: LONG.MAX - -1 = LONG.MIN + OVERFLOW
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= ONE64;
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= (63 => '1', 62 downto 0 => '0');
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'1');
		TEST <= "00001100";
		
		wait for 10 ns;
		
		-- Mul: 0 * 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001101";
		
		wait for 10 ns;
		
		-- Mul: X * 0 = 0 (1468857347 * 0 = 0)
		X <= ZERO32 & "01010111100011001111110000000011";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001110";
		
		wait for 10 ns;
		
		-- Mul: 0 * X = 0 (0 * 1468857347 = 0)
		X <= ZERO64;
		Y <= ONE32 & "01010111100011001111110000000011";
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001111";
		
		wait for 10 ns;
		
		-- Mul: X * -1 = -X (1468857347 * -1 = -1468857347)
		X <= ZERO32 & "01010111100011001111110000000011";
		Y <= ONE64;
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= "1111111111111111111111111111111110101000011100110000001111111101";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00010000";
		
		wait for 10 ns;
		
		-- Mul: X * Y = Z (1468857347 * 585658464 = 860248737679135008)
		X <= ZERO32 & "01010111100011001111110000000011";
		Y <= ZERO32 & "00100010111010000111000001100000";
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= "0000101111110000001101111010101101001011110101111101000100100000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00010001";
		
		wait for 10 ns;
		
		-- Mul: -X * -Y = Z (-1468857347 * -585658464 = 860248737679135008)
		X <= "1111111111111111111111111111111110101000011100110000001111111101";
		Y <= "1111111111111111111111111111111111011101000101111000111110100000";
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= "0000101111110000001101111010101101001011110101111101000100100000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00010010";
		
		wait for 10 ns;
		
		wait;
	end process;

END;
