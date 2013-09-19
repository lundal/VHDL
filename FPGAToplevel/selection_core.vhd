----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:20:31 09/19/2013 
-- Design Name: 
-- Module Name:    selection_core - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity selection_core is
    generic ( N : NATURAL;
              FITNESS_LENGTH : NATURAL;
              RATED_POOL_ADDR_BUS : NATURAL;
              RANDOM_NUMBER_LENGHT : NATURAL
    );
    Port ( clk              : in STD_LOGIC;
           selection_enable : in STD_LOGIC;
           random_number    : in  STD_LOGIC_VECTOR (31 downto 0);
           chromosome_in    : in STD_LOGIC_VECTOR (N-1 downto 0);
           rated_pool_addr  : out STD_LOGIC_VECTOR (RATED_POOL_ADDR_BUS-1 downto 0);
           best_chromosome  : out STD_LOGIC_VECTOR (N-1 downto 0); 
           crossover_enable : out STD_LOGIC
    
    );
end selection_core;

architecture Behavioral of selection_core is


--The adder will be used to compare fitness values 
component adder 
    generic(N : NATURAL);
    Port ( A        : in std_logic_vector (N-1 downto 0); 
           B        : in std_logic_vector (N-1 downto 0);
           res      : out std_logic_vector(N-1 downto 0);
           overflow : out std_logic
    
    );
end component adder;

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


-- Signals 
signal fitness_best     : std_logic_vector(FITNESS_LENGTH-1 downto 0);
signal fitness_in       : std_logic_vector(FITNESS_LENGTH-1 downto 0);
signal chromosome1      : std_logic_vector(N-1 downto 0);

signal best_chromosome_out : std_logic_vector(N-1 downto 0) := (others => '0');
signal best_chromosome_in  : std_logic_vector(N-1 downto 0);
signal chromosome_from_pool: std_logic_vector(N-1 downto 0);

signal random_address : std_logic_vector(N-1 downto 0);


--Control signals
signal request_memory_access : std_logic;



--misc 
signal ground_signal    : std_logic;

begin


COMPARISON_UNIT : adder 
generic map (N => 16);
port map(A => best_choromosome_out, 
         B => chromosome_from_pool, 
         res => best_chromosome_in, 
         overflow => ground_signal);



          

RANDOM_ADDRESS : flip_flop 
generic map (N => 64); --dunno address size yet
port map (clk => clk, 
          reset => reset,
          enable => request_memory_access, 
          data_in => random_address,
          data_out => rated_pool_address);         

CHROMOSOME : flip_flop 
generic map (N => 64); 
port map ( clk => clk, 
           reset => reset, 
           enable =>, 
           data_in =>, 
           data_out => );
           

FITNESS : flip_flop
generic map (N => 16);
port map (clk => clk, 
           reset => reset, 
           enable => ,
           data_in =>, 
           data_out => );
           
           
BEST_CHROMOSOME : flip_flop 
generic map(N => 64);
port map (clk => clk,
          reset => reset,
          enable => , 
          data_in =>, 
          data_out =>);
          
          

BEST_FITNESS : flip_flop 
generic map(N => 16);
port map (clk => clk, 
           reset => reset, 
           enable => , 
           data_in =>, 
           data_out =>);




end Behavioral;





