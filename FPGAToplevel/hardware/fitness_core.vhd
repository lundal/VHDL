library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use work.CONSTANTS.all;

entity fitness_core is
    generic (
        processor_id : natural
    );
    port( 
        -- Control signals
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        processor_enable : in  STD_LOGIC;
         
        -- Instruction memory
        imem_halt : in STD_LOGIC;
        imem_addr : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        imem_data_in : in STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        
        -- Data memory
        dmem_request_0 : out STD_LOGIC; 
        dmem_request_1 : out STD_LOGIC; 
        dmem_ack : in STD_LOGIC; 
        dmem_addr : out STD_LOGIC_VECTOR(ADDR_WIDTH-2-1 downto 0);
        dmem_data_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        dmem_data_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        -- Genetic
        genetic_request_0 : out STD_LOGIC; 
        genetic_request_1 : out STD_LOGIC;
        genetic_ack : in STD_LOGIC; 
        genetic_data_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        genetic_data_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
    );
end fitness_core;

architecture Behavioral of fitness_core is
    
    --FETCH SIGNALS--
    
    signal fetch_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal fetch_pc_in : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal fetch_pc_inc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal fetch_pc_prev : std_logic_vector(ADDR_WIDTH-1 downto 0);
    
    signal fetch_to_decode_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal fetch_to_decode_inst : std_logic_vector(INST_WIDTH-1 downto 0);

    --DECODE SIGNALS-- 
     
    signal decode_from_fetch_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal decode_from_fetch_inst : std_logic_vector(INST_WIDTH-1 downto 0);
     
    signal decode_rsa : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal decode_rta : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal decode_imm : std_logic_vector(IMMEDIATE_WIDTH-1 downto 0);
    signal decode_target : std_logic_vector(TARGET_WIDTH-1 downto 0);
     
    signal decode_to_execute_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal decode_to_execute_rs : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal decode_to_execute_rt : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal decode_to_execute_imm : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal decode_to_execute_rsa : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal decode_to_execute_rta : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal decode_to_execute_rda : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
     
    -- Decode Control
    signal decode_reg_src : STD_LOGIC;
    signal decode_imm_src : STD_LOGIC;
    
    -- Execute Control
    signal decode_alu_src : STD_LOGIC;
    signal decode_alu_func : STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
    signal decode_cond : STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0);
    
    -- Mem Control
    signal decode_jump : STD_LOGIC;
    signal decode_gene_op : GENE_OP_TYPE;
    signal decode_mem_op : MEM_OP_TYPE;
    
    -- WB Control
    signal decode_to_reg : STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
    signal decode_call : STD_LOGIC;
    signal decode_reg_write : STD_LOGIC;
    
    -- EXECUTE SIGNALS --
    
    signal execute_from_decode_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal execute_from_decode_rs : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_from_decode_rt : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_from_decode_imm : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_from_decode_rsa : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal execute_from_decode_rta : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal execute_from_decode_rda : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    
    signal execute_rs_forwarded : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_rt_forwarded : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_alu_a_in : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_alu_b_in : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    signal execute_to_memory_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal execute_to_memory_rs : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_to_memory_rt : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_to_memory_res : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal execute_to_memory_rda : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal execute_to_memory_overflow : std_logic;
    
    -- Execute Control
    signal execute_alu_src : STD_LOGIC;
    signal execute_alu_func : STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
    signal execute_cond : STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0);
    
    -- Mem Control
    signal execute_jump : STD_LOGIC;
    signal execute_gene_op : GENE_OP_TYPE;
    signal execute_mem_op : MEM_OP_TYPE;
    
    -- WB Control
    signal execute_to_reg : STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
    signal execute_call : STD_LOGIC;
    signal execute_reg_write : STD_LOGIC;
    
    -- MEMORY SIGNALS --
    
    signal memory_from_execute_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal memory_from_execute_rs : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory_from_execute_rt : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory_from_execute_res : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory_from_execute_rda : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal memory_from_execute_overflow : std_logic;
    
    signal memory_condition_reset : std_logic;
    
    signal memory_to_writeback_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal memory_to_writeback_res : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory_to_writeback_data : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory_to_writeback_gene : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory_to_writeback_rda : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    
    -- Mem Control
    signal memory_jump : STD_LOGIC;
    signal memory_gene_op : GENE_OP_TYPE;
    signal memory_mem_op : MEM_OP_TYPE;
    
    -- WB Control
    signal memory_to_reg : STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
    signal memory_call : STD_LOGIC;
    signal memory_reg_write : STD_LOGIC;
    
    -- WRITEBACK SIGNALS --
    
    signal writeback_from_memory_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal writeback_from_memory_res : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal writeback_from_memory_data : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal writeback_from_memory_gene : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal writeback_from_memory_rda : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    
    signal writeback_wb : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal writeback_wba : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    
    -- WB Control
    signal writeback_to_reg : STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
    signal writeback_call : STD_LOGIC;
    signal writeback_reg_write : STD_LOGIC;
    
    -- RESET --
    signal reset_pc : STD_LOGIC;
    signal reset_if_id : STD_LOGIC;
    signal reset_id_ex : STD_LOGIC;
    signal reset_ex_mem : STD_LOGIC;
    signal reset_mem_wb : STD_LOGIC;
    
    -- DISABLE --
    signal disable_pc : STD_LOGIC;
    signal disable_if_id : STD_LOGIC;
    signal disable_id_ex : STD_LOGIC;
    signal disable_ex_mem : STD_LOGIC;
    signal disable_mem_wb : STD_LOGIC;
    
begin
    
    REG_IF_ID : entity work.IF_ID
    port map ( 
        -- Control signals
        clk => clk,
        reset => reset_if_id,
        disable => disable_if_id,

        -- Ins
        pc_in => fetch_to_decode_pc,
        instruction_in => fetch_to_decode_inst,

        -- Outs
        pc_out => decode_from_fetch_pc,
        instruction_out => decode_from_fetch_inst
    );
    
    REG_ID_EX : entity work.ID_EX
    port map ( 
        -- Control signals
        clk => clk,
        reset => reset_id_ex,
        disable => disable_id_ex,
        
        -- Ins
        pc_in => decode_to_execute_pc,
        rs_in => decode_to_execute_rs,
        rt_in => decode_to_execute_rt,
        imm_in => decode_to_execute_imm,
        rsa_in => decode_to_execute_rsa,
        rta_in => decode_to_execute_rta,
        rda_in => decode_to_execute_rda,
        
        -- Outs
        pc_out => execute_from_decode_pc,
        rs_out => execute_from_decode_rs,
        rt_out => execute_from_decode_rt,
        imm_out => execute_from_decode_imm,
        rsa_out => execute_from_decode_rsa,
        rta_out => execute_from_decode_rta,
        rda_out => execute_from_decode_rda,
        
        -- Execute Control Ins
        alu_src_in => decode_alu_src,
        alu_func_in => decode_alu_func,
        cond_in => decode_cond,
        
        -- Execute Control Outs
        alu_src_out => execute_alu_src,
        alu_func_out => execute_alu_func,
        cond_out => execute_cond,
        
        -- Mem Control Ins
        jump_in => decode_jump,
        gene_op_in => decode_gene_op,
        mem_op_in => decode_mem_op,
        
        -- Mem Control Outs
        jump_out => execute_jump,
        gene_op_out => execute_gene_op,
        mem_op_out => execute_mem_op,
        
        -- WB Control Ins
        to_reg_in => decode_to_reg,
        call_in => decode_call,
        reg_write_in => decode_reg_write,
        
        -- WB Control Outs
        to_reg_out => execute_to_reg,
        call_out => execute_call,
        reg_write_out => execute_reg_write
    );
    
    REG_EX_MEM : entity work.EX_MEM
    port map ( 
        -- Control signals
        clk => clk,
        reset => reset_ex_mem,
        disable => disable_ex_mem,
        
        -- Ins
        pc_in => execute_to_memory_pc,
        rs_in => execute_to_memory_rs,
        rt_in => execute_to_memory_rt,
        rda_in => execute_to_memory_rda,
        res_in => execute_to_memory_res,
        overflow_in => execute_to_memory_overflow,
        
        -- Outs
        pc_out => memory_from_execute_pc,
        rs_out => memory_from_execute_rs,
        rt_out => memory_from_execute_rt,
        rda_out => memory_from_execute_rda,
        res_out => memory_from_execute_res,
        overflow_out => memory_from_execute_overflow,
        
        -- Mem Control Ins
        jump_in => execute_jump,
        gene_op_in => execute_gene_op,
        mem_op_in => execute_mem_op,
        
        -- Mem Control Outs
        jump_out => memory_jump,
        gene_op_out => memory_gene_op,
        mem_op_out => memory_mem_op,
        
        -- WB Control Ins
        to_reg_in => execute_to_reg,
        call_in => execute_call,
        reg_write_in => execute_reg_write,
        
        -- WB Control Outs
        to_reg_out => memory_to_reg,
        call_out => memory_call,
        reg_write_out => memory_reg_write
    );
    
    REG_MEM_WB : entity work.MEM_WB
    port map ( 
        -- Control signals
        clk => clk,
        reset => reset_mem_wb,
        disable => disable_mem_wb,
        
        -- Ins
        pc_in => memory_to_writeback_pc,
        data_in => memory_to_writeback_data,
        gene_in => memory_to_writeback_gene,
        rda_in => memory_to_writeback_rda,
        res_in => memory_to_writeback_res,
        
        -- Outs
        pc_out => writeback_from_memory_pc,
        data_out => writeback_from_memory_data,
        gene_out => writeback_from_memory_gene,
        rda_out => writeback_from_memory_rda,
        res_out => writeback_from_memory_res,
        
        -- WB Control Ins
        to_reg_in => memory_to_reg,
        call_in => memory_call,
        reg_write_in => memory_reg_write,
        
        -- WB Control Outs
        to_reg_out => writeback_to_reg,
        call_out => writeback_call,
        reg_write_out => writeback_reg_write
    );
    
end behavioral;
