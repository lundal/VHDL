library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONSTANTS.all;

entity fitness_core is
    port( 
			-- Bit signals
			 clk 					 		: in  STD_LOGIC;
          reset 				 		: in  STD_LOGIC;
          processor_enable  		: in  STD_LOGIC;
          
			 --Control signals
			 halt_inst 					: in  STD_LOGIC; 
			 
			 --Bus signals related to instruction cache
			 imem_address 		 		: out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
			 imem_data_in 		 		: in  STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
          
			 --Bus signals related to data memory
			 request_bus_data 		: out STD_LOGIC;
			 ack_mem_ctrl 	    		: in  STD_LOGIC;
			 dmem_data_in 		 		: in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          dmem_address 		 		: out STD_LOGIC_VECTOR(MEM_ADDR_WIDTH-1 downto 0);
          dmem_address_wr 	 		: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          dmem_data_out 	 		: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          dmem_write_enable 		: out STD_LOGIC;
			 
			 --Bus signals related to genetic storage
			 pmem_data_out 			: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			 pmem_data_in 				: in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			 pipeline_settings_out 	: out STD_LOGIC_VECTOR(SETTINGS_WIDTH-1 downto 0);
			 request_bus_rated 		: out STD_LOGIC_vector(GENE_OP_WIDTH-1 downto 0);
			 ack_gene_ctrl 	  		: in  STD_LOGIC;
		 	 request_bus_unrated  	: out STD_LOGIC;
			 
			 gen_pipeline_settings  : in STD_LOGIC_VECTOR(SETTINGS_WIDTH-1 downto 0)
			 
			 );

end fitness_core;

architecture Behavioral of fitness_core is

--SIGNAL DECLERATIONS --

--FETCH SIGNALS--

	-- Bus signals
	signal instruction_signal_fetch 		: std_logic_vector(INST_WIDTH-1 downto 0);
	signal pc_incremented_signal_fetch 	: std_logic_vector(INST_WIDTH-1 downto 0);
	signal pc_signal_fetch 					: std_logic_vector(INST_WIDTH-1 downto 0);
	signal pc_jump_addr_signal 			: std_logic_vector(INST_WIDTH-1 downto 0);

--DECODE SIGNALS-- 
 
	--CONTROL SIGNALS--
	-- Internally used
	signal imm_src_signal_decode : std_logic;
	signal reg_src_signal_decode : std_logic;
	signal store_src_signal_decode : std_logic;
 
	--Passing signals
	signal alu_src_signal_decode : std_logic;
	signal reg_write_signal_decode : std_logic;
	signal call_signal_decode : std_logic;
	signal jump_signal_decode : std_logic;
	signal alu_func_signal_decode : std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
	signal gene_op_signal_decode : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	signal mem_op_signal_decode : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	signal to_reg_signal_decode : std_logic_vector(TO_REG_OP_WIDTH-1 downto 0);
	signal cond_signal_decode : std_logic_vector(COND_WIDTH-1 downto 0);

	--BUS signals 

	--Internally used
	signal op_code_decode 	: std_logic_vector(OP_CODE_WIDTH-1 downto 0);
	signal func_decode 		: std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
	signal rs_signal_decode : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rt_signal_decode : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal imm_signal_decode : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rsa_signal_decode : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal rta_signal_decode : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal instruction_signal_decode : std_logic_vector(INST_WIDTH-1 downto 0);

	--Passing signals
	signal rda_signal_decode : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal pc_incremented_signal_decode : std_logic_vector(INST_WIDTH-1 downto 0);

--EXECUTE SIGNALS--

	--CONTROL SIGNALS 

	--Internally used signals 
	signal alu_src_signal_execute  : std_logic;
	signal alu_func_signal_execute : std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);

	--Passing signals 
	signal jump_signal_execute : std_logic;
	signal cond_signal_execute 	: std_logic_vector(COND_WIDTH-1 downto 0);
	signal reg_write_signal_execute : std_logic;
	signal call_signal_execute : std_logic;
	signal gene_op_signal_execute : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	signal mem_op_signal_execute : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	signal to_reg_signal_execute : std_logic_vector(TO_REG_OP_WIDTH-1 downto 0);
	signal pc_incremented_signal_execute : std_logic_vector(INST_WIDTH-1 downto 0);
	signal overflow_signal_execute : std_logic;

	--BUS signals
	signal rs_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rt_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rs_out_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rt_out_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal res_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rda_signal_execute : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal rsa_signal_execute : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal rta_signal_execute : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal imm_signal_execute  :std_logic_vector(DATA_WIDTH-1 downto 0);


--MEMORY signals--

	--Internally used
	signal gene_op_signal_mem : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	signal mem_op_signal_mem : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	signal cond_signal_mem 	: std_logic_vector(COND_WIDTH-1 downto 0);
	signal overflow_signal_mem : std_logic; 
	signal jump_signal_mem     : std_logic;
 
	-- Passing signals
	signal reg_write_signal_mem : std_logic;
	signal call_signal_mem : std_logic;
	signal to_reg_signal_mem :  std_logic_vector(TO_REG_OP_WIDTH-1 downto 0);

	--BUS signals
	signal gene_out_signal_mem : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal res_signal_mem : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal pc_incremented_signal_mem : std_logic_vector(INST_WIDTH-1 downto 0);
	signal rda_signal_mem : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal data_out_signal_mem : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal pc_out_signal_mem : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rs_signal_mem 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rt_signal_mem 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal gene_signal_mem 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal pc_jump_addr_signal_mem : std_logic_vector(INST_WIDTH-1 downto 0);



--WRITE-BACK SIGNALS--
 
	--CONTROL SIGNALS--
 
	--Internally used
	signal call_signal_wb : std_logic;
	signal to_reg_signal_wb : std_logic_vector(TO_REG_OP_WIDTH-1 downto 0);
 
	--Passing signals
	signal reg_write_signal_wb : std_logic;

	--BUS SIGNALS --
	signal WBD_signal_wb : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal WBA_signal_wb : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal pc_incremented_signal_wb : std_logic_vector(INST_WIDTH-1 downto 0);
	signal gene_signal_wb : std_logic_vector(DATA_WIDTH-1 downto 0); 
	signal res_signal_wb  : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal data_signal_wb  : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rda_signal_wb  : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
	signal pc_out_signal_wb : std_logic_vector(DATA_WIDTH-1 downto 0);

--GLOBAL SIGNALS--
	signal halt_mem_signal 			       : std_logic;
	signal halt_pipeline_signal 	 		 : std_logic; 
	signal multiplication_halt_signal 	 : std_logic; 
begin

--Halt if one of them are true
halt_pipeline_signal <= '0'; --halt_inst --or halt_mem_signal or multiplication_halt_signal; does not work yet

control_unit: entity work.control_unit
port map (

    -- in
    reset => reset, 
	 op_code =>	op_code_decode,
    FUNC => func_decode,

    -- out
    alu_source => alu_src_signal_decode,
    imm_source => imm_src_signal_decode,
    reg_source => reg_src_signal_decode,
    reg_write => reg_write_signal_decode,
    call => call_signal_decode,
    jump => jump_signal_decode,
    alu_func => alu_func_signal_decode,
    gene_op => gene_op_signal_decode,
    mem_op => mem_op_signal_decode,
    to_reg => to_reg_signal_decode,
	 store_source => store_src_signal_decode
);


PREPARE_OPCODE_AND_FUNC : process(instruction_signal_decode, processor_enable)
	begin 
		if processor_enable = '1' then
			op_code_decode <= instruction_signal_decode(27 downto 24);
			func_decode <=  instruction_signal_decode(3 downto 0);
		else 
			op_code_decode <= (others => '0');
			func_decode <= (others => '0');
		end if;
end process;



-- STAGE DIVIDERS--
if_id : entity work.IF_ID
port map (
    clk => clk,
    reset => reset,
    halt => halt_pipeline_signal,
    processor_enable => processor_enable, 
	 instruction_in => instruction_signal_fetch,
    pc_incremented_in => pc_incremented_signal_fetch,

    instruction_out => instruction_signal_decode,
    pc_incremented_out => pc_incremented_signal_decode
);

id_ex : entity work.id_ex
port map (

    clk => clk,
    reset => reset,
    halt => halt_pipeline_signal,

    -- PC in
    pc_incremented_in => pc_incremented_signal_decode,

    -- PC out
    pc_incremented_out => pc_incremented_signal_execute,

    -- CONTROL SIGNALS in
    alu_src_in => alu_src_signal_decode,
    reg_write_in => reg_write_signal_decode,
    jump_in => jump_signal_decode,
    alu_func_in => alu_func_signal_decode,
    cond_in => cond_signal_decode,
    gene_op_in => gene_op_signal_decode,
    mem_operation_in => mem_op_signal_decode,
    to_reg_operation_in => to_reg_signal_decode,
	 call_in => call_signal_decode,

    -- CONTROL SIGNALS out
    alu_src_out => alu_src_signal_execute,
    reg_write_out => reg_write_signal_execute,
    jump_out => jump_signal_execute,
    alu_func_out => alu_func_signal_execute,
    cond_out => cond_signal_execute,
    gene_op_out => gene_op_signal_execute,
    mem_operation_out => mem_op_signal_execute,
    to_reg_operation_out => to_reg_signal_execute,
	 call_out => call_signal_execute,

    --DATA in
    rs_in => rs_signal_decode,
    rt_in => rt_signal_decode,
    imm_in => imm_signal_decode,
    rsa_in => rsa_signal_decode,
    rta_in => rta_signal_decode,
    rda_in => rda_signal_decode,

    --DATA out
    rs_out => rs_signal_execute,
    rt_out => rt_signal_execute,
    imm_out => imm_signal_execute,
    rsa_out => rsa_signal_execute,
    rta_out => rta_signal_execute,
    rda_out => rda_signal_execute
);


ex_mem : entity work.ex_mem
port map (
    clk => clk,
    reset => reset,
    halt => halt_pipeline_signal,

    -- PC in
    pc_incremented_in => pc_incremented_signal_execute,

    -- PC out
    pc_incremented_out => pc_incremented_signal_mem,

    --Control signals
    gene_op_in => gene_op_signal_execute,
    cond_in => cond_signal_execute,
    jump_in => jump_signal_execute,
    mem_op_in => mem_op_signal_execute,
    to_reg_in => to_reg_signal_execute,
    call_in => call_signal_execute,
    overflow_in => overflow_signal_execute,
	 reg_write_in => reg_write_signal_execute, 

    --Control signals out 
    gene_op_out => gene_op_signal_mem,
    cond_out => cond_signal_mem,
    jump_out => jump_signal_mem,
    mem_op_out => mem_op_signal_mem,
    to_reg_out => to_reg_signal_mem,
    call_out => call_signal_mem,
    overflow_out => overflow_signal_mem,
	 reg_write_out => reg_write_signal_mem,

    --Data in 
    rs_in => rs_out_signal_execute,
    rt_in => rt_out_signal_execute,
    res_in => res_signal_execute,
    rda_in => rda_signal_execute,

    --Data out
    rs_out => rs_signal_mem,
    rt_out => rt_signal_mem,
    res_out => res_signal_mem,
    rda_out => rda_signal_mem
);

           
mem_wb : entity work.mem_wb
port map (
    clk => clk,
    reset => reset,
    halt => halt_pipeline_signal,

    -- PC in
    pc_incremented_in => pc_out_signal_mem,

    -- PC out
    pc_incremented_out => pc_out_signal_wb,

    --CONTROL in
    to_reg_op_in => to_reg_signal_mem,
    call_in => call_signal_mem,
	 reg_write_in => reg_write_signal_mem,

    --CONTROL out
    to_reg_op_out => to_reg_signal_wb,
    call_out => call_signal_wb,
	 reg_write_out => reg_write_signal_wb,

    --DATA in
    gene_in => gene_signal_mem,
    res_in => res_signal_mem,
    data_in => data_out_signal_mem,
    rda_in => rda_signal_mem,

    --Data out
    gene_out => gene_signal_wb,
    res_out => res_signal_wb,
    data_out => data_signal_wb,
    rda_out => rda_signal_wb
);


--STAGES-- 


fetch_stage : entity work.fetch_stage
port map ( clk => clk, 
           reset => reset,
           pc_update => processor_enable,
           pc_src  => jump_signal_mem, 
			  pc_jump_addr => pc_jump_addr_signal_mem, 
           pc_incremented 	=> pc_incremented_signal_fetch,
           pc_signal  => pc_signal_fetch);




FETCH_INSTRUCTION : process(processor_enable, pc_signal_fetch, imem_data_in) 
begin 
	if processor_enable = '1' then
		imem_address <= pc_signal_fetch;
		instruction_signal_fetch <= imem_data_in; 
	else 
		imem_address <= (others => '0');
		instruction_signal_fetch <= (others => '0');
	end if;
end process;


decode_stage : entity work.decode_stage
port map (
    clk => clk,
    reset => reset,
    processor_enable => processor_enable,

    --Control signals
    reg_write => reg_write_signal_wb,
    imm_src => imm_src_signal_decode,
    reg_src => reg_src_signal_decode,
    reg_store => store_src_signal_decode,

    --Input signals
    instruction => instruction_signal_decode,
    write_data => WBD_signal_wb,      
    write_register => WBA_signal_wb,

    --Output signals
    rs => rs_signal_decode,
    rt => rt_signal_decode,
    immediate => imm_signal_decode,
    rsa => rsa_signal_decode,
    rta => rta_signal_decode,
    rda => rda_signal_decode,
    condition_out => cond_signal_decode
);


execution_stage : entity work.execution_stage
port map (
    clk => clk,
    reset => reset,

    -- Control signals
    alu_src => alu_src_signal_execute,
    alu_func => alu_func_signal_execute,

    --Control signals from other stages
    stage4_reg_write => reg_write_signal_mem,
    stage5_reg_write => reg_write_signal_wb,

    --Signals in 
    rs => rs_signal_execute,
    rt => rt_signal_execute,
    immediate => imm_signal_execute,
    rsa => rsa_signal_execute,
    rta => rta_signal_execute,
    rda => rda_signal_execute,

    -- From other stages
    stage4_alu_result => res_signal_mem,
    stage5_write_data => WBD_signal_wb,
    stage4_reg_rd => rda_signal_mem,
    stage5_reg_rd => rda_signal_wb,
    
	 --Control signals out
    overflow => overflow_signal_execute,
	 multiplication_halt => multiplication_halt_signal, 
    
	 -- Signals out 
    alu_result => res_signal_execute,
	 rs_out => rs_out_signal_execute, 
	 rt_out => rt_out_signal_execute
);


memory_stage : entity work.memory_stage
port map (
	--Bit signals
	clk => clk,
	reset => reset,
	processor_enable => processor_enable, 
	
	--Control signals in
	overflow_in => overflow_signal_mem,
	jump_in => jump_signal_mem, 
	gene_op_in => gene_op_signal_mem,
	cond_op_in => cond_signal_mem, 
	mem_op_in => mem_op_signal_mem, 
	ack_mem_ctrl => ack_mem_ctrl, 
	ack_gene_ctrl => ack_gene_ctrl, 
	gen_pipeline_settings => gen_pipeline_settings, 

	--Control signals out
	halt => halt_mem_signal,
	request_bus_rated => request_bus_rated,
	request_bus_unrated => request_bus_unrated, 
	request_bus_data  => request_bus_data, 
	
	--Bus signals in 
	fitness_in => rs_signal_mem, 
	gene_in => rt_signal_mem,
	res_in => res_signal_mem, 
	pc_incremented => pc_incremented_signal_mem, 
	data_mem_bus_in => dmem_data_in, 
	data_pool_bus_in	=> pmem_data_in, 
	
	--Bus signals out
	gene_out => gene_signal_mem, 
	data_out => data_out_signal_mem,
	pc_out => pc_out_signal_mem, 
	addr_mem_bus => dmem_address, 
	data_mem_bus_out	=>dmem_data_out, 
	data_pool_bus_out =>pmem_data_out,
	pc_jump_addr => pc_jump_addr_signal_mem);
			 

write_back_stage : entity work.write_back_stage
port map( 
			--Control signals in
			to_reg => to_reg_signal_wb, 
			call => call_signal_wb, 
			
			--Bus signals in
			pc_incremented_in => pc_out_signal_wb,
			gene_in =>gene_signal_wb, 
			res_in =>res_signal_wb, 
			data_in => data_signal_wb, 
			rda_in => rda_signal_wb,
			
			--Bus signals out
			WBA => WBA_signal_wb, 
			WBD => WBD_signal_wb);
	

end behavioral;
