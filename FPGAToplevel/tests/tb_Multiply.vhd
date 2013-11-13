LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
 
 
ENTITY tb_Multiply IS
END tb_Multiply;
 
ARCHITECTURE behavior OF tb_Multiply IS 
 
    COMPONENT Multiplier
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Result : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Result : std_logic_vector(63 downto 0);
   
   signal clk_period : time := 10 ns;
 
BEGIN
   uut: Multiplier PORT MAP (
          A => A,
          B => B,
          Result => Result
        );

 
   stim_proc: process
   begin		
      wait for 100 ns;	
		
		A <= X"0000001B";
		B <= X"0000003C";
		wait for clk_period;
        test("", "positive times positive", result, X"0000000000000654");
		
	
		A <= X"FFFFFF1B";
		B <= X"FFFFFF1B";
        wait for clk_period;
        test("", "negative times negative", result, X"000000000000CCD9");
		
		
		A <= X"FFFFFF1B";
		B <= X"0000001B";
        wait for clk_period;
        test("mixed", "negative times positive", result, X"FFFFFFFFFFFFE7D9");
		
      wait;
   end process;

END;
