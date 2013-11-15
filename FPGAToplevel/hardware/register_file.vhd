
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity register_file is
	port(
			CLK 			:	in	STD_LOGIC;					
			RW				:	in	STD_LOGIC;				
			RS_ADDR 		:	in	STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0); 
			RT_ADDR 		:	in	STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0); 
			RD_ADDR 		:	in	STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
			WRITE_DATA	    :	in	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0); 
			RS				:	out	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			RT				:	out	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);

end register_file;

architecture Behavioral of register_file is

	constant NUM_REG : integer := 2 ** REG_ADDR_WIDTH;
	type REGS_T is array (NUM_REG-1 downto 0) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	signal REGS : REGS_T := (others => (others =>'0'));

begin

	REGISTERS: process(CLK)
	begin
		if rising_edge(CLK) then
			if  RW='1' then
				REGS(to_integer(unsigned(RD_ADDR)))<=WRITE_DATA;
			end if;
		end if;
	end process  REGISTERS;

	RS <= (others=>'0') when RS_ADDR="00000"
         else REGS(to_integer(unsigned(RS_ADDR)));
			
	RT <= (others=>'0') when RT_ADDR="00000"
         else REGS(to_integer(unsigned(RT_ADDR)));

end Behavioral;

