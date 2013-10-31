library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

entity memory_stage is
	Port(
	
	--Control signals in
	overflow_in 	: in std_logic;
	jump_in 			: in std_logic;
	gene_op_in 		: in std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	cond_op_in 		: in std_logic_vector(COND_WIDTH-1 downto 0); 
	mem_op_in 		: in std_logic_vector(MEM_OP_WIDTH-1 downto 0);

	--Control signals out
	halt 				: in std_logic;
	
	--Bus signals in 
	fitness_in 		: in std_logic_vector(DATA_WIDTH-1 downto 0);
	gene_in 			: in std_logic_vector(DATA_WIDTH-1 downto 0);
	res_in 			: in std_logic_vector(DATA_WIDTH-1 downto 0);
	pc_incremeted 	: in std_logic_vector(INST_WDITH-1 downto 0);
	
	--Bus signals out
	gene_out 		: out std_logic_vector(DATA_WIDTH-1 downto 0);
	data_out 		: out std_logic_vector(DATA_WIDTh-1 downto 0);
	pc_out 			: out std_logic_vector(INST_WIDTH-1 downto 0));
end memory_stage;

architecture Behavioral of memory_stage is

begin


end Behavioral;

