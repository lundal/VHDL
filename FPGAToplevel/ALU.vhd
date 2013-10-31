----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:41 09/21/2013 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity ALU is
	
	generic(
		N : integer := 64;
		MULTIPLIER : integer := 1
	);
	
	port(
		X			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		Y			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		R			:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		FUNC		:	in	STD_LOGIC_VECTOR(3 downto 0);
		OVERFLOW	:	out STD_LOGIC
	);
	
end ALU;

architecture Behavioral of ALU is
	
	component Adder is
		generic (N : integer := 64);
		port (
			A			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			B			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			R			:	out	STD_LOGIC_VECTOR(N-1 downto 0);
			CARRY_IN	:	in	STD_LOGIC;
			OVERFLOW	:	out	STD_LOGIC
		);
	end component;
	
	component ShifterVariable is
		generic (
			N : natural := 64;
			M : natural := 6
		);
		port (
			I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
			Left	:	in	STD_LOGIC;
			Arith	:	in	STD_LOGIC;
			Count	:	in	STD_LOGIC_VECTOR(M-1 downto 0)
		);
	end component;
	
	component Multiplier2 is
		generic (
			N : natural := 32
		);
		port (
			A			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			B			:	in	STD_LOGIC_VECTOR(N-1 downto 0);
			Result		:	out	STD_LOGIC_VECTOR(2*N-1 downto 0)
		);
	end component;
	
	-- Adder signals
	signal add_a		:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal add_b		:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal add_carry_in	:	STD_LOGIC;
	signal add_overflow	:	STD_LOGIC;
	
	-- Shifter signals
	signal shift_left	:	STD_LOGIC;
	signal shift_arith	:	STD_LOGIC;
	
	-- Result signals
	signal r_addsub	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_mul	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_and	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_or		:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_xor	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal r_shift	:	STD_LOGIC_VECTOR(N-1 downto 0);
	
	-- Other signals
	signal y_new	:	STD_LOGIC_VECTOR(N-1 downto 0);
	signal result	:	STD_LOGIC_VECTOR(N-1 downto 0);
	
begin
	
	ADDER_SUBTRACTOR : Adder
	generic map (N => N)
	port map(
		A			=> X,
		B			=> y_new,
		R			=> r_addsub,
		CARRY_IN	=> add_carry_in,
		OVERFLOW	=> add_overflow
	);
	
	SHIFTER : ShifterVariable
	generic map (
		N => N,
		M => 6 -- Todo: Gereric?
	)
	port map (
		I => X,
		O => r_shift,
		Left => shift_left,
		Arith => shift_arith,
		Count => Y(6-1 downto 0)
	);
	
	GEN_MULT : if MULTIPLIER = 1 generate
		MULTIPLY : Multiplier2
		generic map (
			N => N/2
		)
		port map (
			A			=> X(N/2-1 downto 0),
			B			=> Y(N/2-1 downto 0),
			Result		=> r_mul
		);
	end generate;
	
	GEN_MULT_RES : if MULTIPLIER /= 1 generate
		r_mul <= (others => '0');
	end generate;
	
	INVERT_Y : process(Y, FUNC)
	begin
		if FUNC = ALU_FUNC_SUB then
			y_new <= not Y;
			add_carry_in <= '1';
		else
			y_new <= Y;
			add_carry_in <= '0';
		end if;
	end process;
	
	-- Todo: y_new?
	LOGICS : process(X, Y, FUNC)
	begin
		r_and		<=	X and Y;
		r_or		<=	X or Y;
		r_xor		<=	X xor Y;
	end process;
	
	SHIFTIFIER : process(FUNC)
	begin
		case FUNC is
			when ALU_FUNC_SRA	=>
				shift_left <= '0';
				shift_arith <= '1';
			when ALU_FUNC_SLL	=>
				shift_left <= '1';
				shift_arith <= '0';
			when ALU_FUNC_SRL	=>
				shift_left <= '0';
				shift_arith <= '0';
			when others			=>
				shift_left <= '0';
				shift_arith <= '0';
		end case;
	end process;
	
	RESULTIFIER : process(FUNC, r_addsub, r_mul, r_and, r_or, r_xor, r_shift, X, Y)
	begin
		case FUNC is
			when ALU_FUNC_ADD	=>	result <= r_addsub;
			when ALU_FUNC_SUB	=>	result <= r_addsub;
			when ALU_FUNC_MUL	=>	result <= r_mul;
			when ALU_FUNC_AND	=>	result <= r_and;
			when ALU_FUNC_OR	=>	result <= r_or;
			when ALU_FUNC_XOR	=>	result <= r_xor;
			when ALU_FUNC_SRA	=>	result <= r_shift;
			when ALU_FUNC_SLL	=>	result <= r_shift;
			when ALU_FUNC_SRL	=>	result <= r_shift;
			when ALU_FUNC_A		=>	result <= X;
			when ALU_FUNC_B		=>	result <= Y;
			when others			=>	result <= ZERO64;
		end case;
	end process;
	
	OVERFLOWIFIER : process(FUNC, add_overflow)
	begin
		case FUNC is
			when ALU_FUNC_ADD	=>	OVERFLOW <= add_overflow;
			when ALU_FUNC_SUB	=>	OVERFLOW <= add_overflow;
			when others			=>	OVERFLOW <= '0';
		end case;
	end process;
	
	R <= result;
	
end Behavioral;

