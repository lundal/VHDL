
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fitness_core is
    generic (
    MEM_ADDR_BUS : integer := 32;
    MEM_DATA_BUS : integer := 32;
    N            : integer := 32
    );
    
    port( clk                 : in  STD_LOGIC;
          reset               : in  STD_LOGIC;
          processor_enable    : in  STD_LOGIC;
          imem_address        : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          imem_data_in        : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_data_in        : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_address        : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_address_wr     : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_data_out       : out STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_write_enable   : out STD_LOGIC);

end fitness_core;

architecture Behavioral of fitness_core is
--SIGNAL DECLERATIONS --

--FETCH Signals

-- Bus signals
signal instruction_fetch              : std_logic_vector(INST_WIDTH-1 downto 0);
signal pc_incremented_fetch           : std_logic_vector(INST_WIDTH-1 downto 0);

--DECODE SIGNALS-- 
 
 --CONTROL SIGNALS--
 -- Internally used
 signal imm_src_signal_decode         : std_logic;
 signal reg_src_signal_decode         : std_logic;
 signal store_src_signal_decode   	  : std_logic;
 
 --Passing signals
 signal alu_src_signal_decode         : std_logic;
 signal reg_write_signal_decode       : std_logic;
 signal call_signal_decode            : std_logic;
 signal imm_src_signal_decode         : std_logic;
 signal alu_func_signal_decode        : std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
 signal gene_op_signal_decode         : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
 signal mem_op_signal_decode          : std_logic_vector(GENE _OP_WIDTH-1 downto 0);
 signal to_reg_signal_decode     	  : std_logic_vector(TO_REG_OP_WIDTH-1 downto);

--BUS signals 

--Internally used
signal rs_signal_decode 				  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rt_signal_decode 				  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal imm_signal_decode              : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rsa_signal_decode              : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal rta_signal_decode              : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);

--Passing signals
signal rda_signal_decode              : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal pc_incremented_signal_decode   : std_logic_vector(INST_WIDTH-1 downto 0);

--EXECUTE SIGNALS--

 --Internally used 
 signal alu_src_signal_execute        : std_logic;
 signal alu_func_signal_execute       : std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
 
 --Passing signals
 signal reg_write_signal_execute      : std_logic;
 signal call_signal_execute           : std_logic;
 signal gene_op_signal_execute        : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
 signal mem_op_signal_execute         : std_logic_vector(GENE _OP_WIDTH-1 downto 0);
 signal to_reg_signal_execute         : std_logic_vector(TO_REG_OP_WIDTH-1 downto);
 signal pc_incremented_signal_execute : std_logic_vector(INST_WIDTH-1 downto 0);
 signal overflow_signal_execute       : std_logic;

--BUS signals
signal rs_signal_execute              : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rt_signal_execute              : std_logic_vector(DATA_WIDTH-1 downto 0);
signal res_signal_execute             : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rda_signal_execute             : std_logic_vector(DATA_WIDTH-1 downto 0);


 
--MEMORY signals--

 --Internally used
 signal gene_op_signal_mem     		  : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
 signal mem_op_signal_mem      		  : std_logic_vector(GENE _OP_WIDTH-1 downto 0);
 signal overflow_signal_mem           : std_logic; 
 
-- Passing signals
 signal reg_write_signal_mem   		  : std_logic;
 signal call_signal_mem        		  : std_logic;
 signal to_reg_signal_mem      		  :  std_logic_vector(TO_REG_OP_WIDTH-1 downto);

--BUS signals
signal gene_out_signal_mem 			  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal res_signal_mem 			        : std_logic_vector(DATA_WIDTH-1 downto 0);
signal pc_incremented_signal_mem      : std_logic_vector(INST_WIDTH-1 downto 0);
signal rda_signal_mem 			        : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal data_out_signal_mem				  : std_logic_vector(DATA_WIDTH-1 downto 0);

--WRITE-BACK SIGNALS--
 
 --CONTROL SIGNALS--
 
 --Internally used
 signal call_signal_wb                 : std_logic;
 signal to_reg_signal_wb               : std_logic_vector(TO_REG_OP_WIDTH-1 downto);
 
 --Passing signals
 signal reg_write_signal_wb   			: std_logic;

 --BUS SIGNALS --
signal WBB_signal_wb   				      : std_logic_vector(DATA_WIDTH-1 downto 0);
signal WBA_signal_wb						   : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);

begin


end Behavioral;

