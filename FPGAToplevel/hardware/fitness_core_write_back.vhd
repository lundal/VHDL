library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fitness_core_write_back is
    port(
        to_register_in : in std_logic_vector(x downto 0);
        call_in : in std_logic;
        gene_out : in std_logic_vector(DATA_WIDTH-1 downto 0);
        res : in std_logic_vector(DATA_WIDTH-1 downto 0);
        pc_incremented : in std_logic_vector(INST_WIDTH-1 downto 0);
        data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        
        wbb_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
        wba_out : out std_logic_vector(REG_ADDR_WIDTH-1 downto 0)
    );
end fitness_core_write_back;


architecture behavioral of fitness_core_write_back is
begin
end behavioral;

