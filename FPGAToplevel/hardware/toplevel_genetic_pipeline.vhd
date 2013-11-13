----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:20 09/26/2013 
-- Design Name: 
-- Module Name:    toplevel_genetic_pipeline - Behavioral 
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

entity toplevel_genetic_pipeline is
    generic ( N : integer := 64;
              RATED_POOL_ADDR_BUS : integer := 16
    );
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           genetic_pipeline_enable : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (N-1 downto 0);
           rated_pool_addr : out  STD_LOGIC_VECTOR (RATED_POOL_ADDR_BUS-1 downto 0));
end toplevel_genetic_pipeline;

architecture Behavioral of toplevel_genetic_pipeline is

component PRNG 
    port (clk       : in std_logic;
          reset     : in std_logic;
          load      : in std_logic;
          seed      : in std_logic_vector (31 downto 0);
          rnd_out   : out std_logic_vector (31 downto 0)
    );
end component PRNG;   
    
component selection_core 
    port (clk : in std_logic;
          reset : in std_logic;
          selection_core_enable : in std_logic;
          random_number : in std_logic_vector(31 downto 0);
          data_in : in std_logic_vector (N-1 downto 0);
          rated_pool_addr : out std_logic_vector(RATED_POOL_ADDR_BUS-1 downto 0);
          best_chromosome : out std_logic_vector (N-1 downto 0);
          crossover_enable : out std_logic
   );
end component selection_core;

--Signals 
signal random_number               : std_logic_vector(31 downto 0); 
signal random_seed                 : std_logic_vector(31 downto 0) := (others => '0');
signal rated_pool_addr_internal    : std_logic_vector(RATED_POOL_ADDR_BUS-1 downto 0);
signal best_chromosome_internal    : std_logic_vector(N-1 downto 0);

--Control signals
signal load : std_logic := '0';
signal selection_core_enable : std_logic;
signal crossover_enable : std_logic;


begin

PRNG_UNIT : PRNG 
    port map (clk => clk,
              reset => reset , 
              load => load, 
              seed => random_seed, 
              rnd_out => random_number
              );

SELECTION_CORE_UNIT : selection_core 
    port map ( clk => clk, 
               reset => reset, 
               selection_core_enable => genetic_pipeline_enable, 
               random_number => random_number, 
               data_in => data_in, 
               rated_pool_addr => rated_pool_addr_internal, 
               best_chromosome => best_chromosome_internal, 
               crossover_enable => crossover_enable
                
    );



--Connect output signals
RUN : process (rated_pool_addr_internal) 
begin 
    rated_pool_addr <= rated_pool_addr_internal;
end process RUN;



end Behavioral;

