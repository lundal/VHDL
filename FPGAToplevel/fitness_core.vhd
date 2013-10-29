library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fitness_core is
    generic (
    MEM_ADDR_BUS : integer := 32;
    MEM_DATA_BUS : integer := 32;
    N : integer := 32
    );
    
    port( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
          processor_enable : in  STD_LOGIC;
          imem_address : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          imem_data_in : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_data_in : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_address : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_address_wr : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_data_out : out STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_write_enable : out STD_LOGIC);

end fitness_core;

architecture Behavioral of fitness_core is

--SIGNAL DECLERATIONS --

signal placeholder : std_logic_vector(63 downto 0);

-- Bus signals
signal instruction_fetch : std_logic_vector(INST_WIDTH-1 downto 0);
signal pc_incremented_fetch : std_logic_vector(INST_WIDTH-1 downto 0);

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
 signal imm_src_signal_decode : std_logic;
 signal alu_func_signal_decode : std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
 signal gene_op_signal_decode : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
 signal mem_op_signal_decode : std_logic_vector(GENE _OP_WIDTH-1 downto 0);
 signal to_reg_signal_decode : std_logic_vector(TO_REG_OP_WIDTH-1 downto);

--BUS signals 

--Internally used
signal rs_signal_decode : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rt_signal_decode : std_logic_vector(DATA_WIDTH-1 downto 0);
signal imm_signal_decode : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rsa_signal_decode : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal rta_signal_decode : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);

--Passing signals
signal rda_signal_decode : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal pc_incremented_signal_decode : std_logic_vector(INST_WIDTH-1 downto 0);

--EXECUTE SIGNALS--

 --Internally used 
 signal alu_src_signal_execute : std_logic;
 signal alu_func_signal_execute : std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
 
 --Passing signals
 signal reg_write_signal_execute : std_logic;
 signal call_signal_execute : std_logic;
 signal gene_op_signal_execute : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
 signal mem_op_signal_execute : std_logic_vector(GENE _OP_WIDTH-1 downto 0);
 signal to_reg_signal_execute : std_logic_vector(TO_REG_OP_WIDTH-1 downto);
 signal pc_incremented_signal_execute : std_logic_vector(INST_WIDTH-1 downto 0);
 signal overflow_signal_execute : std_logic;

--BUS signals
signal rs_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rt_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
signal res_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rda_signal_execute : std_logic_vector(DATA_WIDTH-1 downto 0);


--MEMORY signals--

 --Internally used
 signal gene_op_signal_mem : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
 signal mem_op_signal_mem : std_logic_vector(GENE _OP_WIDTH-1 downto 0);
 signal overflow_signal_mem : std_logic; 
 
-- Passing signals
 signal reg_write_signal_mem : std_logic;
 signal call_signal_mem : std_logic;
 signal to_reg_signal_mem :  std_logic_vector(TO_REG_OP_WIDTH-1 downto);

--BUS signals
signal gene_out_signal_mem : std_logic_vector(DATA_WIDTH-1 downto 0);
signal res_signal_mem : std_logic_vector(DATA_WIDTH-1 downto 0);
signal pc_incremented_signal_mem : std_logic_vector(INST_WIDTH-1 downto 0);
signal rda_signal_mem : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal data_out_signal_mem : std_logic_vector(DATA_WIDTH-1 downto 0);

--WRITE-BACK SIGNALS--
 
 --CONTROL SIGNALS--
 
 --Internally used
 signal call_signal_wb : std_logic;
 signal to_reg_signal_wb : std_logic_vector(TO_REG_OP_WIDTH-1 downto);
 
 --Passing signals
 signal reg_write_signal_wb : std_logic;

 --BUS SIGNALS --
signal WBB_signal_wb : std_logic_vector(DATA_WIDTH-1 downto 0);
signal WBA_signal_wb : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);

begin


control_unit: entity work.control_unit
port map (

    -- in
    op_code <= op_code,
    func <= func,

    -- out
    alu_source <= alu_src_signal_decode,
    imm_source <= imm_src_signal_decode,
    reg_source <= reg_src_signal_decode,
    reg_write <= reg_write_signal_decode,
    call <= call_signal_decode,
    jump <= placeholder,
    alu_func <= alu_func_signal_decode,
    gene_op <= gene_op_signal_decode,
    mem_op <= mem_op_signal_decode,
    to_reg <= to_reg_signal_decode
);


-- stage dividers


if_id : entity work.IF_ID
port map (
    clk <= clk,
    reset <= reset,
    halt <= halt,
    instruction_in <= instruction_in_signal_fetch,
    pc_incremented_in <= pc_incremented_in_signal_fetch,

    instruction_out <= instruction_out_signal_fetch,
    pc_incremented_out <= pc_incremented_out_signal_fetch
);

id_ex : entity work.id_ex
port map (

    clk <= clk,
    reset <= reset,
    halt <= halt,

    -- PC in
    pc_incremented_in <= pc_incremented_out_signal_fetch,

    -- PC out
    pc_incremented_out <= pc_incremented_out_signal_decode,

    -- CONTROL SIGNALS in
    alu_src_in <= alu_src_signal_decode,
    reg_write_in <= reg_write_signal_decode,
    jump_in <= placeholder,
    alu_func_in <= alu_func_signal_decode,
    cond_in <= placeholder,
    gene_op_in <= gene_op_signal_decode,
    mem_operation_in <= mem_op_signal_decode,
    to_reg_operation_in <= to_reg_signal_decode,

    -- CONTROL SIGNALS out
    alu_src_out <= alu_src_signal_execute,
    reg_write_out <= reg_write_signal_execute,
    jump_out <= placeholder,
    alu_func_out <= alu_func_signal_execute,
    cond_out <= placeholder,
    gene_op_out <= gene_op_signal_execute,
    mem_operation_out <= mem_op_signal_execute,
    to_reg_operation_out <= to_reg_signal_execute,

    --DATA in
    rs_in <= rs_signal_decode,
    rt_in <= rt_signal_decode,
    imm_in <= imm_signal_decode,
    rsa_in <= rsa_signal_decode,
    rta_in <= rta_signal_decode,
    rda_in <= rda_signal_decode,

    --DATA out
    rs_out <= rs_signal_execute,
    rt_out <= rt_signal_execute,
    imm_out <= imm_signal_execute,
    rsa_out <= rsa_signal_execute,
    rta_out <= rta_signal_execute,
    rda_out <= rda_signal_execute
);


ex_mem : entity work.ex_mem
port map (
    clk <= clk,
    reset <= reset,
    enable <= enable,

    -- PC in
    pc_incremented_in <= pc_incremented_signal_execute,

    -- PC out
    pc_incremented_out <= pc_incremented_signal_mem,

    --Control signals
    gene_op_in <= gene_op_signal_execute,
    cond_in <= placeholder,
    jump_in <= placeholder,
    mem_op_in <= mem_op_signal_execute,
    to_reg_in <= to_reg_signal_execute,
    call_in <= placeholder,
    overflow_in <= placeholder,

    --Control signals out 
    gene_op_out <= gene_op_signal_mem,
    cond_out <= placeholder,
    jump_out <= placeholder,
    mem_op_out <= mem_op_signal_mem,
    to_reg_out <= to_reg_signal_mem,
    call_out <= placeholder,
    overflow_out <= placeholder,

    --Data in 
    rs_in <= rs_signal_execute,
    rt_in <= rt_signal_execute,
    res_in <= res_signal_execute,
    rda_in <= rda_signal_execute,

    --Data out
    rs_out <= rs_signal_mem,
    rt_out <= rt_signal_mem,
    res_out <= res_signal_mem,
    rda_out <= rda_signal_mem
);

           
mem_wb : entity work.mem_wb
port map (
    clk <= clk,
    reset <= reset,
    halt <= halt,

    -- PC in
    pc_incremented_in <= placeholder,

    -- PC out
    pc_incremented_out <= placeholder,

    --CONTROL in
    to_reg_op_in <= to_reg_signal_mem,
    call_in <= call_signal_mem,

    --CONTROL out
    to_reg_op_out <= to_reg_signal_wb,
    call_out <= call_signal_wb,

    --DATA in
    gene_in <= gene_op_signal_mem,
    res_in <= res_signal_mem,
    data_in <= data_out_signal_mem,
    rda_in <= rda_signal_mem,

    --Data out
    gene_out <= gene_op_signal_wb,
    res_out <= res_signal_wb,
    data_out <= data_signal_wb,
    rda_out <= rda_signal_wb
);


-- stages


fetch_stage : entity work.fetch_stage
port map (   
    clk <= clk,
    reset <= reset,
    pc_update <= placeholder,
    pc_src <= placeholder,
    pc_input <= placeholder,

    pc_incremented <= pc_incremented_signal_decode,
    pc_signal <= placeholder
);


decode_stage : entity work.decode_stage
port map (
    clk <= clk,
    reset <= reset,
    processor_enable <= placeholder,

    --Control signals
    reg_write <= reg_write_signal_decode,
    imm_src <= imm_src_signal_decode,
    reg_src <= reg_src_signal_decode,
    reg_store <= placeholder,

    --Input signals
    instruction <= instruction_out_signal_fetch,
    write_data <= placeholder,
    write_register <= placeholder,

    --Output signals
    rs <= rs_signal_decode,
    rt <= rt_signal_decode,
    immediate <= imm_signal_decode,
    rsa <= rsa_signal_decode,
    rta <= rta_signal_decode,
    rda <= rda_signal_decode,
    condition_out <= placeholder
);


execution_stage : entity work.execution_stage
port map (
    clk <= clk,
    reset <= reset,

    -- Control signals
    alu_src <= alu_src_signal_decode,
    alu_func <= alu_src_signal_decode,

    --Control signals from other stages
    stage4_reg_write <= placeholder,
    stage5_reg_write <= placeholder,

    --Signals in 
    rs <= rs_signal_decode,
    rt <= rt_signal_decode,
    immediate <= imm_signal_decode,
    rsa <= rsa_signal_decode,
    rta <= rsa_signal_decode,
    rda <= rda_signal_decode,

    -- From other stages
    stage4_alu_result <= placeholder,
    stage5_write_data <= placeholder,
    stage4_reg_rd <= placeholder,
    stage5_reg_rd <= placeholder,
    --Control signals out
    overflow <= placeholder,

    -- Signals out 
    write_register_addr <= placeholder,
    alu_result <= res_signal_execute
);


-- TODO: incomplete
memory_stage : entity work.memory_stage;

-- TODO: incomplete
write_back_stage : entity work.write_back_stage;

end behavioral;
