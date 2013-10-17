	----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:07 10/14/2013 
-- Design Name: 
-- Module Name:    genetic_pipeline - Behavioral 
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

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity genetic_pipeline is
	generic (N : integer :=64; O : integer :=32; P : integer :=6; Q : integer := 16);
    Port (
				clk : in STD_LOGIC;
				reset : in STD_LOGIC;
				enabled : in STD_LOGIC;
				rated_pool_address1 : out STD_LOGIC_VECTOR(Q-1 downto 0);
				rated_pool_address2 : out STD_LOGIC_VECTOR(Q-1 downto 0);
				data_input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				data_input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				mutation_chance_input: in STD_LOGIC_VECTOR (P-1 downto 0);
				output1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				output2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end genetic_pipeline;

architecture Behavioral of genetic_pipeline is

	--COMPONENT RANDOM_NUMBER_GENERATOR NEEDED HERE
	component PRNG
		generic (Width : integer := 32);
		Port ( clk  : in  STD_LOGIC;
				reset : in STD_LOGIC;
				load : in STD_LOGIC;
				seed :in STD_LOGIC_VECTOR (Width-1 downto 0);
				rnd_out : out  STD_LOGIC_VECTOR (Width-1 downto 0));
	end component;
	
	
	-- Selection_core used for selecting chromosomes from rated pool
	component selection_core
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
	end component;

	--Crossover_core_advanced used for crossover from 2 parens to 2 children
	component crossover_core_advanced
		generic (N:integer :=64; O: integer :=32);
		port (
					enabled : in STD_LOGIC;
					random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
					parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
					parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
					child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
					child2 : out  STD_LOGIC_VECTOR (N-1 downto 0)
				);
	end component;

	--Mutation_core used for potentially mutating a few bits in a child
	component mutation_core
		generic (N : integer :=64; O : integer :=32; P : integer :=6);
		Port (
				enabled : in STD_LOGIC;
				random_number : in STD_LOGIC_VECTOR (O-1 downto 0);
				input : in  STD_LOGIC_VECTOR (N-1 downto 0);
				chance_input : in STD_LOGIC_VECTOR(P-1 downto 0);
				output : out  STD_LOGIC_VECTOR (N-1 downto 0));
	end component;
	
	--Signal from random_number_generator to other cores using the random number
	signal random_number : STD_LOGIC_VECTOR (O-1 downto 0);
	
	--Signals from selector_cores to crossover_cores
	signal parent1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal parent2 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal c_m_enabled1 : STD_LOGIC;
	signal c_m_enabled2 : STD_LOGIC;
	signal c_m_enabled_result : STD_LOGIC;
	
	--Signals from crossover_core to mutation_cores
	signal child1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal child2 : STD_LOGIC_VECTOR (N-1 downto 0);

begin
	
	--Insert random_number_generator instance here
	random: PRNG
			PORT MAP( 	clk => clk,
							reset => reset,
							load => enabled,
							seed => "00000000000000000000000000000000",
							rnd_out => random_number
			);
	
	
	--Instance 1 of selector_core
	selection1: selection_core
			PORT MAP (
					clk => clk,
					reset	=> reset,
					selection_core_enable => enabled,
					random_number => random_number,
					data_in => data_input1, 
					rated_pool_addr => rated_pool_address1,
					best_chromosome => parent1,
					crossover_enable => c_m_enabled1
			);
	
	--Instance 2 of selector_core
	selection2: selection_core
			PORT MAP (
					clk => clk,
					reset	=> reset,
					selection_core_enable => enabled,
					random_number => random_number,
					data_in => data_input2, 
					rated_pool_addr => rated_pool_address2,
					best_chromosome => parent2,
					crossover_enable => c_m_enabled2
			);
	
	--Combining enabled signals from selection cores
	c_m_enabled_result <= c_m_enabled1 and c_m_enabled2;
	
	--Instance of crossover_core_advanced
	crossover: crossover_core_advanced 
			PORT MAP (
          enabled => c_m_enabled_result,
          random_number => random_number, --Needs to be set to output from random_number_generator
          parent1 => parent1,
          parent2 => parent2,
          child1 => child1,
          child2 => child2
        );
	
	--Instance 1 of mutation_core, recieving child 1
	mutation1: mutation_core 
			PORT MAP(
          enabled => c_m_enabled_result,
          random_number => random_number, --Needs to be set to output from random_number_generator
			 chance_input => mutation_chance_input,
          input => child1,
          output => output1
	);

	--Instance 2 of mutation_core, recieving child 2
	mutation2: mutation_core 
			PORT MAP(
          enabled => enabled,
          random_number => random_number, --Needs to be set to output from random_number_generator
			 chance_input => mutation_chance_input,
          input => child2,
          output => output2
	);	  


end Behavioral;

