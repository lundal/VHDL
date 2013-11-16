library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity conditional_unit is
	generic(
		N	:	integer := 64
	);
	port(
		COND		:	in	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0);
		ALU_RES		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		ALU_OVF		:	in	STD_LOGIC;
		SKIP		:	out	STD_LOGIC
	);
end conditional_unit;

architecture Behavioral of conditional_unit is
	-- Test signals
	signal pos	:	STD_LOGIC;
	signal zero	:	STD_LOGIC;
	signal neg	:	STD_LOGIC;
	signal ovf	:	STD_LOGIC;
begin
	ALU_RES_TESTER : entity work.ZeroTester
	generic map (N => N)
	port map(
		I		=> ALU_RES,
		Pos		=> pos,
		Zero	=> zero,
		Neg		=> neg
	);
	
	ovf <= ALU_OVF;
	
	-- Set execution signal
	with COND select
	SKIP <=	'1'			when COND_NEVER,
			not zero 	when COND_EQUAL,
			zero    	when COND_NEQUAL,
			neg     	when COND_GREATEREQ,
			neg or zero when COND_GREATER,
			pos     	when COND_LESSEQ,
			pos or zero	when COND_LESS,
			not ovf		when COND_OVERFLOW,
			ovf	    	when COND_NOVERFLOW,
			'0'			when COND_ALWAYS,
			'1'			when others;
	
end Behavioral;

