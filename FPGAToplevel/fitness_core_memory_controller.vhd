library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

entity fitness_core_memory_controller is
    port (
        addr_in : in std_logic_vector(FITNESS_CORE_MEMORY_CONTROLLER_ADDR_WIDTH-1 downto 0);
        data_in : in std_logic_vector(FITNESS_CORE_MEMORY_CONTROLLER_ADDR_WIDTH-1 downto 0);
        mem_op_in : in std_logic;
        
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
        halt_out : out std_logic
    );
end fitness_core_memory_controller;


architecture behavioral of fitness_core_memory_controller is
begin
end behavioral;

