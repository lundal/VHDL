--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:55:54 11/13/2013
-- Design Name:   
-- Module Name:   C:/Users/batunges/Documents/TDT4295/VHDL/FPGAToplevel/execution_stage_tb.vhd
-- Project Name:  FPGAToplevel
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: execution_stage
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
 
ENTITY execution_stage_tb IS
END execution_stage_tb;
 
ARCHITECTURE behavior OF execution_stage_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT execution_stage
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         alu_src : IN  std_logic;
         alu_func : IN  std_logic_vector(3 downto 0);
         multiplication : IN  std_logic;
         halt : OUT  std_logic;
         stage4_reg_write : IN  std_logic;
         stage5_reg_write : IN  std_logic;
         rs : IN  std_logic_vector(63 downto 0);
         rt : IN  std_logic_vector(63 downto 0);
         immediate : IN  std_logic_vector(63 downto 0);
         rsa : IN  std_logic_vector(4 downto 0);
         rta : IN  std_logic_vector(4 downto 0);
         rda : IN  std_logic_vector(4 downto 0);
         stage4_alu_result : IN  std_logic_vector(63 downto 0);
         stage5_write_data : IN  std_logic_vector(63 downto 0);
         stage4_reg_rd : IN  std_logic_vector(4 downto 0);
         stage5_reg_rd : IN  std_logic_vector(4 downto 0);
         overflow : OUT  std_logic;
         rs_out : OUT  std_logic_vector(63 downto 0);
         rt_out : OUT  std_logic_vector(63 downto 0);
         alu_result : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal alu_src : std_logic := '0';
   signal alu_func : std_logic_vector(3 downto 0) := (others => '0');
   signal multiplication : std_logic := '0';
   signal stage4_reg_write : std_logic := '0';
   signal stage5_reg_write : std_logic := '0';
   signal rs : std_logic_vector(63 downto 0) := (others => '0');
   signal rt : std_logic_vector(63 downto 0) := (others => '0');
   signal immediate : std_logic_vector(63 downto 0) := (others => '0');
   signal rsa : std_logic_vector(4 downto 0) := (others => '0');
   signal rta : std_logic_vector(4 downto 0) := (others => '0');
   signal rda : std_logic_vector(4 downto 0) := (others => '0');
   signal stage4_alu_result : std_logic_vector(63 downto 0) := (others => '0');
   signal stage5_write_data : std_logic_vector(63 downto 0) := (others => '0');
   signal stage4_reg_rd : std_logic_vector(4 downto 0) := (others => '0');
   signal stage5_reg_rd : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal halt : std_logic;
   signal overflow : std_logic;
   signal multiplication_halt : std_logic;
   signal rs_out : std_logic_vector(63 downto 0);
   signal rt_out : std_logic_vector(63 downto 0);
   signal alu_result : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: execution_stage PORT MAP (
          clk => clk,
          reset => reset,
          alu_src => alu_src,
          alu_func => alu_func,
          multiplication => multiplication,
          halt => halt,
          stage4_reg_write => stage4_reg_write,
          stage5_reg_write => stage5_reg_write,
          rs => rs,
          rt => rt,
          immediate => immediate,
          rsa => rsa,
          rta => rta,
          rda => rda,
          stage4_alu_result => stage4_alu_result,
          stage5_write_data => stage5_write_data,
          stage4_reg_rd => stage4_reg_rd,
          stage5_reg_rd => stage5_reg_rd,
          overflow => overflow, 
          rs_out => rs_out,
          rt_out => rt_out,
          alu_result => alu_result
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		alu_src <= '0';
		alu_func <= "0010";
		multiplication <= '1';
		rs <= "0000000000000000000000000000000000000000000000000000000000001000";
		rt <= "0000000000000000000000000000000000000000000000000000000000001000"; 
		
		wait for clk_period * 2;
		
		
		
		
		
		

      wait;
   end process;

END;
