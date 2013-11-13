LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
 
library WORK;
 
ENTITY tb_ShifterVariable IS
END tb_ShifterVariable;
 
ARCHITECTURE behavior OF tb_ShifterVariable IS 
 
    COMPONENT ShifterVariable
	generic (
		N : natural := 64;
		M : natural := 6
	);
    PORT(
         I : IN  std_logic_vector(63 downto 0);
         O : OUT  std_logic_vector(63 downto 0);
         Left : IN  std_logic;
         Arith : IN  std_logic;
         Count : IN  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I : std_logic_vector(63 downto 0) := (others => '0');
   signal Left : std_logic := '0';
   signal Arith : std_logic := '0';
   signal Count : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal O : std_logic_vector(63 downto 0);
 
BEGIN
 
   uut: ShifterVariable PORT MAP (
          I => I,
          O => O,
          Left => Left,
          Arith => Arith,
          Count => Count
        );
 
   stim_proc: process
   begin		
		wait for 100 ns;

		I <= "1111111111111111111111111111111100000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		Count <= "000100";
		wait for 10 ns;
        test("slav 4", "negative input", o, "1111111111111111111111111111000000000000000000000000000100000000"); 
		
        
		I <= "1111111111111111111111111111111100000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';
		Count <= "000100";
        wait for 10 ns;
        test("srav 4", "negative input", o, "1111111111111111111111111111111111110000000000000000000000000001");
		
        
		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '1';
		Arith <= '0';
		Count <= "000001";
        wait for 10 ns;
        test("sllv 1", "positive input", o, "0000000000000000000000000000000000000000000000000000000000100000");


		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '0';
		Arith <= '0';
		Count <= "000001";
		wait for 10 ns;
        test("srlv 1", "positive input", o, "0000000000000000000000000000000000000000000000000000000000001000");
        

		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		Count <= "000011";
		wait for 10 ns;
        test("slav 3", "positive input", o, "0000000000000000000000000000000000000000000000000000000010000000");
        

		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';
		Count <= "000011";
        wait for 10 ns;
        test("srav 3", "positive input", o, "0000000000000000000000000000000000000000000000000000000000000010");

		wait;
   end process;
   
END;
