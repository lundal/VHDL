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
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY mutation_core_tb IS
END mutation_core_tb;
 
ARCHITECTURE behavior OF mutation_core_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mutation_core
    PORT(
         enabled : IN  std_logic;
         random_number : IN  std_logic_vector(31 downto 0);
         input : IN  std_logic_vector(63 downto 0);
         output : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enabled : std_logic := '0';
   signal random_number : std_logic_vector(31 downto 0) := (others => '0');
   signal input : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(63 downto 0);
 
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
	
      wait for 100 ns;	

		
		-- Following input bit-string will be used as "Standard" for input.
		input <= "1111111111111111000000000000000011111111111111110000000000000000";
		
		-- Setting random_number as all 0, except first 4 bits
		-- Remember that the 2 least significant bits are not used
		
		random_number <= "11110000000000000000000000000000";
		
		wait for 40 ns;
		
		-- Enabling. Mutation should be at bit 0
		enabled <= '1';
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr. 7 (000111), but top 4 bits does not allow mutation
		random_number <= "11110000000000000000000000011100";
	
		wait for 40 ns;
		
		-- Setting mutation to bit nr. 7 (000111), and allows mutation by setting top 4 bits to 0000,
		-- allowing signal mutation_control to be equal to 0 and thus allowing mutation
		random_number <= "00000000000000000000000000011100";
	
		wait for 40 ns;
		
		-- Setting mutation to bit nr. 56 (111000)
		
		random_number <= "00000000000000000000000011100000";
		
		wait for 40 ns;

		-- Setting mutation to bit nr 27 (011011) and 59 (111011), but allowing only the first mutation
		-- by letting mutation_amount value be 0
		
		random_number <= "00000000000000000011101101101100";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111) and 62 (111110), allowing both by setting bits nr. 27 and 26 to 01
		
		random_number <= "00000100000000000011111001011100";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111), 62 (111110), and bit nr 1 (000001) allowing all three by setting bits nr. 27 and 26 to 10
		
		random_number <= "00001000000000000111111001011100";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 23 (010111), 62 (111110), bit nr 1 (000001) and bit nr 60 (111100) allowing all three by setting bits nr. 27 and 26 to 11
		
		random_number <= "00001111110000000111111001011100";
		
		wait for 40 ns;
		
		-- Changes on the 2 least significant bits should not matter
		
		random_number <= "00001111110000000111111001011111";
		
		wait for 40 ns;
		
		-- Changes in input should change output
		
		input <= "0000000000000000000000000000000000000000000000000000000000000000";
		
		wait for 40 ns;
		
		-- Changes in top 4 bits in random_number to any other values than 0000 should deny mutation
		random_number <= "10001111110000000111111001011111";
		
		wait for 40 ns;
		
		-- Changing back to 0000:
		random_number <= "00001111110000000111111001011111";
		
		wait for 40 ns;
		
		-- While not enabled, output should be only 0
		
		enabled <= '0';
		
		wait for 40 ns;
		
		--Changes in input or random_number should not affect output when not enabled
		
		input <= "0000000000000001111111100000000000000000000000011111111000000000";
		
		wait for 40 ns;
		
		random_number <= "11000011110000000111111001000000";
		
		wait for 40 ns;
		
		--Reseting
		input <= "1111111111111111000000000000000011111111111111110000000000000000";
		random_number <= "00000000000000000000000000000000";
		enabled <= '1';
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 (000101)
		
		random_number <= "00000000000000000000000000010100";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 twice
		
		random_number <= "00000100000000000000010100010100";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 three times
		
		random_number <= "00001000000000010100010100010100";
		
		wait for 40 ns;
		
		-- Setting mutation to bit nr 5 four times
		
		random_number <= "00001100010100010100010100010100";
		
		wait for 40 ns;
		
		-- Setting mutation to bits nr 5 (000101), 6 (000110), 7 (000111) and 8 (001000)
		
		random_number <= "00001100100000011100011000010100";
		
		wait for 40 ns;
		
		-- Reducing mutations, removing number 3 and 4: 7 (000111) and 8 (001000), keeping  number 2 and 3: 5 (000101) and 6 (000110)
		
		random_number <= "00000100001000011100011000010100";
		
		wait for 40 ns;
		
		-- For the next 64 tests, only one bit will be set to mutate, and it will go from bit nr 0 to bit nr 63.
		
		-- Number 00
		random_number <= "00000000000000000000000000000000";
		wait for 40 ns;
		
		-- Number 01
		random_number <= "00000000000000000000000000000100";
		wait for 40 ns;
		
		-- Number 02
		random_number <= "00000000000000000000000000001000";
		wait for 40 ns;
		
		-- Number 03
		random_number <= "00000000000000000000000000001100";
		wait for 40 ns;
		
		-- Number 04
		random_number <= "00000000000000000000000000010000";
		wait for 40 ns;
		
		-- Number 05
		random_number <= "00000000000000000000000000010100";
		wait for 40 ns;
		
		-- Number 06
		random_number <= "00000000000000000000000000011000";
		wait for 40 ns;
		
		-- Number 07
		random_number <= "00000000000000000000000000011100";
		wait for 40 ns;
		
		-- Number 08
		random_number <= "00000000000000000000000000100000";
		wait for 40 ns;
		
		-- Number 09
		random_number <= "00000000000000000000000000100100";
		wait for 40 ns;
		
		-- Number 10
		random_number <= "00000000000000000000000000101000";
		wait for 40 ns;
		
		-- Number 11
		random_number <= "00000000000000000000000000101100";
		wait for 40 ns;
		
		-- Number 12
		random_number <= "00000000000000000000000000110000";
		wait for 40 ns;
		
		-- Number 13
		random_number <= "00000000000000000000000000110100";
		wait for 40 ns;
		
		-- Number 14
		random_number <= "00000000000000000000000000111000";
		wait for 40 ns;
		
		-- Number 15
		random_number <= "00000000000000000000000000111100";
		wait for 40 ns;
		
		-- Number 16
		random_number <= "00000000000000000000000001000000";
		wait for 40 ns;
		
		-- Number 17
		random_number <= "00000000000000000000000001000100";
		wait for 40 ns;
		
		-- Number 18
		random_number <= "00000000000000000000000001001000";
		wait for 40 ns;
		
		-- Number 19
		random_number <= "00000000000000000000000001001100";
		wait for 40 ns;
		
		-- Number 20
		random_number <= "00000000000000000000000001010000";
		wait for 40 ns;
		
		-- Number 21
		random_number <= "00000000000000000000000001010100";
		wait for 40 ns;
		
		-- Number 22
		random_number <= "00000000000000000000000001011000";
		wait for 40 ns;
		
		-- Number 23
		random_number <= "00000000000000000000000001011100";
		wait for 40 ns;
		
		-- Number 24
		random_number <= "00000000000000000000000001100000";
		wait for 40 ns;
		
		-- Number 25
		random_number <= "00000000000000000000000001100100";
		wait for 40 ns;
		
		-- Number 26
		random_number <= "00000000000000000000000001101000";
		wait for 40 ns;
		
		-- Number 27
		random_number <= "00000000000000000000000001101100";
		wait for 40 ns;
		
		-- Number 28
		random_number <= "00000000000000000000000001110000";
		wait for 40 ns;
		
		-- Number 29
		random_number <= "00000000000000000000000001110100";
		wait for 40 ns;
		
		-- Number 30
		random_number <= "00000000000000000000000001111000";
		wait for 40 ns;
		
		-- Number 31
		random_number <= "00000000000000000000000001111100";
		wait for 40 ns;
		
		-- Number 32
		random_number <= "00000000000000000000000010000000";
		wait for 40 ns;
		
		-- Number 33
		random_number <= "00000000000000000000000010000100";
		wait for 40 ns;
		
		-- Number 34
		random_number <= "00000000000000000000000010001000";
		wait for 40 ns;
		
		-- Number 35
		random_number <= "00000000000000000000000010001100";
		wait for 40 ns;
		
		-- Number 36
		random_number <= "00000000000000000000000010010000";
		wait for 40 ns;
		
		-- Number 37
		random_number <= "00000000000000000000000010010100";
		wait for 40 ns;
		
		-- Number 38
		random_number <= "00000000000000000000000010011000";
		wait for 40 ns;
		
		-- Number 39
		random_number <= "00000000000000000000000010011100";
		wait for 40 ns;
		
		-- Number 40
		random_number <= "00000000000000000000000010100000";
		wait for 40 ns;
		
		-- Number 41
		random_number <= "00000000000000000000000010100100";
		wait for 40 ns;
		
		-- Number 42
		random_number <= "00000000000000000000000010101000";
		wait for 40 ns;
		
		-- Number 43
		random_number <= "00000000000000000000000010101100";
		wait for 40 ns;
		
		-- Number 44
		random_number <= "00000000000000000000000010110000";
		wait for 40 ns;
		
		-- Number 45
		random_number <= "00000000000000000000000010110100";
		wait for 40 ns;
		
		-- Number 46
		random_number <= "00000000000000000000000010111000";
		wait for 40 ns;
		
		-- Number 47
		random_number <= "00000000000000000000000010111100";
		wait for 40 ns;
		
		-- Number 48
		random_number <= "00000000000000000000000011000000";
		wait for 40 ns;
		
		-- Number 49
		random_number <= "00000000000000000000000011000100";
		wait for 40 ns;
		
		-- Number 50
		random_number <= "00000000000000000000000011001000";
		wait for 40 ns;
		
		-- Number 51
		random_number <= "00000000000000000000000011001100";
		wait for 40 ns;
		
		-- Number 52
		random_number <= "00000000000000000000000011010000";
		wait for 40 ns;
		
		-- Number 53
		random_number <= "00000000000000000000000011010100";
		wait for 40 ns;
		
		-- Number 54
		random_number <= "00000000000000000000000011011000";
		wait for 40 ns;
		
		-- Number 55
		random_number <= "00000000000000000000000011011100";
		wait for 40 ns;
		
		-- Number 56
		random_number <= "00000000000000000000000011100000";
		wait for 40 ns;
		
		-- Number 57
		random_number <= "00000000000000000000000011100100";
		wait for 40 ns;
		
		-- Number 58
		random_number <= "00000000000000000000000011101000";
		wait for 40 ns;
		
		-- Number 59
		random_number <= "00000000000000000000000011101100";
		wait for 40 ns;
		
		-- Number 60
		random_number <= "00000000000000000000000011110000";
		wait for 40 ns;
		
		-- Number 61
		random_number <= "00000000000000000000000011110100";
		wait for 40 ns;
		
		-- Number 62
		random_number <= "00000000000000000000000011111000";
		wait for 40 ns;
		
		-- Number 63
		random_number <= "00000000000000000000000011111100";
		wait for 40 ns;
		
		wait;
   end process;

END;
