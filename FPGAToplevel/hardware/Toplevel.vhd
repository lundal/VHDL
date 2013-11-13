----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-22 19:04
-- Tested:   Never
--
-- Description:
-- Toplevel design for the project
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity Toplevel is
    generic(
		NUM_PROC_PAIRS : natural := 4;
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

architecture Behavioral of Toplevel is
	
    component MemMux is
        generic(
            DATA_WIDTH : natural := 16;
            ADDR_WIDTH : natural := 19
        );
        port(
            SCU_STATE   : in    STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0);
            
            SCU_CE      : in    STD_LOGIC;
            SCU_WE      : in    STD_LOGIC;
            SCU_DATA    : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            SCU_ADDR    : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            SCU_LBUB    : in    STD_LOGIC;
            
            ICTRL_CE    : in    STD_LOGIC;
            ICTRL_WE    : in    STD_LOGIC;
            ICTRL_DATA  : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            ICTRL_ADDR  : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            ICTRL_LBUB  : in    STD_LOGIC;
            
            DCTRL_CE    : in    STD_LOGIC;
            DCTRL_WE    : in    STD_LOGIC;
            DCTRL_DATA  : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            DCTRL_ADDR  : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            DCTRL_LBUB  : in    STD_LOGIC;
            
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
            DMEM_LBUB   : out   STD_LOGIC
        );
    end component;
	
    component InstructionController is
        generic(
            NUM_CACHES : natural := 2;
            ADDR_WIDTH : natural := 19;
            INST_WIDTH : natural := 32
        );
        port(
            MemCE   : out   STD_LOGIC;
            MemWE   : out   STD_LOGIC;
            MemLBUB : out   STD_LOGIC;
            MemAddr	: out   STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            MemData : inout STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
            Request : in    STD_LOGIC_VECTOR(NUM_CACHES-1 downto 0);
            Ack     : out   STD_LOGIC_VECTOR(NUM_CACHES-1 downto 0);
            Addr    : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            Data    : out   STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
            Enabled : in    STD_LOGIC;
            Clock   : in    STD_LOGIC
        );
    end component;
	
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
	signal DataData : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal DataRq   : STD_LOGIC_VECTOR(NUM_PROC_PAIRS*2-1 downto 0);
	signal DataAck  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS*2-1 downto 0);
	signal DataAddrBus : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); -- To processors
	signal DataDataBus : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); -- To processors
	
begin
	
    MegaMux : MemMux
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
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
    
	InstCtrl : InstructionController
	generic map(
		NUM_CACHES => NUM_PROC_PAIRS,
        ADDR_WIDTH => ADDR_WIDTH,
        INST_WIDTH => INST_WIDTH
	)
	port map(
		MemCE   => InstCE,
		MemWE   => InstWE,
		MemAddr	=> InstAddr,
		MemData => InstData,
		Request => InstRq,
		Ack     => InstAck,
		Addr    => InstAddrBus,
		Data    => InstDataBus,
		Enabled => SCU_Enable,
		Clock   => Clock
	);
	
end Behavioral;

