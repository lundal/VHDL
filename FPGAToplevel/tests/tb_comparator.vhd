LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.test_utils.all;
 
 
ENTITY tb_comparator IS
END tb_comparator;

 
ARCHITECTURE behavior OF tb_comparator IS 
 
    COMPONENT comparator
    generic(N: NATURAL);
    PORT(
         in0 : IN  std_logic_vector(N-1 downto 0);
         in1 : IN  std_logic_vector(N-1 downto 0);
         signal_out : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal in0 : std_logic_vector(4 downto 0) := (others => '0');
   signal in1 : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal signal_out : std_logic_vector(1 downto 0);
 
BEGIN
 
   uut: comparator 
   generic map(N => 5)
   PORT MAP (
          in0 => in0,
          in1 => in1,
          signal_out => signal_out
        );

   stim_proc: process
   begin		
        wait for 100 ns;	

        in0 <= "10100";
        in1 <= "10100";
		wait for 10 ns;
        test("equal", "", signal_out, "00");
		
        
		in0 <= "10010";
        in1 <= "10100";
		wait for 10 ns;
        test("less",  "", signal_out, "01");
		

		in0 <= "10100";
		in1 <= "10010";
        wait for 10 ns;
        test("greater", "", signal_out, "10");


      wait;
   end process;

END;
