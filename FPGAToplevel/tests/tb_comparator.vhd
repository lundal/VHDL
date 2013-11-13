LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
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

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- Equal output: 00
      in0 <= "10100";
      in1 <= "10100";
		
		wait for 40 ns;
		
		-- Less output: 01
		in0 <= "10010";
      in1 <= "10100";
		
		wait for 40 ns;
		
		-- Greater output: 10
		in0 <= "10100";
		in1 <= "10010";

      wait;
   end process;

END;
