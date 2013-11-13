LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
 
ENTITY tb_adder IS
END tb_adder;
 
ARCHITECTURE behavior OF tb_adder IS 
 
    COMPONENT Adder
    PORT(
         A : IN  std_logic_vector(63 downto 0);
         B : IN  std_logic_vector(63 downto 0);
         carry_in : std_logic;
         r : OUT  std_logic_vector(63 downto 0);
         overflow : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal A : std_logic_vector(63 downto 0) := (others => '0');
   signal B : std_logic_vector(63 downto 0) := (others => '0');
   signal carry_in : std_logic;

 	--Outputs
   signal r : std_logic_vector(63 downto 0);
   signal overflow : std_logic;
 
BEGIN
 
   uut: Adder PORT MAP (
          A => A,
          B => B,
          r => r,
          carry_in => carry_in,
          overflow => overflow
        );
        

   stim_proc: process
   begin		
      wait for 100 ns;	
      
        carry_in <= '0';
        -- todo: test carry_in operation

        A <= X"0000000000000001";
        B <= X"0000000000000005";
		wait for 10 ns;
        test("positive plus positive", "no overflow", r, X"6");
        test("positive plus positive", "no overflow flag", overflow, '0');
		
		
        A <= X"FFFFFFFFFFFFFFFF";
        B <= X"FFFFFFFFFFFFFFFE";
        wait for 10 ns;
        test("negative plus negative", "no overflow", r, X"FFFFFFFFFFFFFFFD");
        test("negative plus negative", "no overflow flag", overflow, '0');
		
        
		A <= X"0000000000000000";
        B <= X"FFFFFFFFFFFFFFFF";
		wait for 10 ns;
		test("negative plus zero", "no overflow", r, X"FFFFFFFFFFFFFFFF");
        test("negative plus zero", "no overflow flag", overflow, '0');
        
		
		A <= X"FFFFFFFFFFFFFFFB";
		B <= X"0000000000000008"; 
		wait for 10 ns;
        test("negative plus positive", "no overflow", r, X"3");
        test("negative plus positive", "no overflow fpag", overflow, '0');
		
		
		A <= X"7FFFFFFFFFFFFFFF";
		B <= X"7FFFFFFFFFFFFFFF";
		wait for 10 ns;
        test("positive plus positive", "overflow", r, X"FFFFFFFFFFFFFFFE");
        test("positive plus positive", "overflow flag", overflow, '1');
		
		
		A <= X"8000000000000000";
		B <= X"8000000000000000";
		wait for 10 ns;
		test("negative plus negative", "overflow", r, X"0");
        test("negative plus negative", "overflow flag", overflow, '1');

      wait;
   end process;

END;
