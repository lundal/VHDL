LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_adder IS
END tb_adder;
 
ARCHITECTURE behavior OF tb_adder IS 
 
    COMPONENT Adder
    PORT(
         A : IN  std_logic_vector(63 downto 0);
         B : IN  std_logic_vector(63 downto 0);
         res : OUT  std_logic_vector(63 downto 0);
         overflow : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal A : std_logic_vector(63 downto 0) := (others => '0');
   signal B : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal res : std_logic_vector(63 downto 0);
   signal overflow : std_logic;
 
BEGIN
 
   uut: Adder PORT MAP (
          A => A,
          B => B,
          res => res,
          overflow => overflow
        );
        

   stim_proc: process
   begin		
      wait for 100 ns;	


		A <= (63 downto 0 => '0');
		B <= (63 downto 0 => '0');
		
		--1: 1 + 1 = 2 (= ..10)
		A(0) <= '1';
		B(0) <= '1';
		
		wait for 20 ns;
		
		--2: Reset
		A <= (63 downto 0 => '0');
		B <= (63 downto 0 => '0');
		
		wait for 20 ns;
		
		--3: 16 + (16 + 32) = 64 ( ..01000000)
		A(4) <= '1';
		B(4) <= '1';
		B(5) <= '1';
		
		
		wait for 20 ns;
		
		--4: (-1) + (-1) = -2 (1...11110)
		A <= (63 downto 0 => '1');
		B <= (63 downto 0 => '1');
		
		wait for 20 ns;
		
		--5: 0 + (-1) = -1 (1....111)
		A <= (63 downto 0 => '0');
		
		wait for 20 ns;
		
		--6: (-12) + (-15) = -27 (1...1101111)
		A <= (63 downto 0 => '1');
		B <= (63 downto 0 => '1');
		
		A(0)<= '0';
		A(2)<= '0';
		A(3)<= '0';
		
		B(1)<= '0';
		B(2)<= '0';
		B(3)<= '0';
		
		
		wait for 20 ns;
		
		--7: Reset
		A <= (63 downto 0 => '0');
		B <= (63 downto 0 => '0');
		
		wait for 20 ns;
		
		--8: (-5) + 8 = 3 (00...0011)
		A <= (63 downto 0 => '1');
		A(2) <= '0';
		B(3) <='1'; 
		
		wait for 20 ns;
		
		--9: Reset
		A <= (63 downto 0 => '0');
		B <= (63 downto 0 => '0');
		
		wait for 20 ns;
		
		--10: 5 + (-12) = -7 (11...1001)
		A(0) <='1'; 
		A(2) <='1';
		B <= (63 downto 0 => '1');
		B(0) <= '0';
		B(1) <= '0';
		B(3) <= '0';
		
		wait for 20 ns;
		
		--11: Reset
		A <= (63 downto 0 => '0');
		B <= (63 downto 0 => '0');
		
		wait for 20 ns;
		
		--12: Causing positive overflow: 1 (010... -> 100...)
		A <= (63 downto 0 => '1');
		B <= (63 downto 0 => '1');
		A(63) <='0';
		B(63) <='0';
		
		wait for 20 ns;
		
		--13: Reset
		A <= (63 downto 0 => '0');
		B <= (63 downto 0 => '0');
		
		wait for 20 ns;
		
		--14: Causing negative overflow: 1 (1000.... -> 000...)
		A(63) <='1';
		B(63) <='1';

		wait for 20 ns;
		
		--15: Reset and end
		A <= (63 downto 0 => '0');
		B <= (63 downto 0 => '0');

      wait;
   end process;

END;
