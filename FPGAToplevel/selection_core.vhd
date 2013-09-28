library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity selection_core is
    generic ( N : integer := 64;
              FITNESS_LENGTH : integer := 64;
              RATED_POOL_ADDR_BUS : integer := 16
    );
    Port ( clk              		: in STD_LOGIC;
           reset				    : in STD_LOGIC;
		   selection_core_enable    : in STD_LOGIC;
           random_number    		: in  STD_LOGIC_VECTOR (31 downto 0);
           data_in          		: in STD_LOGIC_VECTOR (N-1 downto 0);
           rated_pool_addr  		: out STD_LOGIC_VECTOR (RATED_POOL_ADDR_BUS-1 downto 0);
           best_chromosome  		: out STD_LOGIC_VECTOR (N-1 downto 0); 
           crossover_enable 		: out STD_LOGIC
    
    );
end selection_core;

architecture Behavioral of selection_core is

--Control unit
component selection_core_control 
	Port ( clk 					  		: in  std_logic;
			 reset 				  		: in  std_logic;
			 selection_core_enable 	    : in  std_logic;
			 comparator_signal  		: in  std_logic_vector(1 downto 0);
			 update_fitness     		: out std_logic;
			 update_chromosome  		: out std_logic;
			 propagate_data     		: out std_logic;
			 request_memory     		: out std_logic;
			 increment_addr     		: out std_logic;
             fetch_fitness              : out std_logic;
             fetch_chromosome           : out std_logic
   );
end component selection_core_control;


-- Used for registers internally in the core 
component flip_flop 
    generic(N : NATURAL);
    Port ( clk      : in std_logic;
           reset    : in std_logic;
           enable   : in std_logic;
           data_in  : in std_logic_vector(N-1 downto 0);
           data_out : out std_logic_vector(N-1 downto 0)
    );
end component flip_flop;


-- Used to compare fitness values
component comparator 
    generic(N : NATURAL);
    Port ( in0 			 : in std_logic_vector(N-1 downto 0);
           in1           : in std_logic_vector(N-1 downto 0);
           signal_out    : out std_logic_vector(1 downto 0)   
    );
end component comparator;

--Signals
signal rated_pool_addr_internal : std_logic_vector(RATED_POOL_ADDR_BUS-1 downto 0);
signal random_address 		    : std_logic_vector(RATED_POOL_ADDR_BUS-1 downto 0);
signal data           		    : std_logic_vector(N-1 downto 0);
signal best_fitness   	        : std_logic_vector(N-1 downto 0);
signal best_chromosome_internal	: std_logic_vector(N-1 downto 0);


--Control signals
signal request_memory 		: std_logic;
signal update_fitness 		: std_logic;
signal comparison_signal 	: std_logic_vector(1 downto 0);
signal update_chromosome 	: std_logic;
signal propagate_data 		: std_logic;
signal increment_addr 		: std_logic;
signal fetch_fitness        : std_logic;
signal fetch_chromosome     : std_logic;

--misc 
signal ground_signal    	: std_logic;

begin

CONTROL_UNIT : selection_core_control 
port map ( clk =>  clk, 
			  reset => reset, 
			  selection_core_enable => selection_core_enable,
			  comparator_signal => comparison_signal, 
			  update_fitness => update_fitness, 
			  update_chromosome =>update_chromosome, 
			  propagate_data => propagate_data, 
			  request_memory => request_memory, 
			  increment_addr => increment_addr, 
              fetch_fitness => fetch_fitness,
              fetch_chromosome => fetch_chromosome
			  );


COMPARISON_UNIT : comparator
generic map (N => 64)
port map(in0 => best_fitness, 
         in1 => data, 
         signal_out => comparison_signal
         );

--Place holder for the random addres 
RANDOM_ADDRESS_STORAGE : flip_flop 
generic map (N => 16) --dunno address size yet
port map (clk => clk, 
          reset => reset,
          enable => request_memory, 
          data_in => random_address,
          data_out => rated_pool_addr_internal);         

--Place holder for inncomming data
INCOMMING_DATA_STORAGE : flip_flop
generic map (N => 64)
port map (clk => clk, 
          reset => reset, 
          enable => propagate_data,
          data_in => data_in, 
          data_out => data);
           
                       
--Place holder for the best chromosome           
BEST_CHROMOSOME_STORAGE : flip_flop 
generic map(N => 64)
port map (clk => clk,
          reset => reset,
          enable => update_chromosome, 
          data_in => data, 
          data_out => best_chromosome_internal);
          
          
--Placeh holder for the best fitness value
BEST_FITNESS_STORAGE : flip_flop 
generic map(N => 64)
port map (clk => clk, 
           reset => reset, 
           enable => update_fitness, 
           data_in => data, 
           data_out => best_fitness);


PREPARE_ADDR_PROCESS : process (random_number, random_address) 
begin 
    --Modify address to fit memory
    random_address <= random_number(RATED_POOL_ADDR_BUS-1 downto 0);
    
	 if random_address(0) = '1' then 
        --Sett appropiate signals
    elsif random_address(0) = '0' then 
        --Sett appropiate signal
    end if;
    
end process PREPARE_ADDR_PROCESS;

RUN_SELECTION_CORE : process(selection_core_enable) 
begin 
	 if selection_core_enable = '1' then 
            rated_pool_addr <= rated_pool_addr_internal; 
     end if;
     
end process RUN_SELECTION_CORE;

end Behavioral;
