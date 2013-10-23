library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.constants.all;


entity fitness_core_genetic_controller is
    port(
        fitness_in : std_logic_vector(DATA_WIDTH-1 downto 0);
        gene_in : std_logic_vector(DATA_WIDTH-1 downto 0);
        
        gene_out : std_logic_vector(DATA_WIDTH-1 downto 0);
        halt_out : std_logic;
    );
end fitness_core_genetic_controller;


architecture behavioral of fitness_core_genetic_controller is
begin
end behavioral;