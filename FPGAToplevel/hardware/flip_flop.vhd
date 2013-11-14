library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity flip_flop is
    generic (N : NATURAL := 64);
    Port ( clk : in STD_LOGIC;
           reset: in STD_LOGIC;
           enable : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (N-1 downto 0));
end flip_flop;

architecture Behavioral of flip_flop is

begin

    FLIP_FLOP : process (clk, reset, enable, data_in)
    begin 
        if reset = '1' then 
            data_out <= (others => '0');
        elsif rising_edge(clk) then 
            if enable = '0' then 				--React on deasserted signal
                data_out <= data_in;
            end if;
        end if;
        
    end process FLIP_FLOP;

end Behavioral;

