--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

library WORK;

package CONSTANTS is
	
	constant ALU_FUNC_WIDTH	        :	integer	:=	4;
	constant COND_WIDTH		        :	integer	:=	4;
	constant OP_CODE_WIDTH	        :	integer :=	4;
	constant REG_WIDTH		        :	integer :=	64;
	constant REG_ADDR_WIDTH	        :	integer	:=	5;
	
	constant ADDR_WIDTH				:	integer := 19;
    constant INST_WIDTH             :   integer := 32;
    constant DATA_WIDTH             :   integer := 64;
	
    constant STATE_WIDTH            :   integer := 2;
    constant STATE_PROC             :   STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0) := "00";
    constant STATE_INST_HI          :   STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0) := "01";
    constant STATE_INST_LO          :   STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0) := "10";
    constant STATE_DATA             :   STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0) := "11";

    -- TODO - Change these to their correct values
    constant GENE_OP_WIDTH   : integer := 2;
    constant MEM_OP_WIDTH    : integer := 2;
    constant TO_REG_OP_WIDTH : integer := 2;
	constant MEM_ADDR_WIDTH  : integer := 19;
	constant SETTINGS_WIDTH  : integer := 3;
    
   --ACTIONS
	constant LOAD_DATA   : STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0) := "01";
	constant STORE_DATA 	: STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0) := "10";
	constant LOAD_GENE 	: STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0) := "01";
	constant STORE_GENE  : STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0) := "10";
    
    -- Genetic
    constant GENE_OP_NONE     : STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0) := "00";
    constant GENE_OP_STORE    : STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0) := "01";
    constant GENE_OP_LOAD     : STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0) := "10";
    constant GENE_OP_SETTINGS : STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0) := "11";
	
	--OPCODES 
	constant OP_CODE_RRR	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "1000";
	constant OP_CODE_RRI	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "1100";
	constant OP_CODE_LW		:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "0000";
	constant OP_CODE_SW		:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "0001";
	constant OP_CODE_LDI	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "0100";
	constant OP_CODE_JMP	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "0010";
	constant OP_CODE_CALL	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "0011";
	constant OP_CODE_STI	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "0101";
	constant OP_CODE_LDG	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "1001";
	constant OP_CODE_SETG	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "1010";
	constant OP_CODE_STG	:	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0) := "1011";
	
	-- ALU Functions
	constant ALU_FUNC_ADD	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0000";
	constant ALU_FUNC_SUB	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0001";
	constant ALU_FUNC_MUL	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0010";
	constant ALU_FUNC_SRA	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0011";
	constant ALU_FUNC_OR	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0100";
	constant ALU_FUNC_AND	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0101";
	constant ALU_FUNC_XOR	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0110";
	constant ALU_FUNC_SLL	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"0111";
	constant ALU_FUNC_SRL	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"1000";
	constant ALU_FUNC_A		:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"1001";
	constant ALU_FUNC_B		:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"1010";
	constant ALU_FUNC_NA	:	STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0)	:=	"1111";
	
	-- Condition codes
	constant COND_NEVER		:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0000";
	constant COND_EQUAL		:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0001";
	constant COND_NEQUAL	:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0010";
	constant COND_GREATEREQ	:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0011";
	constant COND_GREATER	:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0100";
	constant COND_LESSEQ	:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0101";
	constant COND_LESS		:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0110";
	constant COND_OVERFLOW	:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "0111";
	constant COND_NOVERFLOW	:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "1000";
	constant COND_ALWAYS	:	STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0) := "1111";
	
	type ALU_FLAGS is
	record
		Positive	:	STD_LOGIC;
		Zero		:	STD_LOGIC;
		Negative	:	STD_LOGIC;
		Overflow	:	STD_LOGIC;
	end record;
	
	constant ZERO8	: STD_LOGIC_VECTOR(7 downto 0) :=  (7 downto 0 => '0');
	constant ZERO16	: STD_LOGIC_VECTOR(15 downto 0) :=  (15 downto 0 => '0');
	constant ZERO32	: STD_LOGIC_VECTOR(31 downto 0) :=  (31 downto 0 => '0');
	constant ZERO64	: STD_LOGIC_VECTOR(63 downto 0) :=  (63 downto 0 => '0');
	
	constant ONE8	: STD_LOGIC_VECTOR(7 downto 0) :=  (7 downto 0 => '1');
	constant ONE16	: STD_LOGIC_VECTOR(15 downto 0) :=  (15 downto 0 => '1');
	constant ONE32	: STD_LOGIC_VECTOR(31 downto 0) :=  (31 downto 0 => '1');
	constant ONE64	: STD_LOGIC_VECTOR(63 downto 0) :=  (63 downto 0 => '1');
	
end CONSTANTS;
