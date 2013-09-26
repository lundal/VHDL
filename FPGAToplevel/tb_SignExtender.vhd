--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:56:35 09/26/2013
-- Design Name:   
-- Module Name:   C:/Users/perthol/VHDL/FPGAToplevel/tb_SignExtender.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SignExtender
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
 
ENTITY tb_SignExtender IS
END tb_SignExtender;
 
ARCHITECTURE behavior OF tb_SignExtender IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SignExtender
    PORT(
         I : IN  std_logic_vector(31 downto 0);
         O : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal O : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SignExtender PORT MAP (
          I => I,
          O => O
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      
      I <= "00000000000000000000000000000000";
	  
	  wait for 10 ns;
	  
	  I <= "01010101010101010101010101010101";
	  
	  wait for 10 ns;
	  
	  I <= "11111111111111111111111111111111";
      
      wait;
   end process;

END;
