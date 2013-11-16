library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
    signal fetch_pc_inc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal fetch_pc_prev : std_logic_vector(ADDR_WIDTH-1 downto 0);
    
    signal fetch_to_decode_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal fetch_to_decode_inst : std_logic_vector(INST_WIDTH-1 downto 0);

    --DECODE SIGNALS-- 
     
    signal decode_from_fetch_pc : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal decode_from_fetch_inst : std_logic_vector(INST_WIDTH-1 downto 0);
     
    signal decode_opcode : std_logic_vector(OP_CODE_WIDTH-1 downto 0);
    signal decode_function : std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
    signal decode_rsa : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal decode_rta : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal decode_rda : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal decode_rs : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal decode_rt : std_logic_vector(DATA_WIDTH-1 downto 0);
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
    
    signal execute_forward_rs : FORWARD_TYPE;
    signal execute_forward_rt : FORWARD_TYPE;
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
    signal reset_ctrl_unit : STD_LOGIC;
    
    -- DISABLE --
    signal disable_pc : STD_LOGIC;
    signal disable_if_id : STD_LOGIC;
    signal disable_id_ex : STD_LOGIC;
    signal disable_ex_mem : STD_LOGIC;
    signal disable_mem_wb : STD_LOGIC;
    
    -- Other
    signal halt : STD_LOGIC;
    signal dmem_halt : STD_LOGIC;
    signal genetic_halt : STD_LOGIC;
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
    

    -----------
    -- FETCH --
    -----------
    
    FF_PC : entity work.pc
    generic map (
        START_ADDR => processor_id
    )
    port map ( 
        -- Control signals
        clk => clk,
        reset => reset_pc,
        disable => disable_pc,

        -- Ins
        pc_in => fetch_pc_inc,

        -- Outs
        pc_out => fetch_to_decode_pc
    );
    
    -- PC Incrementer
    fetch_pc_inc <= STD_LOGIC_VECTOR(UNSIGNED(fetch_pc) + 1);
    
    -- MUX: PC Input
    imem_addr <= fetch_pc_prev when imem_halt = '1' else fetch_pc;
    
    -- MUX : Jump
    fetch_pc <=
        fetch_to_decode_pc when memory_jump = '0' else
        memory_from_execute_res(ADDR_WIDTH-1 downto 0);
    
    FF_PC_PREV : process(clk, imem_halt, fetch_pc)
    begin
        if (rising_edge(clk) and imem_halt = '0') then
            fetch_pc_prev <= fetch_pc;
        end if;
    end process;
    
    fetch_to_decode_inst <= imem_data_in;
    
    ------------
    -- DECODE --
    ------------
    
    REGISTERS : entity work.register_file
	port map (
        CLK => clk,
        RW => writeback_reg_write,
        RS_ADDR => decode_to_execute_rsa,
        RT_ADDR => decode_to_execute_rta,
        RD_ADDR => writeback_wba,
        WRITE_DATA => writeback_wb,
        RS => decode_rs,
        RT => decode_rt
	);
    
    -- MUX: RegSrc
    decode_to_execute_rsa <= decode_rsa when decode_reg_src = '0' else decode_to_execute_rda;
    
    -- MUX: MemOp = Store
    decode_to_execute_rta <= decode_rta when decode_mem_op /= MEM_WRITE else decode_to_execute_rda;
    
    -- MUX: Immediate Source
    decode_to_execute_imm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(decode_imm), DATA_WIDTH)) when decode_imm_src = '0' else STD_LOGIC_VECTOR(RESIZE(UNSIGNED(decode_target), DATA_WIDTH));
    
    DECODER : process(decode_from_fetch_inst)
    begin
        decode_cond <= decode_from_fetch_inst(32-1 downto 28); 
        decode_opcode <= decode_from_fetch_inst(28-1 downto 24);
        decode_rda <= decode_from_fetch_inst(24-1 downto 19);
        decode_rsa <= decode_from_fetch_inst(19-1 downto 14);
        decode_rta <= decode_from_fetch_inst(14-1 downto 9);
        decode_function <= decode_from_fetch_inst(4-1 downto 0);
        decode_imm <= decode_from_fetch_inst(14-1 downto 4);
        decode_target <= decode_from_fetch_inst(19-1 downto 0);
    end process;
    
    decode_to_execute_rda <= decode_rda;
    
    CTRL_UNIT : entity work.control_unit
	port map (
        reset => reset_ctrl_unit,
        OP_CODE => decode_opcode,
        FUNC => decode_function,
        ALU_SOURCE => decode_alu_src,
        IMM_SOURCE => decode_imm_src,
        REG_SOURCE => decode_reg_src,
        REG_WRITE => decode_reg_write,
        CALL => decode_call,
        JUMP => decode_jump,
        ALU_FUNC => decode_alu_func,
        GENE_OP => decode_gene_op,
        MEM_OP => decode_mem_op,
        TO_REG => decode_to_reg
	);
    
    decode_to_execute_pc <= decode_from_fetch_pc;
    
    FORWARD_RS : process(writeback_reg_write, writeback_wba, decode_rsa, writeback_wb, decode_rs)
    begin
        if writeback_reg_write = '1' and writeback_wba = decode_rsa and decode_rsa /= (REG_ADDR_WIDTH-1 downto 0 => '0') then
            decode_to_execute_rs <= writeback_wb;
        else
            decode_to_execute_rs <= decode_rs;
        end if;
    end process;
    
    FORWARD_RT : process(writeback_reg_write, writeback_wba, decode_rta, writeback_wb, decode_rt)
    begin
        if writeback_reg_write = '1' and writeback_wba = decode_rta and decode_rta /= (REG_ADDR_WIDTH-1 downto 0 => '0') then
            decode_to_execute_rt <= writeback_wb;
        else
            decode_to_execute_rt <= decode_rt;
        end if;
    end process;
    
    -------------
    -- EXECUTE --
    -------------
    
    FORWARDING_UNIT : entity work.forwarding_unit
    port map (
        MEMORY_reg_write        => memory_reg_write,
        WRITEBACK_reg_write     => writeback_reg_write,
        rs_addr                 => execute_from_decode_rsa,
        rt_addr                 => execute_from_decode_rta,
        MEMORY_write_reg_addr   => memory_from_execute_rda,
        WRITEBACK_write_reg_addr => writeback_wba,
        forward_a               => execute_forward_rs,
        forward_b               => execute_forward_rt
    );
    
    -- MUX: Forward RS
    execute_rs_forwarded <=
        execute_from_decode_rs when execute_forward_rs = FORWARD_NO else
        memory_from_execute_res when execute_forward_rs = FORWARD_MEM else
        writeback_wb;
    
    -- MUX: Forward RT
    execute_rt_forwarded <=
        execute_from_decode_rt when execute_forward_rt = FORWARD_NO else
        memory_from_execute_res when execute_forward_rt = FORWARD_MEM else
        writeback_wb;
    
    -- MUX: ALU Source
    execute_alu_b_in <=
        execute_rt_forwarded when execute_alu_src = '0' else
        execute_from_decode_imm;
    
    execute_alu_a_in <= execute_rs_forwarded;
    
    ALU : entity work.ALU
    generic map (
        N => DATA_WIDTH,
        INCMULT => 0
    )
    port map (
        X => execute_alu_a_in,
        Y => execute_alu_b_in,
        R => execute_to_memory_res,
        FUNC => execute_alu_func,
        OVERFLOW => execute_to_memory_overflow
    );
    
    execute_to_memory_pc <= execute_from_decode_pc;
    execute_to_memory_rs <= execute_rs_forwarded;
    execute_to_memory_rt <= execute_rt_forwarded;
    execute_to_memory_rda <= execute_from_decode_rda;
    
    ------------
    -- MEMORY --
    ------------
    
    DMEM_CTRL : entity work.fitness_memory_controller
    generic map (
        ADDR_WIDTH => ADDR_WIDTH-2,
        DATA_WIDTH => DATA_WIDTH
    )
    port map (
        -- Control signals
        REQUEST_0 => dmem_request_0,
        REQUEST_1 => dmem_request_1,
        ACK       => dmem_ack,
        
        -- Processor
        ADDR_IN  => memory_from_execute_res(ADDR_WIDTH-2-1 downto 0),
        DATA_IN  => memory_from_execute_rt,
        DATA_OUT => memory_to_writeback_data,
        
        -- Memory
        MEM_ADDR     => dmem_addr,
        MEM_DATA_IN  => dmem_data_in,
        MEM_DATA_OUT => dmem_data_out,
        
        OP   => memory_mem_op,
        HALT => dmem_halt,
        CLK  => clk
    );
    
    GENETIC_CTRL : entity work.fitness_genetic_controller
    generic map ( 
        DATA_WIDTH => DATA_WIDTH
    )
    port map ( 
        -- To/from genetic pipeline
        REQUEST_0 => genetic_request_0,
        REQUEST_1 => genetic_request_1,
        ACK       => genetic_ack,
        DATA_IN   => genetic_data_in,
        DATA_OUT  => genetic_data_out,
        
        -- To/from processor
        OP       => memory_gene_op,
        FITNESS  => memory_from_execute_rs,
        GENE_IN  => memory_from_execute_rt,
        GENE_OUT => memory_to_writeback_gene,
        HALT     => genetic_halt,
        CLK      => clk
    );
    
    CONDITION_CTRL : entity work.conditional_unit
    generic map (
        N => DATA_WIDTH
    )
    port map (
        COND => execute_cond,
        ALU_RES => memory_from_execute_res,
        ALU_OVF => memory_from_execute_overflow,
        SKIP => memory_condition_reset
    );
    
    memory_to_writeback_pc <= memory_from_execute_pc;
    memory_to_writeback_res <= memory_from_execute_res;
    memory_to_writeback_rda <= memory_from_execute_rda;
    
    ---------------
    -- WRITEBACK --
    ---------------
    
    -- MUX: To Register
    writeback_wb <=
        writeback_from_memory_gene when writeback_to_reg = "00" else
        writeback_from_memory_res when writeback_to_reg = "01" else
        writeback_from_memory_data when writeback_to_reg = "11" else
        (DATA_WIDTH-1 downto ADDR_WIDTH => '0') & writeback_from_memory_pc;
    
    -- MUX: Call
    writeback_wba <= writeback_from_memory_rda when writeback_call = '0' else (others => '1');
    
    --------------
    -- PIPELINE --
    --------------
    
    -- Resets
    reset_pc <= reset;
    reset_if_id <= reset or (memory_jump and not halt);
    reset_id_ex <= reset or (memory_jump and not halt);
    reset_ex_mem <= reset or ((memory_jump or memory_condition_reset) and not halt);
    reset_mem_wb <= reset;
    reset_ctrl_unit <= reset; -- Don't really need this
    
    -- Halts
    halt <= imem_halt or dmem_halt or genetic_halt;
    disable_pc <= halt or not processor_enable;
    disable_if_id <= halt or not processor_enable;
    disable_id_ex <= halt or not processor_enable;
    disable_ex_mem <= halt or not processor_enable;
    disable_mem_wb <= halt or not processor_enable;
    
end behavioral;
