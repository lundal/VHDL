--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:21:32 09/27/2013
-- Design Name:   
-- Module Name:   C:/Users/torbjlan/VHDL/FPGAToplevel/mutation_core_tb.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mutation_core
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mutation_core_tb IS
END mutation_core_tb;
 
ARCHITECTURE behavior OF mutation_core_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mutation_core
    PORT(
         enabled : IN  std_logic;
         random_number : IN  std_logic_vector(63 downto 0);
         input : IN  std_logic_vector(63 downto 0);
         output : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enabled : std_logic := '0';
   signal random_number : std_logic_vector(63 downto 0) := (others => '0');
   signal input : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(63 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mutation_core PORT MAP (
          enabled => enabled,
          random_number => random_number,
          input => input,
          output => output
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		
		-- Following input bit-string will be used as "Standard" for input.
		input <= "1111111111111111000000000000000011111111111111110000000000000000";
		
		-- Setting random_number as all 0
		
		random_number <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		wait for 40 ns;
		
		-- Enabling. Mutation should be at bit 0
		enabled <= '1';
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr. 7 (000111)
		random_number <= "0000000000000000000000000000000000000000000000000000000000000111";
	
		wait for 40 ns;
	
		-- Setting mutation to bit nr. 56 (111000)
		
		random_number <= "0000000000000000000000000000000000000000000000000000000000111000";
		
		wait for 40 ns;

		-- Setting mutation to bit nr 27 (011011) and 59 (111011), but allowing only the first mutation
		
		random_number <= "0000000000000000000000000000000000000000000000000000111011011011";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111) and 62 (111110), allowing both by setting two first bits to 01
		
		random_number <= "0100000000000000000000000000000000000000000000000000111110010111";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111), 62 (111110), and bit nr 1 (000001) allowing all three by setting two first bits to 10
		
		random_number <= "1000000000000000000000000000000000000000000000000001111110010111";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111), 62 (111110), bit nr 1 (000001) and bit nr 60 (111100) allowing all three by setting two first bits to 11
		
		random_number <= "1100000000000000000000000000000000000000111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changes on other bits on random_number should not matter
		
		random_number <= "1100000000111001101001110000000000000000111100000001111110010111";
		
		wait for 40 ns;
		
		-- Changes in input should change output
		
		input <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		wait for 40 ns;
		
		-- While not enabled, output should be only 0
		
		enabled <= '0';
		
		wait for 40 ns;
		
		--Changes in input or random_number should not affect output when not enabled
		
		input <= "0000000000000000000000000000000000000000000000011111111000000000";
		
		wait for 40 ns;
		
		random_number <= "1100000000111001101001110000000000000000111100000001111110010000";
		
		wait for 40 ns;
		
		--Reseting
		input <= "1111111111111111000000000000000011111111111111110000000000000000";
		random_number <= "0000000000000000000000000000000000000000000000000000000000000000";
		enabled <= '1';
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 (000101)
		
		random_number <= "0000000000000000000000000000000000000000000000000000000000000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 twice
		
		random_number <= "0100000000000000000000000000000000000000000000000000000101000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 three times
		
		random_number <= "1000000000000000000000000000000000000000000000000101000101000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 four times
		
		random_number <= "1100000000000000000000000000000000000000000101000101000101000101";
		
		wait for 40 ns;
		
		-- Setting mutation to bits nr 5 (000101), 6 (000110), 7 (000111) and 8 (001000)
		
		random_number <= "1100000000000000000000000000000000000000001000000111000110000101";
		
		wait for 40 ns;
		
		-- Reducing mutations, removing number 3 and 4: 7 (000111) and 8 (001000), keeping  number 2 and 3: 5 (000101) and 6 (000110)
		
		random_number <= "0100000000000000000000000000000000000000001000000111000110000101";
		
		wait for 40 ns;
		
		-- For the next 64 tests, only one bit will be set to mutate, and it will go from bit nr 0 to bit nr 63.
		
		-- Number 00
		random_number <= "0000000000000000000000000000000000000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 01
		random_number <= "0000000000000000000000000000000000000000000000000000000000000001";
		wait for 40 ns;
		
		-- Number 02
		random_number <= "0000000000000000000000000000000000000000000000000000000000000010";
		wait for 40 ns;
		
		-- Number 03
		random_number <= "0000000000000000000000000000000000000000000000000000000000000011";
		wait for 40 ns;
		
		-- Number 04
		random_number <= "0000000000000000000000000000000000000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 05
		random_number <= "0000000000000000000000000000000000000000000000000000000000000101";
		wait for 40 ns;
		
		-- Number 06
		random_number <= "0000000000000000000000000000000000000000000000000000000000000110";
		wait for 40 ns;
		
		-- Number 07
		random_number <= "0000000000000000000000000000000000000000000000000000000000000111";
		wait for 40 ns;
		
		-- Number 08
		random_number <= "0000000000000000000000000000000000000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 09
		random_number <= "0000000000000000000000000000000000000000000000000000000000001001";
		wait for 40 ns;
		
		-- Number 10
		random_number <= "0000000000000000000000000000000000000000000000000000000000001010";
		wait for 40 ns;
		
		-- Number 11
		random_number <= "0000000000000000000000000000000000000000000000000000000000001011";
		wait for 40 ns;
		
		-- Number 12
		random_number <= "0000000000000000000000000000000000000000000000000000000000001100";
		wait for 40 ns;
		
		-- Number 13
		random_number <= "0000000000000000000000000000000000000000000000000000000000001101";
		wait for 40 ns;
		
		-- Number 14
		random_number <= "0000000000000000000000000000000000000000000000000000000000001110";
		wait for 40 ns;
		
		-- Number 15
		random_number <= "0000000000000000000000000000000000000000000000000000000000001111";
		wait for 40 ns;
		
		-- Number 16
		random_number <= "0000000000000000000000000000000000000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 17
		random_number <= "0000000000000000000000000000000000000000000000000000000000010001";
		wait for 40 ns;
		
		-- Number 18
		random_number <= "0000000000000000000000000000000000000000000000000000000000010010";
		wait for 40 ns;
		
		-- Number 19
		random_number <= "0000000000000000000000000000000000000000000000000000000000010011";
		wait for 40 ns;
		
		-- Number 20
		random_number <= "0000000000000000000000000000000000000000000000000000000000010100";
		wait for 40 ns;
		
		-- Number 21
		random_number <= "0000000000000000000000000000000000000000000000000000000000010101";
		wait for 40 ns;
		
		-- Number 22
		random_number <= "0000000000000000000000000000000000000000000000000000000000010110";
		wait for 40 ns;
		
		-- Number 23
		random_number <= "0000000000000000000000000000000000000000000000000000000000010111";
		wait for 40 ns;
		
		-- Number 24
		random_number <= "0000000000000000000000000000000000000000000000000000000000011000";
		wait for 40 ns;
		
		-- Number 25
		random_number <= "0000000000000000000000000000000000000000000000000000000000011001";
		wait for 40 ns;
		
		-- Number 26
		random_number <= "0000000000000000000000000000000000000000000000000000000000011010";
		wait for 40 ns;
		
		-- Number 27
		random_number <= "0000000000000000000000000000000000000000000000000000000000011011";
		wait for 40 ns;
		
		-- Number 28
		random_number <= "0000000000000000000000000000000000000000000000000000000000011100";
		wait for 40 ns;
		
		-- Number 29
		random_number <= "0000000000000000000000000000000000000000000000000000000000011101";
		wait for 40 ns;
		
		-- Number 30
		random_number <= "0000000000000000000000000000000000000000000000000000000000011110";
		wait for 40 ns;
		
		-- Number 31
		random_number <= "0000000000000000000000000000000000000000000000000000000000011111";
		wait for 40 ns;
		
		-- Number 32
		random_number <= "0000000000000000000000000000000000000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 33
		random_number <= "0000000000000000000000000000000000000000000000000000000000100001";
		wait for 40 ns;
		
		-- Number 34
		random_number <= "0000000000000000000000000000000000000000000000000000000000100010";
		wait for 40 ns;
		
		-- Number 35
		random_number <= "0000000000000000000000000000000000000000000000000000000000100011";
		wait for 40 ns;
		
		-- Number 36
		random_number <= "0000000000000000000000000000000000000000000000000000000000100100";
		wait for 40 ns;
		
		-- Number 37
		random_number <= "0000000000000000000000000000000000000000000000000000000000100101";
		wait for 40 ns;
		
		-- Number 38
		random_number <= "0000000000000000000000000000000000000000000000000000000000100110";
		wait for 40 ns;
		
		-- Number 39
		random_number <= "0000000000000000000000000000000000000000000000000000000000100111";
		wait for 40 ns;
		
		-- Number 40
		random_number <= "0000000000000000000000000000000000000000000000000000000000101000";
		wait for 40 ns;
		
		-- Number 41
		random_number <= "0000000000000000000000000000000000000000000000000000000000101001";
		wait for 40 ns;
		
		-- Number 42
		random_number <= "0000000000000000000000000000000000000000000000000000000000101010";
		wait for 40 ns;
		
		-- Number 43
		random_number <= "0000000000000000000000000000000000000000000000000000000000101011";
		wait for 40 ns;
		
		-- Number 44
		random_number <= "0000000000000000000000000000000000000000000000000000000000101100";
		wait for 40 ns;
		
		-- Number 45
		random_number <= "0000000000000000000000000000000000000000000000000000000000101101";
		wait for 40 ns;
		
		-- Number 46
		random_number <= "0000000000000000000000000000000000000000000000000000000000101110";
		wait for 40 ns;
		
		-- Number 47
		random_number <= "0000000000000000000000000000000000000000000000000000000000101111";
		wait for 40 ns;
		
		-- Number 48
		random_number <= "0000000000000000000000000000000000000000000000000000000000110000";
		wait for 40 ns;
		
		-- Number 49
		random_number <= "0000000000000000000000000000000000000000000000000000000000110001";
		wait for 40 ns;
		
		-- Number 50
		random_number <= "0000000000000000000000000000000000000000000000000000000000110010";
		wait for 40 ns;
		
		-- Number 51
		random_number <= "0000000000000000000000000000000000000000000000000000000000110011";
		wait for 40 ns;
		
		-- Number 52
		random_number <= "0000000000000000000000000000000000000000000000000000000000110100";
		wait for 40 ns;
		
		-- Number 53
		random_number <= "0000000000000000000000000000000000000000000000000000000000110101";
		wait for 40 ns;
		
		-- Number 54
		random_number <= "0000000000000000000000000000000000000000000000000000000000110110";
		wait for 40 ns;
		
		-- Number 55
		random_number <= "0000000000000000000000000000000000000000000000000000000000110111";
		wait for 40 ns;
		
		-- Number 56
		random_number <= "0000000000000000000000000000000000000000000000000000000000111000";
		wait for 40 ns;
		
		-- Number 57
		random_number <= "0000000000000000000000000000000000000000000000000000000000111001";
		wait for 40 ns;
		
		-- Number 58
		random_number <= "0000000000000000000000000000000000000000000000000000000000111010";
		wait for 40 ns;
		
		-- Number 59
		random_number <= "0000000000000000000000000000000000000000000000000000000000111011";
		wait for 40 ns;
		
		-- Number 60
		random_number <= "0000000000000000000000000000000000000000000000000000000000111100";
		wait for 40 ns;
		
		-- Number 61
		random_number <= "0000000000000000000000000000000000000000000000000000000000111101";
		wait for 40 ns;
		
		-- Number 62
		random_number <= "0000000000000000000000000000000000000000000000000000000000111110";
		wait for 40 ns;
		
		-- Number 63
		random_number <= "0000000000000000000000000000000000000000000000000000000000111111";
		wait for 40 ns;
		
   end process;

END;
