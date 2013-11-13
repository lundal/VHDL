LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
 
 
library WORK;
 
ENTITY tb_Shifter IS
END tb_Shifter;
 
ARCHITECTURE behavior OF tb_Shifter IS 
 
    COMPONENT Shifter
	generic (
		N : natural := 64;
		M : natural := 1
	);
    port (
		I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		Left	:	in	STD_LOGIC;
		Arith	:	in	STD_LOGIC;
        Enable : in std_logic
	);
    END COMPONENT;
    

   --Inputs
   signal I : std_logic_vector(63 downto 0) := (others => '0');
   signal Left : std_logic := '0';
   signal Arith : std_logic := '0';
   signal Enable : std_logic := '0';

 	--Outputs
   signal O : std_logic_vector(63 downto 0);
 
BEGIN
   uut: Shifter
   generic map (
		N => 64,
		M => 3
	)
   port map (
		I => I,
		O => O,
		Left => Left,
		Arith => Arith,
        Enable => Enable
	);
 
   stim_proc: process
   begin		
		wait for 100 ns;
        
        Enable <= '1';
		I <= "1111111111111111111111111111111100000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		wait for 10 ns;
        test("sla 3", "negative", o, "1111111111111111111111111111100000000000000000000000000010000000");
        
		
		I <= "1111111111111111111111111111111100000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';
		wait for 10 ns;
        test("sra 3", "negative", o, "1111111111111111111111111111111111100000000000000000000000000010");
        

		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '1';
		Arith <= '0';
		wait for 10 ns;
        test("sll 3", "positive", o, "0000000000000000000000000000000000000000000000000000000010000000");
        

		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '0';
		Arith <= '0';
		wait for 10 ns;
        test("srl 3", "positive", o, "0000000000000000000000000000000000000000000000000000000000000010");
        

		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		wait for 10 ns;
        test("sla 3", "positive", o, "0000000000000000000000000000000000000000000000000000000010000000");
        

		I <= "0000000000000000000000000000000000000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';
		wait for 10 ns;
        test("sra 3", "positive", o, "0000000000000000000000000000000000000000000000000000000000000010");
        
        Enable <= '0';
        wait for 10 ns;
        test("enable", "should passthrough when not enabled", o, "0000000000000000000000000000000000000000000000000000000000010000");
        
        wait;
   end process;

END;
