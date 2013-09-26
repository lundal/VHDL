library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity selection_core is
    generic ( N : NATURAL;
              FITNESS_LENGTH : NATURAL;
              RATED_POOL_ADDR_BUS : NATURAL;
              RANDOM_NUMBER_LENGHT : NATURAL
    );
    Port ( clk              : in STD_LOGIC;
           selection_enable : in STD_LOGIC;
           random_number    : in  STD_LOGIC_VECTOR (31 downto 0);
           data_in          : in STD_LOGIC_VECTOR (N-1 downto 0);
           rated_pool_addr  : out STD_LOGIC_VECTOR (RATED_POOL_ADDR_BUS-1 downto 0);
           best_chromosome  : out STD_LOGIC_VECTOR (N-1 downto 0); 
           crossover_enable : out STD_LOGIC
    
    );
end selection_core;

architecture Behavioral of selection_core is



-- Used for registers internally in the core 
component flip_flop 
    generic(N : NATURAL);
    Port ( clk      : in std_logic;
           reset    : in std_logic;
           enable   : in std_logic;
           data_in  : in std_logic_vector(N-1 downto 0);
           data_out : in std_logic_vector(N-1 downto 0)
    );
end component flip_flop;


-- Used to compare fitness values
component comparator 
    generic(N : NATURAL);
    Port ( in0 : in std_logic_vector(N-1 downto 0);
           in1 : in std_logic_vector(N-1 downto 0);
           output_signal : out std_logic_vector(1 downto 0)   
    );
end component comparator;

--Signals
signal random_address : std_logic_vector(N-1 downto 0);
signal data : std_logic_vector(N-1 downto 0);
signal best_fitness : std_logic_vector (N-1 downto 0);

--Control signals
signal request_memory_access_signal : std_logic;
signal update_fitness : std_logic;
signal comparision_signal : std_logic_vector(1 downto 0);
signal update_chromosome : std_logic;
signal work_on_fitness : std_logic;
signal work_on_chromosome: std_logic;

--misc 
signal ground_signal    : std_logic;

begin


COMPARISON_UNIT : comparator
generic map (N => 16)
port map(in0 => best_fitness, 
         in1 => data, 
         signal_out => comparison_signal
         );

RANDOM_ADDRESS : flip_flop 
generic map (N => 64) --dunno address size yet
port map (clk => clk, 
          reset => reset,
          enable => request_memory_access, 
          data_in => random_address,
          data_out => rated_pool_address);         


DATA : flip_flop
generic map (N => 64)
port map (clk => clk, 
           reset => reset, 
           enable => fitness_propagate,
           data_in => chromosome_in, 
           data_out => compare_fitness_signal);
           
                       
           
BEST_CHROMOSOME : flip_flop 
generic map(N => 64)
port map (clk => clk,
          reset => reset,
          enable => update_chromosome, 
          data_in => data, 
          data_out => best_chromosome);
          
          

BEST_FITNESS : flip_flop 
generic map(N => 16)
port map (clk => clk, 
           reset => reset, 
           enable => update_fitness, 
           data_in => compare_fitness_signal, 
           data_out => best_fitness);

 



PREPARE_ADDR : process (random_number) 
begin 
    --Modify address to fit memory (Even numbers)
    random_address <= random_number(10 downto 0); -- Dunno size yet
    if random_address(0) = '1' then 
        --Sett appropiate signals
    elsif random_address(0) = '0' then 
        --Sett appropiate signal
    end if;
    
end process SLICER;




end Behavioral;
