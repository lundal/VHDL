----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-03 11:51
-- Tested:   Never
--
-- Description:
-- TODO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GeneticPipeline2 is
    generic (
        NUM_PROC   : natural := 4;
        ADDR_WIDTH : natural := 9;
        DATA_WIDTH : natural := 64
    );
    port (
        REQUEST_0 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        REQUEST_1 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        ACK       : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        DATA_IN   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        DATA_OUT  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        CLK	      : in  STD_LOGIC
    );
end GeneticPipeline2;

architecture Behavioral of GeneticPipeline2 is
    
    component BRAM_TDP_WIDE is
        generic (
            ADDR_WIDTH : natural := 9;
            DATA_WIDTH : natural := 64;
            WRITE_MODE : string	:= "WRITE_FIRST"
        );
        port (
            A_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            A_IN   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            A_OUT  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            A_WE   : in  STD_LOGIC;
            A_EN   : in  STD_LOGIC;
            B_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            B_IN   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            B_OUT  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            B_WE   : in  STD_LOGIC;
            B_EN   : in  STD_LOGIC;
            CLK	   : in  STD_LOGIC
        );
    end component;
    
    component Distributor is
        generic (
            ADDR_WIDTH : natural := 9
        );
        port (
            ADDR_A : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            ADDR_B : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            STORE  : in  STD_LOGIC
        );
    end component;
    
    component GeneticController is
        port (
            RATED_RQ    : out STD_LOGIC;
            RATED_ACK   : in  STD_LOGIC;
            UNRATED_RQ  : out STD_LOGIC;
            UNRATED_ACK : in  STD_LOGIC;
            SEL_0_RUN   : out STD_LOGIC;
            SEL_0_DONE  : in  STD_LOGIC;
            SEL_1_RUN   : out STD_LOGIC;
            SEL_1_DONE  : in  STD_LOGIC;
            STORE       : out STD_LOGIC;
            ENABLE      : in  STD_LOGIC;
            CLK	        : in  STD_LOGIC
        );
    end component;
    
    component UnratedController is
        generic (
            NUM_PROC   : natural := 4;
            ADDR_WIDTH : natural := 9
        );
        port (
            REQUEST_PROC : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            REQUEST_GENE : in  STD_LOGIC;
            ACK_PROC     : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            ACK_GENE     : out STD_LOGIC;
            ADDR         : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            CLK	         : in  STD_LOGIC
        );
    end component;
    
    -- Rated Pool signals
    signal rated_a_addr : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_a_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_a_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_a_we   : STD_LOGIC;
    signal rated_b_addr : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_b_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_b_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_b_we   : STD_LOGIC;
    
    -- Unrated Pool signals
    signal unrated_a_addr : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_a_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_a_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_a_we   : STD_LOGIC;
    signal unrated_b_addr : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_b_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_b_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_b_we   : STD_LOGIC;
    
    -- Distributor signals
    signal rated_store   : STD_LOGIC := '0';
    signal unrated_store : STD_LOGIC := '0';
    
    -- Request/Ack signals
    signal request_unrated_proc : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal request_unrated_gene : STD_LOGIC;
    signal request_rated_proc   : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal request_rated_gene   : STD_LOGIC;
    signal ack_unrated_proc     : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal ack_unrated_gene     : STD_LOGIC;
    signal ack_rated_proc       : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
    signal ack_rated_gene       : STD_LOGIC;
    
    -- Selection Core signals
    signal selector_0_run  : STD_LOGIC;
    signal selector_0_done : STD_LOGIC;
    signal selector_1_run  : STD_LOGIC;
    signal selector_1_done : STD_LOGIC;
    
    -- Settings signals
    signal settings_gene_ctrl : STD_LOGIC;
    signal settings_selector  : STD_LOGIC;
    signal settings_crossover : STD_LOGIC;
    signal settings_mutation  : STD_LOGIC;
    
begin
    
    RATED_POOL : BRAM_TDP_WIDE
    generic map(
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH,
        WRITE_MODE => "WRITE_FIRST"
    )
    port map(
        A_ADDR => rated_a_addr,
        A_IN   => rated_a_in,
        A_OUT  => rated_a_out,
        A_WE   => rated_a_we,
        A_EN   => '1',
        B_ADDR => rated_b_addr,
        B_IN   => rated_b_in,
        B_OUT  => rated_b_out,
        B_WE   => rated_b_we,
        B_EN   => '1',
        CLK	   => CLK
    );

    UNRATED_POOL : BRAM_TDP_WIDE
    generic map(
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH,
        WRITE_MODE => "WRITE_FIRST"
    )
    port map(
        A_ADDR => unrated_a_addr,
        A_IN   => unrated_a_in,
        A_OUT  => unrated_a_out,
        A_WE   => unrated_a_we,
        A_EN   => '1',
        B_ADDR => unrated_b_addr,
        B_IN   => unrated_b_in,
        B_OUT  => unrated_b_out,
        B_WE   => unrated_b_we,
        B_EN   => '1',
        CLK	   => CLK
    );
    
    DIST_RATED : Distributor
    generic map(
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        ADDR_A => rated_a_addr,
        ADDR_B => rated_b_addr,
        STORE  => rated_store
    );
    
    DIST_UNRATED : Distributor
    generic map(
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        ADDR_A => unrated_a_addr,
        ADDR_B => unrated_b_addr,
        STORE  => unrated_store
    );
    
    GENE_CTRL : GeneticController
    port map (
        RATED_RQ    => request_rated_gene,
        RATED_ACK   => ack_rated_gene,
        UNRATED_RQ  => request_unrated_gene,
        UNRATED_ACK => ack_unrated_gene,
        SEL_0_RUN   => selector_0_run,
        SEL_0_DONE  => selector_0_done,
        SEL_1_RUN   => selector_1_run,
        SEL_1_DONE  => selector_1_done,
        STORE       => unrated_store,
        ENABLE      => settings_gene_ctrl,
        CLK	        => CLK
    );
    
    UNRATED_CTRL : UnratedController
    generic map (
        NUM_PROC   => NUM_PROC,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map (
        REQUEST_PROC => request_unrated_proc,
        REQUEST_GENE => request_unrated_gene,
        ACK_PROC     => ack_unrated_proc,
        ACK_GENE     => ack_unrated_gene,
        ADDR         => unrated_a_addr,
        CLK	         => CLK
    );
    
end Behavioral;

