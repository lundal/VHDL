library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRNG is
    generic (
        WIDTH : integer := 32
    );
    port (
       RANDOM : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       CLK    : in  STD_LOGIC
    );
end PRNG;

architecture Behavioral of PRNG is
    
    type TapsArrayType is array (2 to 32) of STD_LOGIC_VECTOR(31 downto 0);
    signal Taps : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    
begin
    
    PSEUDO_RANDOM_NUMBER_GENERATOR : process (CLK) 
        variable LFSR_register : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '1');
        variable Feedback      : STD_LOGIC;
        variable TapsArray     : TapsArrayType;
    begin
        TapsArray(2)  := "00000000000000000000000000000011";
        TapsArray(3)  := "00000000000000000000000000000101";
        TapsArray(4)  := "00000000000000000000000000001001";
        TapsArray(5)  := "00000000000000000000000000010010";
        TapsArray(6)  := "00000000000000000000000000100001";
        TapsArray(7)  := "00000000000000000000000001000001";
        TapsArray(8)  := "00000000000000000000000010001110";
        TapsArray(9)  := "00000000000000000000000100001000";
        TapsArray(10) := "00000000000000000000001000000100";
        TapsArray(11) := "00000000000000000000010000000010";
        TapsArray(12) := "00000000000000000000100000101001";
        TapsArray(13) := "00000000000000000001000000001101";
        TapsArray(14) := "00000000000000000010000000010101";
        TapsArray(15) := "00000000000000000100000000000001";
        TapsArray(16) := "00000000000000001000000000010110";
        TapsArray(17) := "00000000000000010000000000000100";
        TapsArray(18) := "00000000000000100000000001000000";
        TapsArray(19) := "00000000000001000000000000010011";			
        TapsArray(20) := "00000000000010000000000000000100";
        TapsArray(21) := "00000000000100000000000000000010";
        TapsArray(22) := "00000000001000000000000000000001";
        TapsArray(23) := "00000000010000000000000000010000";
        TapsArray(24) := "00000000100000000000000000001101";
        TapsArray(25) := "00000001000000000000000000000100";
        TapsArray(26) := "00000010000000000000000000100011";
        TapsArray(27) := "00000100000000000000000000010011";
        TapsArray(28) := "00001000000000000000000000000100";
        TapsArray(29) := "00010000000000000000000000000010";
        TapsArray(30) := "00100000000000000000000000101001";
        TapsArray(31) := "01000000000000000000000000000100";
        TapsArray(32) := "10000000000000000000000001100010";
        
        Taps <= TapsArray(WIDTH)(WIDTH-1 downto 0);
        
        if rising_edge(CLK) then 
            Feedback := LFSR_register(Width-1);
            
            for N in WIDTH-1 downto 1 loop 
                if Taps(N-1) = '1' then 
                    LFSR_register(N) := LFSR_register(N-1) xor Feedback;
                else 
                    LFSR_register(N) := LFSR_register(N-1);
                end if;
            end loop;
            
            LFSR_register(0) := Feedback;
        end if;
        
        RANDOM <= LFSR_register;
        
    end process PSEUDO_RANDOM_NUMBER_GENERATOR;
    
end Behavioral;

