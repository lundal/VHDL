--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:13:11 09/26/2013
-- Design Name:   
-- Module Name:   C:/Users/perthol/VHDL/FPGAToplevel/tb_ShifterVariable.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ShifterVariable
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
 
library WORK;
use WORK.ALU_CONSTANTS.ALL;
 
ENTITY tb_ShifterVariable IS
END tb_ShifterVariable;
 
ARCHITECTURE behavior OF tb_ShifterVariable IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ShifterVariable PORT MAP (
          I => I,
          O => O,
          Left => Left,
          Arith => Arith,
          Count => Count
        );
 
   -- Stimulus process
   stim_proc: process
   begin		
		-- hold reset state for 100 ns.
		wait for 100 ns;

		I <= ONE32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		Count <= "000100";

		wait for 10 ns;
		
		I <= ONE32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';
		Count <= "000100";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '0';
		Count <= "000001";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '0';
		Count <= "000001";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';
		Count <= "000011";

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';

		wait for 10 ns;
		Count <= "000011";

		

		wait;
   end process;
   
END;
