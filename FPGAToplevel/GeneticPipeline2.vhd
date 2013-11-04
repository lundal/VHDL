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
        NUM_PROC     : natural := 4;
        ADDR_WIDTH   : natural := 9;
        DATA_WIDTH   : natural := 64;
        RANDOM_WIDTH : natural := 32
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
    
    component RatedController is
        generic (
            NUM_PROC   : natural := 4
        );
        port (
            REQUEST_SET  : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            REQUEST_PROC : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            REQUEST_GENE : in  STD_LOGIC;
            ACK_PROC     : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            ACK_GENE     : out STD_LOGIC;
            STORE        : out STD_LOGIC;
            WRITE_FIT    : out STD_LOGIC;
            WRITE_GENE   : out STD_LOGIC;
            WRITE_SET    : out STD_LOGIC;
            CLK	         : in  STD_LOGIC
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
    
    component SelectionCore2 is
        generic(
            ADDR_SIZE    : natural := 9;
            DATA_SIZE    : natural := 64;
            RANDOM_SIZE  : natural := 32;
            COUNTER_SIZE : natural := 4
        );
        port(
            ADDR   : out STD_LOGIC_VECTOR(ADDR_SIZE-1 downto 0);
            RANDOM : in  STD_LOGIC_VECTOR(RANDOM_SIZE-1 downto 0);
            DATA   : in  STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
            BEST   : out STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
            NUMBER : in  STD_LOGIC_VECTOR(COUNTER_SIZE-1 downto 0);
            ENABLE : in  STD_LOGIC;
            DONE   : out STD_LOGIC;
            CLK    : in  STD_LOGIC
        );
    end component;
    
    -- Constants
    constant settings_width_selection : integer := 5;
    constant settings_width_crossover : integer := 5;
    constant settings_width_mutation  : integer := 5;
    
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
    signal request_rated_set    : STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
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
    signal settings           : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal settings_gene_ctrl : STD_LOGIC;
    signal settings_selection : STD_LOGIC_VECTOR(settings_width_selection-1 downto 0);
    signal settings_crossover : STD_LOGIC_VECTOR(settings_width_crossover-1 downto 0);
    signal settings_mutation  : STD_LOGIC_VECTOR(settings_width_mutation-1 downto 0);
    signal settings_we        : STD_LOGIC;
    
    -- Gene signals
    signal parent_0 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal parent_1 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal child_0  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal child_1  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    
    -- Others
    signal random : STD_LOGIC_VECTOR(RANDOM_WIDTH-1 downto 0);
    
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
    
    RATED_CTRL : RatedController
    generic map (
        NUM_PROC => NUM_PROC
    )
    port map (
        REQUEST_SET  => request_rated_set,
        REQUEST_PROC => request_rated_proc,
        REQUEST_GENE => request_rated_gene,
        ACK_PROC     => ack_rated_proc,
        ACK_GENE     => ack_rated_gene,
        STORE        => rated_store,
        WRITE_FIT    => rated_a_we,
        WRITE_GENE   => rated_b_we,
        WRITE_SET    => settings_we,
        CLK	         => CLK
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
    
    SELECTOR_0 : SelectionCore2
    generic map (
        ADDR_SIZE    => ADDR_WIDTH,
        DATA_SIZE    => DATA_WIDTH,
        RANDOM_SIZE  => RANDOM_WIDTH,
        COUNTER_SIZE => settings_width_selection
    )
    port map (
        ADDR   => rated_a_addr,
        RANDOM => random,
        DATA   => rated_a_out,
        BEST   => parent_0,
        NUMBER => settings_selection,
        ENABLE => selector_0_run,
        DONE   => selector_0_done,
        CLK    => CLK
    );
    
    SELECTOR_1 : SelectionCore2
    generic map (
        ADDR_SIZE    => ADDR_WIDTH,
        DATA_SIZE    => DATA_WIDTH,
        RANDOM_SIZE  => RANDOM_WIDTH,
        COUNTER_SIZE => settings_width_selection
    )
    port map (
        ADDR   => rated_b_addr,
        RANDOM => random,
        DATA   => rated_b_out,
        BEST   => parent_1,
        NUMBER => settings_selection,
        ENABLE => selector_1_run,
        DONE   => selector_1_done,
        CLK    => CLK
    );
    
    FF_SETTINGS : process(CLK, DATA_IN, settings_we)
    begin
        if rising_edge(CLK) and settings_we = '1' then
            settings <= DATA_IN;
        end if;
    end process;
    
    -- Decode settings signal (TODO)
    settings_gene_ctrl <= settings(DATA_WIDTH-1);
    settings_mutation  <= settings(settings_width_mutation - 1 downto 0);
    settings_crossover <= settings(settings_width_crossover + settings_width_mutation - 1 downto settings_width_mutation);
    settings_selection <= settings(settings_width_selection + settings_width_crossover + settings_width_mutation - 1 downto settings_width_crossover + settings_width_mutation);
    
    -- Decode request signals
    request_unrated_proc <= not REQUEST_0 and     REQUEST_1; -- 01
    request_rated_proc   <=     REQUEST_0 and not REQUEST_1; -- 10
    request_rated_set    <=     REQUEST_0 and     REQUEST_1; -- 11
    
    -- Combine ack signals
    ACK <= ack_rated_proc or ack_unrated_proc;
    
end Behavioral;

