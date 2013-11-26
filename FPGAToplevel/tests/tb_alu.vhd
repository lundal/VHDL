LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
library WORK;
use WORK.CONSTANTS.ALL;
 
ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 

	COMPONENT ALU
	PORT(
		X : IN  std_logic_vector(63 downto 0);
		Y : IN  std_logic_vector(63 downto 0);
		R : OUT  std_logic_vector(63 downto 0);
		FUNC : IN  std_logic_vector(3 downto 0);
		OVERFLOW : OUT  std_logic
	);
	END COMPONENT;
	
	component ZeroTester is
		generic (N : integer := 64);
		port (
			I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			Pos		:	out	STD_LOGIC;
			Zero	:	out	STD_LOGIC;
			Neg		:	out	STD_LOGIC
		);
	end component;

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

	uut: ALU PORT MAP (
		X => X,
		Y => Y,
		R => R,
		FUNC => FUNC,
		OVERFLOW => FLAGS.Overflow
	);
	
	ALU_RES_TESTER : ZeroTester
	generic map (N => 64)
	port map(
		I		=> R,
		Pos		=> FLAGS.Positive,
		Zero	=> FLAGS.Zero,
		Neg		=> FLAGS.Negative
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
		
		wait for 100 ns;
		
		-- Add: 0 + 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00000001";
		
		wait for 100 ns;
		
		-- Add: LONG.MAX + LONG.MIN = -1
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= (63 => '1', 62 downto 0 => '0');
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00000010";
		
		wait for 100 ns;
		
		-- Add: X + 0 = X (3851083069309589044 + 0 = 3851083069309589044)
		X <= "0011010101110001110010111010010111001010101110000001011000110100";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= "0011010101110001110010111010010111001010101110000001011000110100";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00000011";
		
		wait for 100 ns;
		
		-- Add: 0 + X = X (0 + -5372288967545186764 = -5372288967545186764)
		X <= ZERO64;
		Y <= "1011010101110001110010111010010111001010101110000001011000110100";
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= "1011010101110001110010111010010111001010101110000001011000110100";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00000100";
		
		wait for 100 ns;
		
		-- Add: LONG.MAX + 1 = LONG.MIN + OVERFLOW
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= (63 downto 1 => '0', 0 => '1');
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= (63 => '1', 62 downto 0 => '0');
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'1');
		TEST <= "00000101";
		
		wait for 100 ns;
		
		-- Add: LONG.MIN + -1 = LONG.MAX + OVERFLOW
		X <= (63 => '1', 62 downto 0 => '0');
		Y <= ONE64;
		FUNC <= ALU_FUNC_ADD;
		DESIRED_R <= (63 => '0', 62 downto 0 => '1');
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'1');
		TEST <= "00000110";
		
		wait for 100 ns;
		
		-- Sub: 0 + 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00000111";
		
		wait for 100 ns;
		
		-- Sub: LONG.MAX - LONG.MAX = 0
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= (63 => '0', 62 downto 0 => '1');
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001000";
		
		wait for 100 ns;
		
		-- Sub: LONG.MIN - LONG.MIN = 0
		X <= (63 => '1', 62 downto 0 => '0');
		Y <= (63 => '1', 62 downto 0 => '0');
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001001";
		
		wait for 100 ns;
		
		-- Sub: X - 0 = X (3851083069309589044 - 0 = 3851083069309589044)
		X <= "0011010101110001110010111010010111001010101110000001011000110100";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= "0011010101110001110010111010010111001010101110000001011000110100";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00001001";
		
		wait for 100 ns;
		
		-- Sub: 0 - X = -X (0 - -3851083069309589044 = 3851083069309589044)
		X <= ZERO64;
		Y <= "0011010101110001110010111010010111001010101110000001011000110100";
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= "1100101010001110001101000101101000110101010001111110100111001100";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00001010";
		
		wait for 100 ns;
		
		-- Sub: LONG.MIN - 1 = LONG.MAX + OVERFLOW
		X <= (63 => '1', 62 downto 0 => '0');
		Y <= (63 downto 1 => '0', 0 => '1');
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= (63 => '0', 62 downto 0 => '1');
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'1');
		TEST <= "00001011";
		
		wait for 100 ns;
		
		-- Sub: LONG.MAX - -1 = LONG.MIN + OVERFLOW
		X <= (63 => '0', 62 downto 0 => '1');
		Y <= ONE64;
		FUNC <= ALU_FUNC_SUB;
		DESIRED_R <= (63 => '1', 62 downto 0 => '0');
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'1');
		TEST <= "00001100";
		
		wait for 100 ns;
		
		-- Mul: 0 * 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001101";
		
		wait for 100 ns;
		
		-- Mul: X * 0 = 0 (1468857347 * 0 = 0)
		X <= ZERO32 & "01010111100011001111110000000011";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001110";
		
		wait for 100 ns;
		
		-- Mul: 0 * X = 0 (0 * 1468857347 = 0)
		X <= ZERO64;
		Y <= ONE32 & "01010111100011001111110000000011";
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00001111";
		
		wait for 100 ns;
		
		-- Mul: X * -1 = -X (1468857347 * -1 = -1468857347)
		X <= ZERO32 & "01010111100011001111110000000011";
		Y <= ONE64;
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= "1111111111111111111111111111111110101000011100110000001111111101";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00010000";
		
		wait for 100 ns;
		
		-- Mul: X * Y = Z (1468857347 * 585658464 = 860248737679135008)
		X <= ZERO32 & "01010111100011001111110000000011";
		Y <= ZERO32 & "00100010111010000111000001100000";
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= "0000101111110000001101111010101101001011110101111101000100100000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00010001";
		
		wait for 100 ns;
		
		-- Mul: -X * -Y = Z (-1468857347 * -585658464 = 860248737679135008)
		X <= "1111111111111111111111111111111110101000011100110000001111111101";
		Y <= "1111111111111111111111111111111111011101000101111000111110100000";
		FUNC <= ALU_FUNC_MUL;
		DESIRED_R <= "0000101111110000001101111010101101001011110101111101000100100000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00010010";
		
		wait for 100 ns;
		
		-- OR: 0 or 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_OR;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00010011";
		
		wait for 100 ns;
		
		-- OR: 1 or 0 = 1
		X <= ONE64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_OR;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00010100";
		
		wait for 100 ns;
		
		-- OR: 1 or 0 = 1
		X <= ZERO64;
		Y <= ONE64;
		FUNC <= ALU_FUNC_OR;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00010101";
		
		wait for 100 ns;
		
		-- OR: 1 or 1 = 1
		X <= ONE64;
		Y <= ONE64;
		FUNC <= ALU_FUNC_OR;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00010110";
		
		wait for 100 ns;
		
		-- OR: X or Y = Z
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= "0010111111000000110111101010110100101111010111110100010010000011";
		FUNC <= ALU_FUNC_OR;
		DESIRED_R <= "0010111111110000111111111010111101101111110111111101010110100011";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00010111";
		
		wait for 100 ns;
		
		-- AND: 0 and 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_AND;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00011000";
		
		wait for 100 ns;
		
		-- AND: 1 and 0 = 0
		X <= ONE64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_AND;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00011001";
		
		wait for 100 ns;
		
		-- AND: 1 and 0 = 0
		X <= ZERO64;
		Y <= ONE64;
		FUNC <= ALU_FUNC_AND;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00011010";
		
		wait for 100 ns;
		
		-- AND: 1 and 1 = 1
		X <= ONE64;
		Y <= ONE64;
		FUNC <= ALU_FUNC_AND;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00011011";
		
		wait for 100 ns;
		
		-- AND: X and Y = Z
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= "0010111111000000110111101010110100101111010111110100010010000011";
		FUNC <= ALU_FUNC_AND;
		DESIRED_R <= "0000101111000000000101101010100100001011010101110100000000000000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00011100";
		
		wait for 100 ns;
		
		-- XOR: 0 xor 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_XOR;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00011101";
		
		wait for 100 ns;
		
		-- XOR: 1 xor 0 = 1
		X <= ONE64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_XOR;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00011110";
		
		wait for 100 ns;
		
		-- XOR: 1 xor 0 = 1
		X <= ZERO64;
		Y <= ONE64;
		FUNC <= ALU_FUNC_XOR;
		DESIRED_R <= ONE64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00011111";
		
		wait for 100 ns;
		
		-- XOR: 1 xor 1 = 0
		X <= ONE64;
		Y <= ONE64;
		FUNC <= ALU_FUNC_XOR;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00100000";
		
		wait for 100 ns;
		
		-- XOR: X xor Y = Z
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= "0010111111000000110111101010110100101111010111110100010010000011";
		FUNC <= ALU_FUNC_XOR;
		DESIRED_R <= "0010010000110000111010010000011001100100100010001001010110100011";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00100001";
		
		wait for 100 ns;
		
		-- SRA: 0 >> 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SRA;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00100010";
		
		wait for 100 ns;
		
		-- SRA: 0 >> X = 0 (0 >> 13 = 0)
		X <= ZERO64;
		Y <= ZERO32 & ZERO16 & ZERO8 & "00001101";
		FUNC <= ALU_FUNC_SRA;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00100011";
		
		wait for 100 ns;
		
		-- SRA: X >> 0 = X (860248737679135008 >> 0 = 860248737679135008)
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SRA;
		DESIRED_R <= "0000101111110000001101111010101101001011110101111101000100100000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00100100";
		
		wait for 100 ns;
		
		-- SRA: X >> Y = Z (860248737679135008 >> 6 = 13441386526236484)
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO32 & ZERO16 & ZERO8 & "00000110";
		FUNC <= ALU_FUNC_SRA;
		DESIRED_R <= "0000000000101111110000001101111010101101001011110101111101000100";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00100101";
		
		wait for 100 ns;
		
		-- SRA: -X >> Y = -Z (-8363123299175640800 >> 48 = -29712)
		X <= "1000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO32 & ZERO16 & ZERO8 & "00110000";
		FUNC <= ALU_FUNC_SRA;
		DESIRED_R <= ONE32 & ONE16 & "1000101111110000";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00100110";
		
		wait for 100 ns;
		
		-- SLL: 0 << 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SLL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00100111";
		
		wait for 100 ns;
		
		-- SLL: 0 << X = 0 (0 << 13 = 0)
		X <= ZERO64;
		Y <= ZERO32 & ZERO16 & ZERO8 & "00001101";
		FUNC <= ALU_FUNC_SLL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00101000";
		
		wait for 100 ns;
		
		-- SLL: X << 0 = X (860248737679135008 << 0 = 860248737679135008)
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SLL;
		DESIRED_R <= "0000101111110000001101111010101101001011110101111101000100100000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00101001";
		
		wait for 100 ns;
		
		-- SLL: X << Y = Z (860248737679135008 << 6 = -284313009664014336)
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO32 & ZERO16 & ZERO8 & "00000110";
		FUNC <= ALU_FUNC_SLL;
		DESIRED_R <= "1111110000001101111010101101001011110101111101000100100000000000";
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00101010";
		
		wait for 100 ns;
		
		-- SLL: X << Y = Z (-8363123299175640800 << 48 = -3377699720527872000)
		X <= "1000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO32 & ZERO16 & ZERO8 & "00110000";
		FUNC <= ALU_FUNC_SLL;
		DESIRED_R <= "1101000100100000" & ZERO32 & ZERO16;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'0', Negative=>'1', Overflow=>'0');
		TEST <= "00101011";
		
		wait for 100 ns;
		
		-- SRL: 0 >> 0 = 0
		X <= ZERO64;
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SRL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00101100";
		
		wait for 100 ns;
		
		-- SRL: 0 >> X = 0 (0 >> 13 = 0)
		X <= ZERO64;
		Y <= ZERO32 & ZERO16 & ZERO8 & "00001101";
		FUNC <= ALU_FUNC_SRL;
		DESIRED_R <= ZERO64;
		DESIRED_FLAGS <= (Positive=>'0', Zero=>'1', Negative=>'0', Overflow=>'0');
		TEST <= "00101101";
		
		wait for 100 ns;
		
		-- SRL: X >> 0 = X (860248737679135008 >> 0 = 860248737679135008)
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO64;
		FUNC <= ALU_FUNC_SRL;
		DESIRED_R <= "0000101111110000001101111010101101001011110101111101000100100000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00101110";
		
		wait for 100 ns;
		
		-- SRL: X >> Y = Z (860248737679135008 >> 6 = 13441386526236484)
		X <= "0000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO32 & ZERO16 & ZERO8 & "00000110";
		FUNC <= ALU_FUNC_SRL;
		DESIRED_R <= "0000000000101111110000001101111010101101001011110101111101000100";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00101111";
		
		wait for 100 ns;
		
		-- SRL: -X >> Y = -Z (-8363123299175640800 >> 48 = -29712)
		X <= "1000101111110000001101111010101101001011110101111101000100100000";
		Y <= ZERO32 & ZERO16 & ZERO8 & "00110000";
		FUNC <= ALU_FUNC_SRL;
		DESIRED_R <= ZERO32 & ZERO16 & "1000101111110000";
		DESIRED_FLAGS <= (Positive=>'1', Zero=>'0', Negative=>'0', Overflow=>'0');
		TEST <= "00110000";
		
		wait;
	end process;

END;
