----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-22 18:36
-- Tested:   Never
--
-- Description:
-- A grand mux that hooks the SCU and memory controllers to correct targets
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity MemMux is
    generic(
        DATA_WIDTH : natural := 16;
        ADDR_WIDTH : natural := 19
    );
    port(
        SCU_STATE   : in    STD_LOGIC_VECTOR(STATE_WIDTH-1 downto 0);
        
        SCU_CE      : in    STD_LOGIC;
        SCU_WE      : in    STD_LOGIC;
        SCU_DATA_IN : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        SCU_DATA_OUT: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        SCU_ADDR    : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        SCU_LBUB    : in    STD_LOGIC;
        
        ICTRL_CE    : in    STD_LOGIC;
        ICTRL_WE    : in    STD_LOGIC;
        ICTRL_DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH*2-1 downto 0);
        ICTRL_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH*2-1 downto 0);
        ICTRL_ADDR  : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        ICTRL_LBUB  : in    STD_LOGIC;
        
        DCTRL_CE    : in    STD_LOGIC;
        DCTRL_WE    : in    STD_LOGIC;
        DCTRL_DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DCTRL_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DCTRL_ADDR  : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        DCTRL_LBUB  : in    STD_LOGIC;
        
        IMEM_CE_HI      : out   STD_LOGIC;
        IMEM_CE_LO      : out   STD_LOGIC;
        IMEM_WE_HI      : out   STD_LOGIC;
        IMEM_WE_LO      : out   STD_LOGIC;
        IMEM_DATA_HI_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        IMEM_DATA_HI_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        IMEM_DATA_LO_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        IMEM_DATA_LO_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        IMEM_ADDR       : out   STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        IMEM_LBUB       : out   STD_LOGIC;
        
        DMEM_CE     : out   STD_LOGIC;
        DMEM_WE     : out   STD_LOGIC;
        DMEM_DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DMEM_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DMEM_ADDR   : out   STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        DMEM_LBUB   : out   STD_LOGIC
    );
end MemMux;

architecture Behavioral of MemMux is
    
    -- Mux signals
    signal MuxIH : STD_LOGIC;
    signal MuxIL : STD_LOGIC;
    signal MUXI  : STD_LOGIC;
    signal MUXD  : STD_LOGIC;
    
begin
    
    STATE_DECODER : process(SCU_STATE)
    begin
        case SCU_STATE is
            when STATE_PROC =>
                MuxIH <= '0';
                MuxIL <= '0';
                MuxD  <= '0';
            when STATE_INST_HI =>
                MuxIH <= '1';
                MuxIL <= '0';
                MuxD  <= '0';
            when STATE_INST_LO =>
                MuxIH <= '0';
                MuxIL <= '1';
                MuxD  <= '0';
            when STATE_DATA =>
                MuxIH <= '0';
                MuxIL <= '0';
                MuxD  <= '1';
            when others =>
                -- This should never happen
                MuxIH <= '0';
                MuxIL <= '0';
                MuxD  <= '0';
        end case;
    end process;
    
    MuxI <= MuxIH or MuxIL;
    
    INST_HI_MUX : entity work.MemMuxA
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map (
        CE     => IMEM_CE_HI,
        WE     => IMEM_WE_HI,
        DATA_IN => IMEM_DATA_HI_IN,
        DATA_OUT => IMEM_DATA_HI_OUT,
        
        A_CE   => ICTRL_CE,
        A_WE   => ICTRL_WE,
        A_DATA_IN => ICTRL_DATA_IN(DATA_WIDTH*2-1 downto DATA_WIDTH),
        A_DATA_OUT => ICTRL_DATA_OUT(DATA_WIDTH*2-1 downto DATA_WIDTH),
        
        B_CE   => SCU_CE,
        B_WE   => SCU_WE,
        B_DATA_IN => SCU_DATA_IN,
        B_DATA_OUT => SCU_DATA_OUT,
        
        Sel    => MuxIH
    );
    
    INST_LO_MUX : entity work.MemMuxA
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map (
        CE     => IMEM_CE_LO,
        WE     => IMEM_WE_LO,
        DATA_IN => IMEM_DATA_LO_IN,
        DATA_OUT => IMEM_DATA_LO_OUT,
        
        A_CE   => ICTRL_CE,
        A_WE   => ICTRL_WE,
        A_DATA_IN => ICTRL_DATA_IN(DATA_WIDTH-1 downto 0),
        A_DATA_OUT => ICTRL_DATA_OUT(DATA_WIDTH-1 downto 0),
        
        B_CE   => SCU_CE,
        B_WE   => SCU_WE,
        B_DATA_IN => SCU_DATA_IN,
        B_DATA_OUT => SCU_DATA_OUT,
        
        Sel    => MuxIL
    );
    
    DATA_MUX : entity work.MemMuxA
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map (
        CE     => DMEM_CE,
        WE     => DMEM_WE,
        DATA_IN => DMEM_DATA_IN,
        DATA_OUT => DMEM_DATA_OUT,
        
        A_CE   => DCTRL_CE,
        A_WE   => DCTRL_WE,
        A_DATA_IN => DCTRL_DATA_IN,
        A_DATA_OUT => DCTRL_DATA_OUT,
        
        B_CE   => SCU_CE,
        B_WE   => SCU_WE,
        B_DATA_IN => SCU_DATA_IN,
        B_DATA_OUT => SCU_DATA_OUT,
        
        Sel    => MuxD
    );
    
    INST_ADDR_MUX : entity work.MemMuxB
    generic map(
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        ADDR   => IMEM_ADDR,
        LBUB   => IMEM_LBUB,
        
        A_ADDR => ICTRL_ADDR,
        A_LBUB => ICTRL_LBUB,
        
        B_ADDR => SCU_ADDR,
        B_LBUB => SCU_LBUB,
        
        Sel    => MuxI
    );
    
    DATA_ADDR_MUX : entity work.MemMuxB
    generic map(
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        ADDR   => DMEM_ADDR,
        LBUB   => DMEM_LBUB,
        
        A_ADDR => DCTRL_ADDR,
        A_LBUB => DCTRL_LBUB,
        
        B_ADDR => SCU_ADDR,
        B_LBUB => SCU_LBUB,
        
        Sel    => MuxD
    );
    
end Behavioral;

