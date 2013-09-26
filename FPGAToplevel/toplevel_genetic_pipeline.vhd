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
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (63 downto 0);
           rated_pool_addr : out  STD_LOGIC_VECTOR (16 downto 0));
end toplevel_genetic_pipeline;

architecture Behavioral of toplevel_genetic_pipeline is

component PRNG 
    generic(N : NATURAL);
    port (clk       : in std_logic;
          reset     : in std_logic;
          load      : in std_logic;
          seed      : in std_logic_vector (N-1 downto 0);
          rnd_out   : out std_logic_vector (N-1 downto 0)
    );
end component PRNG;   
    
component selection_core 
    generic (N : NATURAL);
    port (clk : in std_logic;
          reset : in std_logic;
          selection_core_enable : in std_logic;
          random_number : in std_logic_vector(31 downto 0);
          data_in : in std_logic_vector (N-1 downto 0);
          rated_pool_addr : out std_logic_vector(RATED_POOL_ADDR-1 downto 0);
          best_chromosome : out std_logic_vector (N-1 downto 0);
          crossover_enable : out std_logic
   );
end component selection_core;


begin


end Behavioral;

