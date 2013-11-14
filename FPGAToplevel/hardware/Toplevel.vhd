-- Toplevel design for the project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity Toplevel is
    generic(
        NUM_PROC_PAIRS : natural := 1;
        ADDR_WIDTH     : natural := 19;
        INST_WIDTH     : natural := 32;
        DATA_WIDTH     : natural := 16
    );
    port(
        SCU_ENABLE  : in    STD_LOGIC;
        
        SCU_STATE   : in    STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0);
        
        SCU_CE      : in    STD_LOGIC;
        SCU_WE      : in    STD_LOGIC;
        SCU_DATA    : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        SCU_ADDR    : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        SCU_LBUB    : in    STD_LOGIC;
        
        IMEM_CE_HI      : out   STD_LOGIC;
        IMEM_CE_LO      : out   STD_LOGIC;
        IMEM_WE_HI      : out   STD_LOGIC;
        IMEM_WE_LO      : out   STD_LOGIC;
        IMEM_DATA_HI    : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        IMEM_DATA_LO    : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        IMEM_ADDR       : out   STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        IMEM_LBUB       : out   STD_LOGIC;
        
        DMEM_CE     : out   STD_LOGIC;
        DMEM_WE     : out   STD_LOGIC;
        DMEM_DATA   : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
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
    signal InstData : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
    signal InstRq   : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
    signal InstAck  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
    signal InstAddrBus : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); -- To processors
    signal InstDataBus : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0); -- To processors

    -- Data controller signals
    signal DataCE   : STD_LOGIC;
    signal DataWE   : STD_LOGIC;
    signal DataLBUB : STD_LOGIC;
    signal DataAddr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal DataData : STD_LOGIC_VECTOR(16-1 downto 0);
    signal DataRq0  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS*2-1 downto 0);
	 signal DataRq1  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS*2-1 downto 0);
    signal DataAck  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS*2-1 downto 0);
    signal DataAddrBus : STD_LOGIC_VECTOR(17-1 downto 0); -- To processors
    signal DataDataBus : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); -- To processors
    
    -- random signals
    signal reset : std_logic;
	 
	 -- instruction cache signals
    signal instruction_cache_MemRq : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
    signal instruction_cache_MemAck : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
    signal instruction_cache_MemAddr : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal instruction_cache_MemData : std_logic_vector(INST_WIDTH-1 downto 0);
    signal instruction_cache_PCA : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal instruction_cache_PCB : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal instruction_cache_InstA : std_logic_vector(INST_WIDTH-1 downto 0);
    signal instruction_cache_InstB : std_logic_vector(INST_WIDTH-1 downto 0);
    signal instruction_cache_Halt :  STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
	 
	 -- Genetic signals
	 signal genetic_request_0 : std_logic_vector(NUM_PROC_PAIRS*2-1 downto 0);
    signal genetic_request_1 : std_logic_vector(NUM_PROC_PAIRS*2-1 downto 0);
	 signal genetic_ack : std_logic_vector(NUM_PROC_PAIRS*2-1 downto 0);
	 signal genetic_data_in : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal genetic_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

MemMux : entity work.MemMux
port map(
        SCU_STATE   => SCU_STATE,
        
        SCU_CE      => SCU_CE,
        SCU_WE      => SCU_WE,
        SCU_DATA    => SCU_DATA,
        SCU_ADDR    => SCU_ADDR,
        SCU_LBUB    => SCU_LBUB,
        
        ICTRL_CE    => InstCE,
        ICTRL_WE    => InstWE,
        ICTRL_DATA  => InstData,
        ICTRL_ADDR  => InstAddr,
        ICTRL_LBUB  => InstLBUB,
        
        DCTRL_CE    => DataCE,
        DCTRL_WE    => DataWE,
        DCTRL_DATA  => DataData,
        DCTRL_ADDR  => DataAddr,
        DCTRL_LBUB  => DataLBUB,
        
        IMEM_CE_HI      => IMEM_CE_HI,
        IMEM_CE_LO      => IMEM_CE_LO,
        IMEM_WE_HI      => IMEM_WE_HI,
        IMEM_WE_LO      => IMEM_WE_LO,
        IMEM_DATA_HI    => IMEM_DATA_HI,
        IMEM_DATA_LO    => IMEM_DATA_LO,
        IMEM_ADDR       => IMEM_ADDR,
        IMEM_LBUB       => IMEM_LBUB,

        DMEM_CE     => DMEM_CE,
        DMEM_WE     => DMEM_WE,
        DMEM_DATA   => DMEM_DATA,
        DMEM_ADDR   => DMEM_ADDR,
        DMEM_LBUB   => DMEM_LBUB
);

InstructionController : entity work.InstructionController
generic map(
        NUM_CACHES => NUM_PROC_PAIRS,
        ADDR_WIDTH => ADDR_WIDTH,
        INST_WIDTH => INST_WIDTH
        )
port map(
        MemCE   => InstCE,
        MemWE   => InstWE,
        MemAddr => InstAddr,
        MemData => InstData,
        Request => InstRq,
        Ack     => InstAck,
        MemLBUB    => InstLBUB,
        Addr    => InstAddrBus,
        Data    => InstDataBus,
        Enabled => SCU_Enable,
        Clock   => Clock
        );
    


data_controller : entity work.memory_data_controller
port map( -- Control signals
		   REQUEST_0 => data_request_0, 
			REQUEST_1 => data_request_1, 
		   ACK       => ack_mem_ctrl, 
        
	      -- Buses
			PROC_ADDR  => data_mem_addr_bus,
			PROC_DATA_IN  => data_mem_bus_out, 
			PROC_DATA_OUT => data_mem_bus_in, 
        
			-- Memory
			MEM_ADDR   => DataAddr,
			MEM_DATA   => DataData,
			MEM_ENABLE => DataCE,
			MEM_WRITE  => DataWE,
			MEM_LBUB   => DataLBUB,
        
         CLK => clk
    );




    
genetic_pipeline : entity work.genetic_pipeline
port map(
			REQUEST_0 => genetic_request_0, 
			REQUEST_1 => genetic_request_1, 
			ACK       => ack_genetic_ctrl, 
			DATA_IN   => genetic_data_in, 
			DATA_OUT  => genetic_data_out, 
			RESET     => reset, 
			CLK       => clk 
    );
	 
	 
	 
    --Maps instruction caches and fitness cores
    FITNESS_CORE_PAIRS: for i in 0 to NUM_PROC_PAIRS-1 generate
    
        INSTRUCTION_CACHE : entity work.InstructionCache
        port map(
            MemRq => instruction_cache_MemRq(i),
            MemAck => instruction_cache_MemAck(i),
            
            MemAddr	=> instruction_cache_MemAddr(i),
            MemData => instruction_cache_MemData(i),
            
            PCA => instruction_cache_PCA(i),
            PCB => instruction_cache_PCB(i),

            InstA => instruction_cache_InstA(i),
            InstB => instruction_cache_InstB(i),
            
            Halt => instruction_cache_Halt(i),
            
            Reset => Reset,
            Clock => Clock
        );
       
    
        FITNESS_CORE_A : entity work.fitness_core
        port map(
            -- Bit signals
            clk => Clock,
            reset => reset,
            processor_enable => scu_enable,

            --Control signals related to the instruction cache
            halt_inst => halt_inst(i*2),

            --Bus signals related to instruction cache
            imem_address => instruction_address_bus,
            imem_data_in => InstDataBus,

            --Control signals related to the data memory
            data_request_0 => data_request_0(i*2),
				data_reqquest_1 =>data_request_0(i*2), 
            ack_mem_ctrl => ack_mem_ctrl(i*2),

            --Bus signals related to data memory
            data_mem_bus_in => data_mem_bus_in, 
            data_mem_addr_bus => data_mem_addr_bus, 
            data_mem_bus_out => data_mem_bus_out, 

            --Bus signals related to genetic storage
            genetic_data_out => genetic_data_out,  
				genetic_data_in => genetic_data_in,

            --Control signals related to genetic storage
            ack_genetic_ctrl => ack_genetic_ctrl(i*2),
            genetic_request_0 => genetic_request_0(i*2),
            genetic_request_1 => genetic_request_1(i*2)
        );
        
        FITNESS_CORE_B : entity work.fitness_core
        port map(
            -- Bit signals
            clk => Clock,
            reset => reset,
            processor_enable => scu_enable,

            --Control signals related to the instruction cache
            halt_inst => halt_inst(i*2+1),

            --Bus signals related to instruction cache
            imem_address => instruction_address_bus,
            imem_data_in => InstDataBus,

            --Control signals related to the data memory
            data_request_0 => data_request_0(i*2+1), 
				data_request_1 =>data_request_1(i*2+1), 
            ack_mem_ctrl => ack_mem_ctrl(i*2+1),

            --Bus signals related to data memory
            data_mem_bus_in => data_mem_bus_in, 
            data_mem_addr_bus => data_mem_addr_bus, 
            data_mem_bus_out => data_mem_bus_out,

            --Bus signals related to genetic storage
            genetic_data_out => genetic_data_out,
            genetic_data_in => genetic_data_in,

            --Control signals related to genetic storage
            ack_genetic_ctrl => ack_genetic_ctrl(i*2+1),
            genetic_request_0 => genetic_request_0(i*2+1),
            genetic_request_1 => genetic_request_1(i*2+1)
        );
    end generate FITNESS_CORE_PAIRS;
        
end Behavioral;
        
