library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use work.constants.all;

entity IF_ID is
    port ( 
        -- Control signals
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        disable : in  STD_LOGIC;

        -- Ins
        pc_in : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        instruction_in : in  STD_LOGIC_VECTOR (INST_WIDTH-1 downto 0);

        -- Outs
        pc_out : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        instruction_out : out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0)
    );
end IF_ID;


architecture behavioral of IF_ID is
begin
    
    process (clk, reset, disable, pc_in, instruction_in)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pc_out <= (others => '0');
				instruction_out <= (others => '0');
            elsif disable = '0' then
                pc_out <= pc_in;
                instruction_out <= instruction_in;
            end if;
        end if;
    end process;
    
end behavioral;
