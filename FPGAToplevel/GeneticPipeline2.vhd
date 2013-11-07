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
        RESET     : in  STD_LOGIC;
        CLK       : in  STD_LOGIC
    );
    -- Assign clock signal
    attribute CLOCK_SIGNAL : string;
    attribute CLOCK_SIGNAL of CLK : signal is "yes";
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
    
    component Incrementer is
        generic (
            NUM_WIDTH : natural := 4
        );
        port (
            NUM       : out STD_LOGIC_VECTOR(NUM_WIDTH-1 downto 0);
            INCREMENT : in  STD_LOGIC
        );
    end component;
    
    component IncrementerDouble is
        generic (
            NUM_WIDTH : natural := 4
        );
        port (
            NUM_A     : out STD_LOGIC_VECTOR(NUM_WIDTH-1 downto 0);
            NUM_B     : out STD_LOGIC_VECTOR(NUM_WIDTH-1 downto 0);
            INCREMENT : in  STD_LOGIC
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
            INCREMENT    : out STD_LOGIC;
            WRITE_FIT    : out STD_LOGIC;
            WRITE_GENE   : out STD_LOGIC;
            WRITE_SET    : out STD_LOGIC;
            CLK	         : in  STD_LOGIC
        );
    end component;
    
    component UnratedController is
        generic (
            NUM_PROC   : natural := 4
        );
        port (
            REQUEST_PROC : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            REQUEST_GENE : in  STD_LOGIC;
            ACK_PROC     : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
            ACK_GENE     : out STD_LOGIC;
            INCREMENT    : out STD_LOGIC;
            CLK	         : in  STD_LOGIC
        );
    end component;
    
    component SelectionCore2 is
        generic(
            ADDR_SIZE    : natural := 9;
            DATA_SIZE    : natural := 64;
            COUNTER_SIZE : natural := 4
        );
        port(
            ADDR   : out STD_LOGIC_VECTOR(ADDR_SIZE-1 downto 0);
            RANDOM : in  STD_LOGIC_VECTOR(ADDR_SIZE-2 downto 0);
            DATA   : in  STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
            BEST   : out STD_LOGIC_VECTOR(DATA_SIZE-1 downto 0);
            NUMBER : in  STD_LOGIC_VECTOR(COUNTER_SIZE-1 downto 0);
            ENABLE : in  STD_LOGIC;
            DONE   : out STD_LOGIC;
            CLK    : in  STD_LOGIC
        );
    end component;
    
    component crossover_toplevel is
        generic (
            N : integer := 64
        );
        port (
        control_input : in  STD_LOGIC_VECTOR(3-1 downto 0);
        random_number : in  STD_LOGIC_VECTOR(N-1 downto 0);
        parent1       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        parent2       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        child1        : out STD_LOGIC_VECTOR(N-1 downto 0);
        child2        : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
    end component;
    
    component mutation_core is
        generic (
            N : integer :=64;
            P : integer :=6
        );
        port (
            random_number : in  STD_LOGIC_VECTOR(P+26-1 downto 0);
            chance_input  : in  STD_LOGIC_VECTOR(P-1 downto 0);
            input  : in  STD_LOGIC_VECTOR(N-1 downto 0);
            output : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    component PRNG is
        generic (
            WIDTH : integer := 32
        );
        port (
           RANDOM : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           CLK    : in  STD_LOGIC
        );
    end component;
    
    -- Constants
    constant settings_width_selection : integer := 5;
    constant settings_width_crossover : integer := 3;
    constant settings_width_mutation  : integer := 8;
    
    -- Rated Pool signals
    signal rated_a_addr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal rated_a_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_a_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_a_we   : STD_LOGIC;
    signal rated_b_addr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal rated_b_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_b_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal rated_b_we   : STD_LOGIC;
    
    -- Unrated Pool signals
    signal unrated_a_addr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal unrated_a_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_a_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_a_we   : STD_LOGIC;
    signal unrated_b_addr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal unrated_b_in   : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_b_out  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal unrated_b_we   : STD_LOGIC;
    
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
    signal selector_0_addr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal selector_0_run  : STD_LOGIC;
    signal selector_0_done : STD_LOGIC;
    signal selector_1_addr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal selector_1_run  : STD_LOGIC;
    signal selector_1_done : STD_LOGIC;
    
    -- Settings signals
    signal settings           : STD_LOGIC_VECTOR(settings_width_selection + settings_width_crossover + settings_width_mutation downto 0) := (others => '0');
    signal settings_mutation  : STD_LOGIC_VECTOR(settings_width_mutation-1 downto 0);
    signal settings_crossover : STD_LOGIC_VECTOR(settings_width_crossover-1 downto 0);
    signal settings_selection : STD_LOGIC_VECTOR(settings_width_selection-1 downto 0);
    signal settings_gene_ctrl : STD_LOGIC;
    signal settings_we        : STD_LOGIC;
    
    -- Gene signals
    signal parent_0 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal parent_1 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal child_0  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal child_1  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    
    -- Random
    signal random             : STD_LOGIC_VECTOR(RANDOM_WIDTH-1 downto 0) := (others => '0');
    signal random_prev        : STD_LOGIC_VECTOR(RANDOM_WIDTH-1 downto 0) := (others => '0');
    signal random_extended    : STD_LOGIC_VECTOR(RANDOM_WIDTH*2-1 downto 0);
    signal random_selection_0 : STD_LOGIC_VECTOR(ADDR_WIDTH-2 downto 0);
    signal random_selection_1 : STD_LOGIC_VECTOR(ADDR_WIDTH-2 downto 0);
    
    -- Incrementer signals
    signal inc_gene      : STD_LOGIC := '0';
    signal inc_gene_a    : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal inc_gene_b    : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal inc_rated_ctrl: STD_LOGIC := '0';
    signal inc_rated     : STD_LOGIC := '0';
    signal inc_rated_a   : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal inc_rated_b   : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal inc_unrated   : STD_LOGIC := '0';
    signal inc_unrated_a : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    
    -- Mutation signals
    signal mutator_0_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal mutator_1_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    
    -- Write signals
    signal write_rated_0 : STD_LOGIC := '0';
    signal write_rated_1 : STD_LOGIC := '0';
    signal write_genetic : STD_LOGIC := '0';
    
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
    
    INCREMENTER_GENE : IncrementerDouble
    generic map(
        NUM_WIDTH => ADDR_WIDTH
    )
    port map(
        NUM_A     => inc_gene_a,
        NUM_B     => inc_gene_b,
        INCREMENT => inc_gene
    );
    
    INCREMENTER_RATED : IncrementerDouble
    generic map(
        NUM_WIDTH => ADDR_WIDTH
    )
    port map(
        NUM_A     => inc_rated_a,
        NUM_B     => inc_rated_b,
        INCREMENT => inc_rated
    );
    
    INCREMENTER_UNRATED : Incrementer
    generic map(
        NUM_WIDTH => ADDR_WIDTH
    )
    port map(
        NUM       => inc_unrated_a,
        INCREMENT => inc_unrated
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
        STORE       => write_genetic,
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
        INCREMENT    => inc_rated_ctrl,
        WRITE_FIT    => write_rated_0,
        WRITE_GENE   => write_rated_1,
        WRITE_SET    => settings_we,
        CLK	         => CLK
    );
    
    UNRATED_CTRL : UnratedController
    generic map (
        NUM_PROC   => NUM_PROC
    )
    port map (
        REQUEST_PROC => request_unrated_proc,
        REQUEST_GENE => request_unrated_gene,
        ACK_PROC     => ack_unrated_proc,
        ACK_GENE     => ack_unrated_gene,
        INCREMENT    => inc_unrated,
        CLK	         => CLK
    );
    
    SELECTOR_0 : SelectionCore2
    generic map (
        ADDR_SIZE    => ADDR_WIDTH,
        DATA_SIZE    => DATA_WIDTH,
        COUNTER_SIZE => settings_width_selection
    )
    port map (
        ADDR   => selector_0_addr,
        RANDOM => random_selection_0,
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
        COUNTER_SIZE => settings_width_selection
    )
    port map (
        ADDR   => selector_1_addr,
        RANDOM => random_selection_1,
        DATA   => rated_b_out,
        BEST   => parent_1,
        NUMBER => settings_selection,
        ENABLE => selector_1_run,
        DONE   => selector_1_done,
        CLK    => CLK
    );
    
    CROSSOVER : crossover_toplevel
    generic map (
        N => DATA_WIDTH
    )
    port map (
        control_input => settings_crossover,
        random_number => random_extended,
        parent1       => parent_0,
        parent2       => parent_1,
        child1        => child_0,
        child2        => child_1
    );
    
    MUTATOR_0 : mutation_core
    generic map (
        N => DATA_WIDTH,
        P => settings_width_mutation
    )
    port map (
        random_number => random_extended(settings_width_mutation+26-1 downto 0),
        chance_input  => settings_mutation,
        input         => child_0,
        output        => mutator_0_out
    );
    
    MUTATOR_1 : mutation_core
    generic map (
        N => DATA_WIDTH,
        P => settings_width_mutation
    )
    port map (
        random_number => random_extended(settings_width_mutation+26-1 downto 0),
        chance_input  => settings_mutation,
        input         => child_1,
        output        => mutator_1_out
    );
    
    PRNG_UNIT : PRNG
    generic map (
        WIDTH => RANDOM_WIDTH
    )
    port map (
       RANDOM => random,
       CLK    => CLK
    );
    
    FF_SETTINGS : process(CLK, RESET, DATA_IN, settings_we)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                settings <= (others => '0');
            elsif settings_we = '1' then
                settings <= DATA_IN(settings_width_selection + settings_width_crossover + settings_width_mutation downto 0);
            end if;
        end if;
    end process;
    
    FF_RANDOM : process(CLK, random)
    begin
        if rising_edge(CLK) then
            random_prev <= random;
        end if;
    end process;
    
    -- Map randoms
    random_extended <= random & random_prev;
    random_selection_0 <= random_extended(ADDR_WIDTH*1-2 downto 0);
    random_selection_1 <= random_extended(ADDR_WIDTH*2-2 downto ADDR_WIDTH);
    
    -- Decode settings signal
    settings_mutation  <= settings(settings_width_mutation - 1 downto 0);
    settings_crossover <= settings(settings_width_crossover + settings_width_mutation - 1 downto settings_width_mutation);
    settings_selection <= settings(settings_width_selection + settings_width_crossover + settings_width_mutation - 1 downto settings_width_crossover + settings_width_mutation);
    settings_gene_ctrl <= settings(settings_width_selection + settings_width_crossover + settings_width_mutation);
    
    -- Decode request signals
    request_unrated_proc <= not REQUEST_1 and     REQUEST_0; -- 01
    request_rated_proc   <=     REQUEST_1 and not REQUEST_0; -- 10
    request_rated_set    <=     REQUEST_1 and     REQUEST_0; -- 11
    
    -- Combine ack signals
    ACK <= ack_rated_proc or ack_unrated_proc;
    
    -- Map unrated write signals
    
    -- Map DATA I/O
    DATA_OUT <= unrated_a_out;
    
    
    
    RESETIFIER : process(RESET, CLK, DATA_IN, random_extended, inc_rated_ctrl, write_genetic, write_rated_0, write_rated_1, mutator_0_out, mutator_1_out)
    begin
        if (RESET = '1') then
            -- Incrementer input
            inc_rated <= CLK;
            inc_gene <= CLK;
            
            -- Pool write signals
            rated_a_we <= '1';
            rated_b_we <= '1';
            unrated_a_we <= '1';
            unrated_b_we <= '1';
            
            -- Pool data input
            rated_a_in <= random_extended;
            rated_b_in <= random_extended;
            unrated_a_in <= random_extended;
            unrated_b_in <= random_extended;
        else
            -- Incrementer input
            inc_rated <= inc_rated_ctrl;
            inc_gene <= write_genetic;
            
            -- Pool write signals
            rated_a_we <= write_rated_0;
            rated_b_we <= write_rated_1;
            unrated_a_we <= write_genetic;
            unrated_b_we <= write_genetic;
            
            -- Pool data input
            rated_a_in <= DATA_IN;
            rated_b_in <= DATA_IN;
            unrated_a_in <= mutator_0_out;
            unrated_b_in <= mutator_1_out;
        end if;
    end process;
    
    -- Pool address input
    rated_a_addr <= inc_rated_a when rated_a_we = '1' or rated_b_we = '1' else selector_0_addr;
    rated_b_addr <= inc_rated_b when rated_a_we = '1' or rated_b_we = '1' else selector_1_addr;
    unrated_a_addr <= inc_gene_a when unrated_a_we = '1' or unrated_b_we = '1' else inc_unrated_a;
    unrated_b_addr <= inc_gene_b;
    
    -- Circumvent Crossover
    --child_0 <= parent_0;
    --child_1 <= parent_1;
    
end Behavioral;

