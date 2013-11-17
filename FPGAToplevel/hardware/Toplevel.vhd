-- Toplevel design for the project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity Toplevel is
    generic(
        NUM_PROC : natural := 1
    );
    port(
        SCU_ENABLE  : in    STD_LOGIC;
        
        SCU_STATE   : in    STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0);
        
        SCU_CE      : in    STD_LOGIC;
        SCU_WE      : in    STD_LOGIC;
        SCU_DATA    : inout STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
        SCU_ADDR    : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        SCU_LBUB    : in    STD_LOGIC;
        
        IMEM_CE_HI      : out   STD_LOGIC;
        IMEM_CE_LO      : out   STD_LOGIC;
        IMEM_WE_HI      : out   STD_LOGIC;
        IMEM_WE_LO      : out   STD_LOGIC;
        IMEM_DATA_HI    : inout STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
        IMEM_DATA_LO    : inout STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
        IMEM_ADDR       : out   STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        IMEM_LBUB       : out   STD_LOGIC;
        
        DMEM_CE     : out   STD_LOGIC;
        DMEM_WE     : out   STD_LOGIC;
        DMEM_DATA   : inout STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
        DMEM_ADDR   : out   STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        DMEM_LBUB   : out   STD_LOGIC;

        Clock       : in    STD_LOGIC
    );
end Toplevel;


architecture behavioral of toplevel is

    -- Instruction controller signals
    signal InstCE   : STD_LOGIC;
    signal InstWE   : STD_LOGIC;
    signal InstLBUB : STD_LOGIC;
    signal InstAddr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal InstData_IN : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
    signal InstData_OUT : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
    --signal InstRq   : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
    --signal InstAck  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
    signal InstRq   : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal InstAck  : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal InstAddrBus : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); -- To processors
    signal InstDataBus : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0); -- To processors

    -- Data controller signals
    signal DataCE   : STD_LOGIC;
    signal DataWE   : STD_LOGIC;
    signal DataLBUB : STD_LOGIC;
    signal DataAddr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal DataData_IN : STD_LOGIC_VECTOR(16-1 downto 0);
    signal DataData_OUT : STD_LOGIC_VECTOR(16-1 downto 0);
    signal DataRq0  : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal DataRq1  : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal DataAck  : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal DataAddrBus    : STD_LOGIC_VECTOR(17-1 downto 0); -- To processors
    signal DataDataInBus  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); -- To processors
    signal DataDataOutBus : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); -- To processors
    
    -- random signals
    signal reset : std_logic;
    
    -- instruction cache signals
--    signal instruction_cache_MemRq : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
--    signal instruction_cache_MemAck : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
--    signal instruction_cache_Halt :  STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
--    signal instruction_cache_MemAddr : std_logic_vector(ADDR_WIDTH-1 downto 0);
--    signal instruction_cache_MemData : std_logic_vector(INST_WIDTH-1 downto 0);
--    type ARRAY_PC_TYPE is array (0 to NUM_PROC_PAIRS-1) of std_logic_vector(ADDR_WIDTH-1 downto 0);
--    type ARRAY_INST_TYPE is array (0 to NUM_PROC_PAIRS-1) of std_logic_vector(INST_WIDTH-1 downto 0);
--    signal instruction_cache_PCA : ARRAY_PC_TYPE;
--    signal instruction_cache_PCB : ARRAY_PC_TYPE;
--    signal instruction_cache_InstA : ARRAY_INST_TYPE;
--    signal instruction_cache_InstB : ARRAY_INST_TYPE;
    signal instruction_cache_MemRq : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal instruction_cache_MemAck : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal instruction_cache_Halt :  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal instruction_cache_MemAddr : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal instruction_cache_MemData : std_logic_vector(INST_WIDTH-1 downto 0);
    type ARRAY_PC_TYPE is array (0 to NUM_PROC-1) of std_logic_vector(ADDR_WIDTH-1 downto 0);
    type ARRAY_INST_TYPE is array (0 to NUM_PROC-1) of std_logic_vector(INST_WIDTH-1 downto 0);
    signal instruction_cache_PC : ARRAY_PC_TYPE;
    signal instruction_cache_Inst : ARRAY_INST_TYPE;
    
    -- Genetic signals
    signal genetic_request_0 : std_logic_vector(NUM_PROC-1 downto 0);
    signal genetic_request_1 : std_logic_vector(NUM_PROC-1 downto 0);
    signal genetic_ack : std_logic_vector(NUM_PROC-1 downto 0);
    signal genetic_rated_bus : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal genetic_unrated_bus : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    -- Uni-directional signals
    signal SCU_DATA_OE : STD_LOGIC := '0';
    signal SCU_DATA_IN     : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    signal SCU_DATA_OUT    : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    
    signal IMEM_DATA_HI_OE : STD_LOGIC := '0';
    signal IMEM_DATA_HI_IN    : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    signal IMEM_DATA_HI_OUT   : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    
    signal IMEM_DATA_LO_OE : STD_LOGIC := '0';
    signal IMEM_DATA_LO_IN    : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    signal IMEM_DATA_LO_OUT   : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    
    signal DMEM_DATA_OE : STD_LOGIC := '0';
    signal DMEM_DATA_IN   : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    signal DMEM_DATA_OUT  : STD_LOGIC_VECTOR(MEMORY_WIDTH-1 downto 0);
    
    signal IMEM_CE_HI_INT : STD_LOGIC;
    signal IMEM_CE_LO_INT : STD_LOGIC;
    signal IMEM_WE_HI_INT : STD_LOGIC;
    signal IMEM_WE_LO_INT : STD_LOGIC;
    signal DMEM_CE_INT : STD_LOGIC;
    signal DMEM_WE_INT : STD_LOGIC;

begin
    
    SCU_DATA_OE <= SCU_WE or SCU_CE;
    IMEM_DATA_HI_OE <= not(IMEM_CE_HI_INT or IMEM_WE_HI_INT);
    IMEM_DATA_LO_OE <= not(IMEM_CE_LO_INT or IMEM_WE_LO_INT);
    DMEM_DATA_OE <= not(DMEM_CE_INT or DMEM_WE_INT);
    
    SPLIT_SCU_DATA : process(SCU_DATA_OE , SCU_DATA, SCU_DATA_OUT)
    begin
        if SCU_DATA_OE = '0' then
            SCU_DATA <= (others => 'Z');
        else
            SCU_DATA <= SCU_DATA_OUT;
        end if;
        
        SCU_DATA_IN <= SCU_DATA;
    end process;
    
    SPLIT_IMEM_DATA_HI : process(IMEM_DATA_HI_OE, IMEM_DATA_HI, IMEM_DATA_HI_OUT)
    begin
        if IMEM_DATA_HI_OE = '0' then
            IMEM_DATA_HI <= (others => 'Z');
        else
            IMEM_DATA_HI <= IMEM_DATA_HI_OUT;
        end if;
        
        IMEM_DATA_HI_IN <= IMEM_DATA_HI;
    end process;
    
    SPLIT_IMEM_DATA_LO : process(IMEM_DATA_LO_OE, IMEM_DATA_LO, IMEM_DATA_LO_OUT)
    begin
        if IMEM_DATA_LO_OE = '0' then
            IMEM_DATA_LO <= (others => 'Z');
        else
            IMEM_DATA_LO <= IMEM_DATA_LO_OUT;
        end if;
        
        IMEM_DATA_LO_IN <= IMEM_DATA_LO;
    end process;
    
    SPLIT_DMEM_DATA : process(DMEM_DATA_OE, DMEM_DATA, DMEM_DATA_OUT)
    begin
        if DMEM_DATA_OE = '0' then
            DMEM_DATA <= (others => 'Z');
        else
            DMEM_DATA <= DMEM_DATA_OUT;
        end if;
        
        DMEM_DATA_IN <= DMEM_DATA;
    end process;
    
    
    
    MemMux : entity work.MemMux
    generic map(
        DATA_WIDTH => MEMORY_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        SCU_STATE   => SCU_STATE,
        
        SCU_CE      => SCU_CE,
        SCU_WE      => SCU_WE,
        SCU_DATA_IN => SCU_DATA_IN,
        SCU_DATA_OUT => SCU_DATA_OUT,
        SCU_ADDR    => SCU_ADDR,
        SCU_LBUB    => SCU_LBUB,
        
        ICTRL_CE    => InstCE,
        ICTRL_WE    => InstWE,
        ICTRL_DATA_IN => InstData_IN,
        ICTRL_DATA_OUT => InstData_OUT,
        ICTRL_ADDR  => InstAddr,
        ICTRL_LBUB  => InstLBUB,
        
        DCTRL_CE    => DataCE,
        DCTRL_WE    => DataWE,
        DCTRL_DATA_IN => DataData_IN,
        DCTRL_DATA_OUT => DataData_OUT,
        DCTRL_ADDR  => DataAddr,
        DCTRL_LBUB  => DataLBUB,
        
        IMEM_CE_HI      => IMEM_CE_HI_INT,
        IMEM_CE_LO      => IMEM_CE_LO_INT,
        IMEM_WE_HI      => IMEM_WE_HI_INT,
        IMEM_WE_LO      => IMEM_WE_LO_INT,
        IMEM_DATA_HI_IN => IMEM_DATA_HI_IN,
        IMEM_DATA_HI_OUT => IMEM_DATA_HI_OUT,
        IMEM_DATA_LO_IN => IMEM_DATA_LO_IN,
        IMEM_DATA_LO_OUT => IMEM_DATA_LO_OUT,
        IMEM_ADDR       => IMEM_ADDR,
        IMEM_LBUB       => IMEM_LBUB,
        
        DMEM_CE     => DMEM_CE_INT,
        DMEM_WE     => DMEM_WE_INT,
        DMEM_DATA_IN => DMEM_DATA_IN,
        DMEM_DATA_OUT => DMEM_DATA_OUT,
        DMEM_ADDR   => DMEM_ADDR,
        DMEM_LBUB   => DMEM_LBUB
    );
    
    IMEM_CE_HI <= IMEM_CE_HI_INT;
    IMEM_CE_LO <= IMEM_CE_LO_INT;
    DMEM_CE <= DMEM_CE_INT;
    
    IMEM_WE_HI <= IMEM_WE_HI_INT;
    IMEM_WE_LO <= IMEM_WE_LO_INT;
    DMEM_WE <= DMEM_WE_INT;

    InstructionController : entity work.InstructionController
    generic map(
        --NUM_CACHES => NUM_PROC_PAIRS,
        NUM_CACHES => NUM_PROC,
        ADDR_WIDTH => ADDR_WIDTH,
        INST_WIDTH => INST_WIDTH
    )
    port map(
        Request => InstRq,
        Ack     => InstAck,
        
        Addr    => InstAddrBus,
        Data    => InstDataBus,
        
        MemAddr => InstAddr,
        MemData => InstData_OUT,
        MemCE   => InstCE,
        MemWE   => InstWE,
        MemLBUB => InstLBUB,
        
        Enabled => SCU_Enable,
        Clock   => Clock
    );
    
    data_controller : entity work.memory_data_controller
    generic map(
        NUM_PROC   => NUM_PROC,
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        -- Control signals
        REQUEST_0 => DataRq0, 
        REQUEST_1 => DataRq1, 
        ACK       => DataAck, 
        
        -- Buses
        PROC_ADDR  => DataAddrBus,
        PROC_DATA_IN  => DataDataInBus, 
        PROC_DATA_OUT => DataDataOutBus, 
        
        -- Memory
        MEM_ADDR   => DataAddr,
        MEM_DATA_IN => DataData_OUT,
        MEM_DATA_OUT => DataData_IN,
        MEM_ENABLE => DataCE,
        MEM_WRITE  => DataWE,
        MEM_LBUB   => DataLBUB,
        
        ENABLE => SCU_Enable,
        CLK => Clock
    );
    
    genetic_pipeline : entity work.genetic_pipeline
    generic map (
        NUM_PROC     => NUM_PROC,
        DATA_WIDTH   => DATA_WIDTH
    )
    port map(
        REQUEST_0 => genetic_request_0,
        REQUEST_1 => genetic_request_1,
        ACK       => genetic_ack,
        DATA_IN   => genetic_rated_bus,
        DATA_OUT  => genetic_unrated_bus,
        RESET     => reset,
        CLK       => Clock
    );
    
--    --Maps instruction caches and fitness cores
--    FITNESS_CORE_PAIRS: for i in 0 to NUM_PROC_PAIRS-1 generate
--    
--        INSTRUCTION_CACHE : entity work.InstructionCache
--        port map(
--            MemRq => InstRq(i),
--            MemAck => InstAck(i),
--            
--            MemAddr	=> InstAddrBus,
--            MemData => InstDataBus,
--            
--            PCA => instruction_cache_PCA(i),
--            PCB => instruction_cache_PCB(i),
--
--            InstA => instruction_cache_InstA(i),
--            InstB => instruction_cache_InstB(i),
--            
--            Halt => instruction_cache_Halt(i),
--            
--            Reset => reset,
--            Clock => Clock
--        );
--       
--    
--        FITNESS_CORE_A : entity work.fitness_core
--        port map(
--            -- Bit signals
--            clk => Clock,
--            reset => reset,
--            processor_enable => SCU_ENABLE,
--            
--            --Control signals related to the instruction cache
--            halt_inst => instruction_cache_Halt(i),
--            
--            --Bus signals related to instruction cache
--            imem_address => instruction_cache_PCA(i),
--            imem_data_in => instruction_cache_InstA(i),
--            
--            --Control signals related to the data memory
--            data_request_0 => DataRq0(i*2),
--            data_request_1 => DataRq1(i*2),
--            ack_mem_ctrl => DataAck(i*2),
--            
--            --Bus signals related to data memory
--            data_mem_bus_in => DataDataOutBus,
--            data_mem_addr_bus => DataAddrBus,
--            data_mem_bus_out => DataDataInBus,
--            
--            --Bus signals related to genetic storage
--            genetic_data_out => genetic_rated_bus,
--            genetic_data_in => genetic_unrated_bus,
--            
--            --Control signals related to genetic storage
--            ack_genetic_ctrl => genetic_ack(i*2),
--            genetic_request_0 => genetic_request_0(i*2),
--            genetic_request_1 => genetic_request_1(i*2)
--        );
--        
--        FITNESS_CORE_B : entity work.fitness_core
--        port map(
--            -- Bit signals
--            clk => Clock,
--            reset => reset,
--            processor_enable => SCU_ENABLE,
--            
--            --Control signals related to the instruction cache
--            halt_inst => instruction_cache_Halt(i),
--            
--            --Bus signals related to instruction cache
--            imem_address => instruction_cache_PCB(i),
--            imem_data_in => instruction_cache_InstB(i),
--            
--            --Control signals related to the data memory
--            data_request_0 => DataRq0(i*2+1),
--            data_request_1 => DataRq1(i*2+1),
--            ack_mem_ctrl => DataAck(i*2+1),
--            
--            --Bus signals related to data memory
--            data_mem_bus_in => DataDataOutBus,
--            data_mem_addr_bus => DataAddrBus,
--            data_mem_bus_out => DataDataInBus,
--            
--            --Bus signals related to genetic storage
--            genetic_data_out => genetic_rated_bus,
--            genetic_data_in => genetic_unrated_bus,
--            
--            --Control signals related to genetic storage
--            ack_genetic_ctrl => genetic_ack(i*2+1),
--            genetic_request_0 => genetic_request_0(i*2+1),
--            genetic_request_1 => genetic_request_1(i*2+1)
--        );
--    end generate FITNESS_CORE_PAIRS;

    -- Maps instruction caches and fitness cores
    FITNESS_CORES: for i in 0 to NUM_PROC-1 generate
    
        INSTRUCTION_CACHE : entity work.InstructionCacheSingle
        port map(
            MemRq => InstRq(i),
            MemAck => InstAck(i),
            
            MemAddr	=> InstAddrBus,
            MemData => InstDataBus,
            
            PC => instruction_cache_PC(i),
            Inst => instruction_cache_Inst(i),
            
            Halt => instruction_cache_Halt(i),
            
            Reset => reset,
            Clock => Clock
        );
        
        FITNESS_CORE_A : entity work.fitness_core
        generic map(processor_id => i + 1)
        port map(
            -- Bit signals
            clk => Clock,
            reset => reset,
            processor_enable => SCU_ENABLE,
            
            --Control signals related to the instruction cache
            imem_halt => instruction_cache_Halt(i),
            
            --Bus signals related to instruction cache
            imem_addr => instruction_cache_PC(i),
            imem_data_in => instruction_cache_Inst(i),
            
            --Control signals related to the data memory
            dmem_request_0 => DataRq0(i),
            dmem_request_1 => DataRq1(i),
            dmem_ack => DataAck(i),
            
            --Bus signals related to data memory
            dmem_addr => DataAddrBus,
            dmem_data_in => DataDataOutBus,
            dmem_data_out => DataDataInBus,
            
            --Bus signals related to genetic storage
            genetic_data_in => genetic_unrated_bus,
            genetic_data_out => genetic_rated_bus,
            
            --Control signals related to genetic storage
            genetic_request_0 => genetic_request_0(i),
            genetic_request_1 => genetic_request_1(i),
            genetic_ack => genetic_ack(i)
        );
    
    end generate FITNESS_CORE_PAIRS;
    
    -- Reset when SCU connected to imem
    reset <= '1' when SCU_STATE = STATE_INST_HI or SCU_STATE = STATE_INST_LO else '0';
    
end Behavioral;

