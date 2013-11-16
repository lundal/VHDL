library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use work.constants.all;

entity pc is
    port ( 
        -- Control signals
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        disable : in  STD_LOGIC;

        -- Ins
        pc_in : in std_logic_vector(ADDR_WIDTH-1 downto 0);

        -- Outs
        pc_out : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0)
    );
end pc;

architecture Behavioral of pc is

begin

    process (clk, reset, disable, pc_in)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pc_out <= (others => '0');
            elsif disable = '0' then
                pc_out <= pc_in;
            end if;
        end if;
    end process;

end Behavioral;

