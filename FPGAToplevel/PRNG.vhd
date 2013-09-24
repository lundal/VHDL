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

signal Taps: std_logic_vector(Width-1 downto 0);

begin

    PSEUDO_RANDOM_NUMBER_GENERATOR : process (clk, reset) 
    -- Internal regsisters and signals
        variable LFSR_register : std_logic_vector (Width-1 downto 0); 
        variable Feedback: std_logic;
        
    begin
        -- Taps are designed so that 2^31 numbers are
        -- cycled through before the sequence is repeated
        Taps <= "10000000000000000000000001100010";
        if reset = '0' then 
            LFSR_register := (others => '1');
            
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

