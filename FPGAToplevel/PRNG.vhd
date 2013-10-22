library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PRNG is
    generic (Width : integer := 32);
    Port ( clk  : in  STD_LOGIC;
           reset : in STD_LOGIC;
           load : in STD_LOGIC;
           seed :in STD_LOGIC_VECTOR (Width-1 downto 0);
           rnd_out : out  STD_LOGIC_VECTOR (Width-1 downto 0));
end PRNG;

architecture Behavioral of PRNG is

type TapsArrayType is array (2 to 32) of std_logic_vector(31 downto 0);
signal Taps: std_logic_vector(Width-1 downto 0);

begin

    PSEUDO_RANDOM_NUMBER_GENERATOR : process (clk, reset) 
    -- Internal regsisters and signals
        variable LFSR_register : std_logic_vector (Width-1 downto 0); 
        variable Feedback: std_logic;
        variable TapsArray : TapsArrayType;
    
    begin
        Taps <= TapsArray(Width)(Width - 1 downto 0);
        if reset = '1' then 
            LFSR_register := (others => '1');
            -- Look-Up Table for Tap points to insert XOR gates as feedback into D-FF 
			-- outputs.  Taps are designed so that 2^N-1 (N=Width of Register) numbers 
			-- are cycled through before the sequence is repeated
				
			TapsArray(2) :=			"00000000000000000000000000000011";
			TapsArray(3) :=			"00000000000000000000000000000101";
			TapsArray(4) := 		"00000000000000000000000000001001";
			TapsArray(5) :=			"00000000000000000000000000010010";
			TapsArray(6) := 		"00000000000000000000000000100001";
			TapsArray(7) :=			"00000000000000000000000001000001";
			TapsArray(8) :=			"00000000000000000000000010001110";
			TapsArray(9)	:=		"00000000000000000000000100001000";
			TapsArray(10)	:=		"00000000000000000000001000000100";
			TapsArray(11)	:=		"00000000000000000000010000000010";
			TapsArray(12)	:=		"00000000000000000000100000101001";
			TapsArray(13)	:=		"00000000000000000001000000001101";
			TapsArray(14)	:=		"00000000000000000010000000010101";
			TapsArray(15)	:=		"00000000000000000100000000000001";
			TapsArray(16)	:=		"00000000000000001000000000010110";
			TapsArray(17)	:=		"00000000000000010000000000000100";
			TapsArray(18)	:=		"00000000000000100000000001000000";
			TapsArray(19)	:=		"00000000000001000000000000010011";			
			TapsArray(20)	:=		"00000000000010000000000000000100";
			TapsArray(21)	:=		"00000000000100000000000000000010";
			TapsArray(22)	:=		"00000000001000000000000000000001";
			TapsArray(23)	:=		"00000000010000000000000000010000";
			TapsArray(24)	:=		"00000000100000000000000000001101";
			TapsArray(25)	:=		"00000001000000000000000000000100";
			TapsArray(26)	:=		"00000010000000000000000000100011";
			TapsArray(27)	:=		"00000100000000000000000000010011";
			TapsArray(28)	:=		"00001000000000000000000000000100";
			TapsArray(29)	:=		"00010000000000000000000000000010";
			TapsArray(30)	:=		"00100000000000000000000000101001";
			TapsArray(31)	:=		"01000000000000000000000000000100";
			TapsArray(32)	:=		"10000000000000000000000001100010";
            
            
        -- Use the seed value on port to determine where to start in the pseudo-random sequence 
        elsif load = '1' then
            for index in seed'range loop
			
					if seed(index) = '1' then
						LFSR_register := seed;
					end if;
			
				end loop;
        
        elsif rising_edge(clk) then 
            Feedback := LFSR_register(Width-1);
            
            for N in Width-1 downto 1 loop 
                if Taps(N-1) = '1' then 
                    LFSR_register(N) := LFSR_register(N-1) xor Feedback;
                else 
                    LFSR_register(N) := LFSR_register(N-1);
                end if;
            end loop;
            
            LFSR_register(0) := Feedback;
            
         end if;
         
         rnd_out <= LFSR_register;
        
    
    end process PSEUDO_RANDOM_NUMBER_GENERATOR;


end Behavioral;

