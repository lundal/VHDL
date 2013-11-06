LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY crossover_core_split_tb IS
END crossover_core_split_tb;
 
ARCHITECTURE behavior OF crossover_core_split_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT crossover_core_split
    PORT(
         random_number : IN  std_logic_vector(5 downto 0);
         parent1 : IN  std_logic_vector(63 downto 0);
         parent2 : IN  std_logic_vector(63 downto 0);
         child1 : OUT  std_logic_vector(63 downto 0);
         child2 : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal random_number : std_logic_vector(5 downto 0) := (others => '0');
   signal parent1 : std_logic_vector(63 downto 0) := (others => '0');
   signal parent2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal child1 : std_logic_vector(63 downto 0);
   signal child2 : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: crossover_core_split PORT MAP (
          random_number => random_number,
          parent1 => parent1,
          parent2 => parent2,
          child1 => child1,
          child2 => child2
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		
		-- Choosing completely different bitpatterns (from now on referred to as "standard parents"):
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		-- Choosing 11, with ending bit-pattern 1011, value for as opening random number:
		random_number <= "001011";
		
		wait for 40 ns;
		
		-- Change in parents should cause change in children:
		parent1 <= "1111111111111111000000000000000011000011111111110000000000011110";
		parent2 <= "0000000000000000111111111111111100111100000000001111111111100001";
		
		wait for 40 ns;
		
		-- Change in random-number should cause change in children:
		-- (setting to 18, with bit-pattern 010010)
		random_number <= "010010";
		
		wait for 40 ns;
		
		
		-- Parents with equal bits in crossover-slots should produce same bits in same slots in both children:
		-- (1111 set in bits 3-0, and 0000 set in bits 11-8)
		parent1 <= "1111111111111111000000000000000011111111111111110000000000001111";
		parent2 <= "0000000000000000111111111111111100000000000000001111000011111111";
		
		wait for 40 ns;
		
		-- Going from bit number 0 to 63 for the next 64 tests:
		
		-- (Setting back to "Standard parents")
		parent1 <= "1111111111111111000000000000000011111111111111110000000000000000";
		parent2 <= "0000000000000000111111111111111100000000000000001111111111111111";
		
		random_number <= (5 downto 0 => '0');
		
		-- Number 00
		random_number <= "000000";
		wait for 40 ns;
		
		-- Number 01
		random_number <= "000001";
		wait for 40 ns;
		
		-- Number 02
		random_number <= "000010";
		wait for 40 ns;
		
		-- Number 03
		random_number <= "000011";
		wait for 40 ns;
		
		-- Number 04
		random_number <= "000100";
		wait for 40 ns;
		
		-- Number 05
		random_number <= "000101";
		wait for 40 ns;
		
		-- Number 06
		random_number <= "000110";
		wait for 40 ns;
		
		-- Number 07
		random_number <= "000111";
		wait for 40 ns;
		
		-- Number 08
		random_number <= "001000";
		wait for 40 ns;
		
		-- Number 09
		random_number <= "001001";
		wait for 40 ns;
		
		-- Number 10
		random_number <= "001010";
		wait for 40 ns;
		
		-- Number 11
		random_number <= "001011";
		wait for 40 ns;
		
		-- Number 12
		random_number <= "001100";
		wait for 40 ns;
		
		-- Number 13
		random_number <= "001101";
		wait for 40 ns;
		
		-- Number 14
		random_number <= "001110";
		wait for 40 ns;
		
		-- Number 15
		random_number <= "001111";
		wait for 40 ns;
		
		-- Number 16
		random_number <= "010000";
		wait for 40 ns;
		
		-- Number 17
		random_number <= "010001";
		wait for 40 ns;
		
		-- Number 18
		random_number <= "010010";
		wait for 40 ns;
		
		-- Number 19
		random_number <= "010011";
		wait for 40 ns;
		
		-- Number 20
		random_number <= "010100";
		wait for 40 ns;
		
		-- Number 21
		random_number <= "010101";
		wait for 40 ns;
		
		-- Number 22
		random_number <= "010110";
		wait for 40 ns;
		
		-- Number 23
		random_number <= "010111";
		wait for 40 ns;
		
		-- Number 24
		random_number <= "011000";
		wait for 40 ns;
		
		-- Number 25
		random_number <= "011001";
		wait for 40 ns;
		
		-- Number 26
		random_number <= "011010";
		wait for 40 ns;
		
		-- Number 27
		random_number <= "011011";
		wait for 40 ns;
		
		-- Number 28
		random_number <= "011100";
		wait for 40 ns;
		
		-- Number 29
		random_number <= "011101";
		wait for 40 ns;
		
		-- Number 30
		random_number <= "011110";
		wait for 40 ns;
		
		-- Number 31
		random_number <= "011111";
		wait for 40 ns;
		
		-- Number 32
		random_number <= "100000";
		wait for 40 ns;
		
		-- Number 33
		random_number <= "100001";
		wait for 40 ns;
		
		-- Number 34
		random_number <= "100010";
		wait for 40 ns;
		
		-- Number 35
		random_number <= "100011";
		wait for 40 ns;
		
		-- Number 36
		random_number <= "100100";
		wait for 40 ns;
		
		-- Number 37
		random_number <= "100101";
		wait for 40 ns;
		
		-- Number 38
		random_number <= "100110";
		wait for 40 ns;
		
		-- Number 39
		random_number <= "100111";
		wait for 40 ns;
		
		-- Number 40
		random_number <= "101000";
		wait for 40 ns;
		
		-- Number 41
		random_number <= "101001";
		wait for 40 ns;
		
		-- Number 42
		random_number <= "101010";
		wait for 40 ns;
		
		-- Number 43
		random_number <= "101011";
		wait for 40 ns;
		
		-- Number 44
		random_number <= "101100";
		wait for 40 ns;
		
		-- Number 45
		random_number <= "101101";
		wait for 40 ns;
		
		-- Number 46
		random_number <= "101110";
		wait for 40 ns;
		
		-- Number 47
		random_number <= "101111";
		wait for 40 ns;
		
		-- Number 48
		random_number <= "110000";
		wait for 40 ns;
		
		-- Number 49
		random_number <= "110001";
		wait for 40 ns;
		
		-- Number 50
		random_number <= "110010";
		wait for 40 ns;
		
		-- Number 51
		random_number <= "110011";
		wait for 40 ns;
		
		-- Number 52
		random_number <= "110100";
		wait for 40 ns;
		
		-- Number 53
		random_number <= "110101";
		wait for 40 ns;
		
		-- Number 54
		random_number <= "110110";
		wait for 40 ns;
		
		-- Number 55
		random_number <= "110111";
		wait for 40 ns;
		
		-- Number 56
		random_number <= "111000";
		wait for 40 ns;
		
		-- Number 57
		random_number <= "111001";
		wait for 40 ns;
		
		-- Number 58
		random_number <= "111010";
		wait for 40 ns;
		
		-- Number 59
		random_number <= "111011";
		wait for 40 ns;
		
		-- Number 60
		random_number <= "111100";
		wait for 40 ns;
		
		-- Number 61
		random_number <= "111101";
		wait for 40 ns;
		
		-- Number 62
		random_number <= "111110";
		wait for 40 ns;
		
		-- Number 63
		random_number <= "111111";
		wait for 40 ns;

      wait;
   end process;

END;
