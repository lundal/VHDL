LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_Multiply IS
END tb_Multiply;
 
ARCHITECTURE behavior OF tb_Multiply IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Multiplier
    PORT(
         A : IN  std_logic_vector(63 downto 0);
         B : IN  std_logic_vector(63 downto 0);
         Result : OUT  std_logic_vector(63 downto 0);
         Overflow : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(63 downto 0) := (others => '0');
   signal B : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal Result : std_logic_vector(63 downto 0);
   signal Overflow : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Multiplier PORT MAP (
          A => A,
          B => B,
          Result => Result,
          Overflow => Overflow
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 100 ns;	
		
		-- OK
		A <= X"000000000000001B";
		B <= X"000000000000003C";
		
		wait for 100 ns;
		
		-- Overflow
		A <= X"012323232311111B";
		B <= X"0000F0000000003C";
		
		wait for 100 ns;
		
		-- OK
		A <= X"FFFFFFFFFFFFFF1B";
		B <= X"FFFFFFFFFFFFFF3C";
		
		wait for 100 ns;
		
		-- Overflow
		A <= X"FFF3FFFFFFFFFF1B";
		B <= X"FFF1FFFEEEEEEE3C";
		
		wait for 100 ns;
		
		-- OK
		A <= X"FFFFFFFFFFFFFF1B";
		B <= X"000000000000003C";
		
		wait for 100 ns;
		
		-- Overflow
		A <= X"FFF3FFFFFFFFFF1B";
		B <= X"021000000000003C";
		
      wait;
   end process;

END;
