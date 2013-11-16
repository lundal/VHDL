library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use work.constants.all;

entity pc is
    generic (
        START_ADDR : natural
    );
    port ( 
        -- Control signals
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        disable : in  STD_LOGIC;

        -- Ins
        pc_in : in STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);

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
                pc_out <= STD_LOGIC_VECTOR(TO_UNSIGNED(START_ADDR, ADDR_WIDTH));
            elsif disable = '0' then
                pc_out <= pc_in;
            end if;
        end if;
    end process;

end Behavioral;

