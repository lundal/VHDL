LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_mutation_core IS
END tb_mutation_core;
 
ARCHITECTURE behavior OF tb_mutation_core IS 
 
    COMPONENT mutation_core
    PORT(
         enabled : IN  std_logic;
			active : IN std_logic;
         random_number : IN  std_logic_vector(31 downto 0);
         input : IN  std_logic_vector(63 downto 0);
			chance_input : IN std_logic_vector(5 downto 0);
         output : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enabled : std_logic := '0';
	signal active : std_logic := '0';
   signal random_number : std_logic_vector(31 downto 0) := (others => '0');
	signal chance_input : std_logic_vector(5 downto 0) := (others => '0');
   signal input : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(63 downto 0);
 
BEGIN
 
   uut: mutation_core PORT MAP (
          enabled => enabled,
			 active => active,
          random_number => random_number,
			 chance_input => chance_input,
          input => input,
          output => output
        );
 

   stim_proc: process
   begin		
	
      wait for 100 ns;	

		
		-- Following input bit-string will be used as "Standard" for input.
		input <= "1111111111111111000000000000000011111111111111110000000000000000";
		chance_input <= "000010";
		
		-- Setting random_number as all 0, except first 4 bits
		
		random_number <= "11110000000000000000000000000000";
		
		wait for 40 ns;
		
		-- Enabling and activating Mutation should be at bit 0
		enabled <= '1';
		active <= '1';
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr. 7 (000111), but top 6 bits do not allow mutation
		random_number <= "11110000000000000000000000000111";
	
		wait for 40 ns;
		
		-- Setting mutation to bit nr. 7 (000111), and allows mutation by setting top 6 bits to 000000,
		-- allowing signal reduced_random_numberC to be lower than chance_input and thus allowing mutation
		random_number <= "00000000000000000000000000000111";
	
		wait for 40 ns;
		
		-- Setting mutation to bit nr. 56 (111000)
		
		random_number <= "00000000000000000000000000111000";
		
		wait for 40 ns;

		-- Setting mutation to bit nr 27 (011011) and 59 (111011), but allowing only the first mutation
		-- by letting mutation_amount value be 0
		
		random_number <= "00000000000000000000111011011011";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111) and 62 (111110), allowing both by setting bits nr. 27 and 26 to 01
		
		random_number <= "00000001000000000000111110010111";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111), 62 (111110), and bit nr 1 (000001) allowing all three by setting bits nr. 27 and 26 to 10
		
		random_number <= "00000010000000000001111110010111";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111), 62 (111110), bit nr 1 (000001) and bit nr 60 (111100) allowing all three by setting bits nr. 27 and 26 to 11
		
		random_number <= "00000011111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changes in input should change output
		
		input <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		wait for 40 ns;
		
		-- Changes in top 6 bits in random_number to values higher than chance_control should deny mutation
		random_number <= "10000011111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changing back to 000000. Mutationt is now allowed:
		random_number <= "00000011111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changing to 000001. Mutation still allowed:
		random_number <= "00000111111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changing to 000010. Reduced_random_numberC equal to chance_input. Mutation still allowed:
		random_number <= "00001011111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changing to 000011. Reduced_random_numberC higher than chance_input. Mutation not allowed:
		random_number <= "00001111111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changing back to 000010. Reduced_random_numberC equal to chance_input. Mutation now allowed:
		random_number <= "00001011111100000001111110010111";
		
		wait for 40 ns;
		
		--Changing chance_input to 000001, mutation now not allowed:
		
		chance_input <= "000001";
		
		wait for 40 ns;
		
		-- Changes top 6 bits to 000000, mutation now allowed:
		random_number <= "00000011111100000001111110010111";
		
		wait for 40 ns;
		
		-- While not enabled, output should be only 0
		
		enabled <= '0';
		
		wait for 40 ns;
		
		--Changes in input, chance_input or random_number should not affect output when not enabled
		
		input <= "0000000000000001111111100000000000000000000000011111111000000000";
		
		wait for 40 ns;
		
		chance_input <= "111111";
		
		wait for 40 ns;
		
		random_number <= "11000011110000000111111001000000";
		
		wait for 40 ns;
		
		--Reseting
		input <= "1111111111111111000000000000000011111111111111110000000000000000";
		random_number <= "00000000000000000000000000000000";
		chance_input <= "000010";
		enabled <= '1';
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 (000101)
		
		random_number <= "00000000000000000000000000000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 twice
		
		random_number <= "00000001000000000000000101000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 three times
		
		random_number <= "00000010000000000101000101000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 four times
		
		random_number <= "00000011000101000101000101000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bits nr 5 (000101), 6 (000110), 7 (000111) and 8 (001000)
		
		random_number <= "00000011001000000111000110000101";
		
		wait for 40 ns;		
		
		-- Reducing mutations, removing number 3 and 4: 7 (000111) and 8 (001000), keeping  number 2 and 3: 5 (000101) and 6 (000110)
		
		random_number <= "00000001001000000111000110000101";
		
		wait for 40 ns;
		
		-- Setting active to 0, no mutation should occur, but input should still be passed through:
		
		active <='0';
		
		wait for 40 ns;
		
		-- Change in input should still change output.
		
		input <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		wait for 40 ns;
		
		-- Change in random_number should not matter when not active
		random_number <= "00110001001000000111000110011111";
		
		wait for 40 ns;
		
		-- Change in control_input should not matter when not active
		
		chance_input <= "111111";
		
		wait for 40 ns;
		
		-- Resetting active
		active <= '1';
		
		wait for 40 ns;
		
		-- For the next 64 tests, only one bit will be set to mutate, and it will go from bit nr 0 to bit nr 63.
		
		-- Number 00
		random_number <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 01
		random_number <= "00000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 02
		random_number <= "00000000000000000000000000000010";
		wait for 40 ns;
		
		-- Number 03
		random_number <= "00000000000000000000000000000011";
		wait for 40 ns;
		
		-- Number 04
		random_number <= "00000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 05
		random_number <= "00000000000000000000000000000101";
		wait for 40 ns;
		
		-- Number 06
		random_number <= "00000000000000000000000000000110";
		wait for 40 ns;
		
		-- Number 07
		random_number <= "00000000000000000000000000000111";
		wait for 40 ns;
		
		-- Number 08
		random_number <= "00000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 09
		random_number <= "00000000000000000000000000001001";
		wait for 40 ns;
		
		-- Number 10
		random_number <= "00000000000000000000000000001010";
		wait for 40 ns;
		
		-- Number 11
		random_number <= "00000000000000000000000000001011";
		wait for 40 ns;
		
		-- Number 12
		random_number <= "00000000000000000000000000001100";
		wait for 40 ns;
		
		-- Number 13
		random_number <= "00000000000000000000000000001101";
		wait for 40 ns;
		
		-- Number 14
		random_number <= "00000000000000000000000000001110";
		wait for 40 ns;
		
		-- Number 15
		random_number <= "00000000000000000000000000001111";
		wait for 40 ns;
		
		-- Number 16
		random_number <= "00000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 17
		random_number <= "00000000000000000000000000010001";
		wait for 40 ns;
		
		-- Number 18
		random_number <= "00000000000000000000000000010010";
		wait for 40 ns;
		
		-- Number 19
		random_number <= "00000000000000000000000000010011";
		wait for 40 ns;
		
		-- Number 20
		random_number <= "00000000000000000000000000010100";
		wait for 40 ns;
		
		-- Number 21
		random_number <= "00000000000000000000000000010101";
		wait for 40 ns;
		
		-- Number 22
		random_number <= "00000000000000000000000000010110";
		wait for 40 ns;
		
		-- Number 23
		random_number <= "00000000000000000000000000010111";
		wait for 40 ns;
		
		-- Number 24
		random_number <= "00000000000000000000000000011000";
		wait for 40 ns;
		
		-- Number 25
		random_number <= "00000000000000000000000000011001";
		wait for 40 ns;
		
		-- Number 26
		random_number <= "00000000000000000000000000011010";
		wait for 40 ns;
		
		-- Number 27
		random_number <= "00000000000000000000000000011011";
		wait for 40 ns;
		
		-- Number 28
		random_number <= "00000000000000000000000000011100";
		wait for 40 ns;
		
		-- Number 29
		random_number <= "00000000000000000000000000011101";
		wait for 40 ns;
		
		-- Number 30
		random_number <= "00000000000000000000000000011110";
		wait for 40 ns;
		
		-- Number 31
		random_number <= "00000000000000000000000000011111";
		wait for 40 ns;
		
		-- Number 32
		random_number <= "00000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 33
		random_number <= "00000000000000000000000000100001";
		wait for 40 ns;
		
		-- Number 34
		random_number <= "00000000000000000000000000100010";
		wait for 40 ns;
		
		-- Number 35
		random_number <= "00000000000000000000000000100011";
		wait for 40 ns;
		
		-- Number 36
		random_number <= "00000000000000000000000000100100";
		wait for 40 ns;
		
		-- Number 37
		random_number <= "00000000000000000000000000100101";
		wait for 40 ns;
		
		-- Number 38
		random_number <= "00000000000000000000000000100110";
		wait for 40 ns;
		
		-- Number 39
		random_number <= "00000000000000000000000000100111";
		wait for 40 ns;
		
		-- Number 40
		random_number <= "00000000000000000000000000101000";
		wait for 40 ns;
		
		-- Number 41
		random_number <= "00000000000000000000000000101001";
		wait for 40 ns;
		
		-- Number 42
		random_number <= "00000000000000000000000000101010";
		wait for 40 ns;
		
		-- Number 43
		random_number <= "00000000000000000000000000101011";
		wait for 40 ns;
		
		-- Number 44
		random_number <= "00000000000000000000000000101100";
		wait for 40 ns;
		
		-- Number 45
		random_number <= "00000000000000000000000000101101";
		wait for 40 ns;
		
		-- Number 46
		random_number <= "00000000000000000000000000101110";
		wait for 40 ns;
		
		-- Number 47
		random_number <= "00000000000000000000000000101111";
		wait for 40 ns;
		
		-- Number 48
		random_number <= "00000000000000000000000000110000";
		wait for 40 ns;
		
		-- Number 49
		random_number <= "00000000000000000000000000110001";
		wait for 40 ns;
		
		-- Number 50
		random_number <= "00000000000000000000000000110010";
		wait for 40 ns;
		
		-- Number 51
		random_number <= "00000000000000000000000000110011";
		wait for 40 ns;
		
		-- Number 52
		random_number <= "00000000000000000000000000110100";
		wait for 40 ns;
		
		-- Number 53
		random_number <= "00000000000000000000000000110101";
		wait for 40 ns;
		
		-- Number 54
		random_number <= "00000000000000000000000000110110";
		wait for 40 ns;
		
		-- Number 55
		random_number <= "00000000000000000000000000110111";
		wait for 40 ns;
		
		-- Number 56
		random_number <= "00000000000000000000000000111000";
		wait for 40 ns;
		
		-- Number 57
		random_number <= "00000000000000000000000000111001";
		wait for 40 ns;
		
		-- Number 58
		random_number <= "00000000000000000000000000111010";
		wait for 40 ns;
		
		-- Number 59
		random_number <= "00000000000000000000000000111011";
		wait for 40 ns;
		
		-- Number 60
		random_number <= "00000000000000000000000000111100";
		wait for 40 ns;
		
		-- Number 61
		random_number <= "00000000000000000000000000111101";
		wait for 40 ns;
		
		-- Number 62
		random_number <= "00000000000000000000000000111110";
		wait for 40 ns;
		
		-- Number 63
		random_number <= "00000000000000000000000000111111";
		wait for 40 ns;
		
		wait;
   end process;

END;
