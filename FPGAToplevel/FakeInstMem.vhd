library ieee;
use ieee.std_logic_1164.all;

entity FakeInstMem is
    port(
        IMEM_CE_HI      : in   STD_LOGIC;
        IMEM_CE_LO      : in   STD_LOGIC;
        IMEM_WE_HI      : in   STD_LOGIC;
        IMEM_WE_LO      : in   STD_LOGIC;
        IMEM_DATA_HI    : out STD_LOGIC_VECTOR(16-1 downto 0);
        IMEM_DATA_LO    : out STD_LOGIC_VECTOR(16-1 downto 0);
        IMEM_ADDR       : in   STD_LOGIC_VECTOR(19-1 downto 0);
        IMEM_LBUB       : in   STD_LOGIC;
        clk :in std_logic
    );
end FakeInstMem;

architecture behavioral of FakeInstMem is
type mem is array (0 to 12) of std_logic_vector(16-1 downto 0);

constant hi : mem := (
    0  => "1111001000000000",
    1  => "1111001000000000",
    2  => "1111010000011000",
    3  => "1111010000001000",
    4  => "1111010000010000",
    5  => "1111110000011000",
    6  => "1111110000011000",
    7  => "1111100000001000",
    8  => "1111100000010000",
    9  => "1111100000000000",
    10  => "0010001000000000",
    11  => "1111001000000000",
    12  => "0000000000000000"
);
constant lo : mem := (
    0  => "0000000000001010",
    1  => "0000000000001001",
    2  => "0000000000000000",
    3  => "0000000000000000",
    4  => "0000000000000001",
    5  => "1100000000010000",
    6  => "1100000000010000",
    7  => "0100000000100000",
    8  => "0100000000100000",
    9  => "0000000000110001",
    10  => "0000000000001101",
    11  => "0000000000010100",
    12  => "0000000000000000"
);

begin

    --process(clk)
    --begin
   

        IMEM_DATA_HI <= X"FACE";
        IMEM_DATA_LO <= X"CAFE";

    --end process;

--    process (IMEM_ADDR)
--    begin
--        case IMEM_ADDR is
--            when "0000000000000000000" =>
--                IMEM_DATA_HI <= "1111111111111111";
--                IMEM_DATA_LO <= "0000000000001111";
--            when "0000000000000000001" =>
--                IMEM_DATA_HI <= hi(1);
--                IMEM_DATA_LO <= lo(1);
--            when "0000000000000000010" =>
--                IMEM_DATA_HI <= hi(2);
--                IMEM_DATA_LO <= lo(2);
--            when "0000000000000000011" =>
--                IMEM_DATA_HI <= hi(3);
--                IMEM_DATA_LO <= lo(3);
--            when "0000000000000000100" =>
--                IMEM_DATA_HI <= hi(4);
--                IMEM_DATA_LO <= lo(4);
--            when "0000000000000000101" =>
--                IMEM_DATA_HI <= hi(5);
--                IMEM_DATA_LO <= lo(5);
--            when "0000000000000000110" =>
--                IMEM_DATA_HI <= hi(6);
--                IMEM_DATA_LO <= lo(6);
--            when "0000000000000000111" =>
--                IMEM_DATA_HI <= hi(7);
--                IMEM_DATA_LO <= lo(7);
--            when "0000000000000001000" =>
--                IMEM_DATA_HI <= hi(8);
--                IMEM_DATA_LO <= lo(8);
--            when "0000000000000001001" =>
--                IMEM_DATA_HI <= hi(9);
--                IMEM_DATA_LO <= lo(9);
--            when "0000000000000001010" =>
--                IMEM_DATA_HI <= hi(10);
--                IMEM_DATA_LO <= lo(10);
--            when "0000000000000001011" =>
--                IMEM_DATA_HI <= hi(11);
--                IMEM_DATA_LO <= lo(11);
--            when others =>
--                IMEM_DATA_HI <= "0000000000000000";
--                IMEM_DATA_LO <= "0000000000000000";
--        end case;
--    end process;
end architecture behavioral;
