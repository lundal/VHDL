--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:20:52 09/26/2013
-- Design Name:   
-- Module Name:   C:/Users/perthol/VHDL/FPGAToplevel/tb_Shifter.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Shifter
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
 
ENTITY tb_Shifter IS
END tb_Shifter;
 
ARCHITECTURE behavior OF tb_Shifter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Shifter
	generic (
		N : natural := 64;
		M : natural := 1
	);
    port (
		I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		Left	:	in	STD_LOGIC;
		Arith	:	in	STD_LOGIC
	);
    END COMPONENT;
    

   --Inputs
   signal I : std_logic_vector(63 downto 0) := (others => '0');
   signal Left : std_logic := '0';
   signal Arith : std_logic := '0';

 	--Outputs
   signal O : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Shifter
   generic map (
		N => 64,
		M => 3
	)
   port map (
		I => I,
		O => O,
		Left => Left,
		Arith => Arith
	);
 

   -- Stimulus process
   stim_proc: process
   begin		
		-- hold reset state for 100 ns.
		wait for 100 ns;

		I <= ONE32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';

		wait for 10 ns;
		
		I <= ONE32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '0';

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '0';

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '1';
		Arith <= '1';

		wait for 10 ns;

		I <= ZERO32 & "00000000000000000000000000010000";
		Left <= '0';
		Arith <= '1';

		wait for 10 ns;

		

		wait;
   end process;

END;
