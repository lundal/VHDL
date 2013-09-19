--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:48:59 09/19/2013
-- Design Name:   
-- Module Name:   C:/Users/torbjlan/Documents/Xilinx/Adder/Adder_tbbb.vhd
-- Project Name:  Adder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Adder
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
 
ENTITY Adder_tbbb IS
END Adder_tbbb;
 
ARCHITECTURE behavior OF Adder_tbbb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Adder
    PORT(
    --     clk : IN  std_logic;
         A : IN  std_logic_vector(63 downto 0);
         B : IN  std_logic_vector(63 downto 0);
         res : OUT  std_logic_vector(63 downto 0);
         overflow : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   --signal clk : std_logic := '0';
   signal A : std_logic_vector(63 downto 0) := (others => '0');
   signal B : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal res : std_logic_vector(63 downto 0);
   signal overflow : std_logic;

   -- Clock period definitions
   --constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Adder PORT MAP (
   --       clk => clk,
          A => A,
          B => B,
          res => res,
          overflow => overflow
        );

   -- Clock process definitions
   --clk_process :process
   --begin
	--	clk <= '0';
	--	wait for clk_period/2;
	--	clk <= '1';
	--	wait for clk_period/2;
   --end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      --wait for clk_period*10;

      -- insert stimulus here 

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
