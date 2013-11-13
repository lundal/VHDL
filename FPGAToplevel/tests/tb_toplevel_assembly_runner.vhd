LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
library std;
use std.textio.all;

ENTITY tb_toplevel_assembly_runner IS
END tb_toplevel_assembly_runner;
 
ARCHITECTURE behavior OF tb_toplevel_assembly_runner IS 


 
  COMPONENT toplevel
    PORT(
      clk : IN  std_logic;
      reset : IN  std_logic;
      command : IN  std_logic_vector(0 to 31);
      bus_address_in : IN  std_logic_vector(0 to 31);
      bus_data_in : IN  std_logic_vector(0 to 31);
      status : OUT  std_logic_vector(0 to 31);
      bus_data_out : OUT  std_logic_vector(0 to 31)
     );
   END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal command : std_logic_vector(0 to 31) := (others => '0');
   signal bus_address_in : std_logic_vector(0 to 31) := (others => '0');
   signal bus_data_in : std_logic_vector(0 to 31) := (others => '0');

 	--Outputs
   signal status : std_logic_vector(0 to 31);
   signal bus_data_out : std_logic_vector(0 to 31);

   -- Clock period definitions
   constant clk_period : time := 40 ns;
	
	constant zero : std_logic_vector(0 to 31)  := "00000000000000000000000000000000";
  
  -- Used to control the COM-module
    constant CMD_IDLE	: std_logic_vector(0 to 31) := "00000000000000000000000000000000";
	constant CMD_WI	  : std_logic_vector(0 to 31) := "00000000000000000000000000000001";
	constant CMD_RD	  : std_logic_vector(0 to 31) := "00000000000000000000000000000010";
	constant CMD_WD	  : std_logic_vector(0 to 31) := "00000000000000000000000000000011";
	constant CMD_RUN	: std_logic_vector(0 to 31) := "00000000000000000000000000000100";
	
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
  uut: toplevel PORT MAP (
    clk => clk,
    reset => reset,
    command => command,
    bus_address_in => bus_address_in,
    bus_data_in => bus_data_in,
    status => status,
    bus_data_out => bus_data_out
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
  
  variable i : unsigned(31 downto 0) := X"00000000";
    FILE instruction_file  : text OPEN read_mode IS "data.instruction";
    FILE expected_memory_file  : text OPEN read_mode IS "data.expected_memory";
    VARIABLE vDatainline : line;
    VARIABLE vDatain     : bit_vector(31 DOWNTO 0);
  
  begin		
	reset <= '1';
    -- hold reset state for 20 ns.
    wait for 20 ns;
	 reset <= '0';
    
    -- read a gas program from file and dump it in the instruction memory
    while not endfile(instruction_file) LOOP
      readline (instruction_file, vDatainline);
      read (vDatainline, vDatain);
      command <= CMD_WI;
      bus_address_in <= std_logic_vector(i);
      bus_data_in <= to_stdlogicvector(vdatain);
      wait for clk_period*3;
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
      i := unsigned(i) + 1;
    END LOOP;

    -- Run CPU!
		command <= CMD_RUN;
    bus_address_in <= zero;
    bus_data_in <= zero;
    
    wait for clk_period*100;
    
    i := X"00000000";
    while not endfile(expected_memory_file) LOOP
      readline (expected_memory_file, vDatainline);
      read (vDatainline, vDatain);
      command <= CMD_RD;
      bus_address_in <= std_logic_vector(i);
      wait for clk_period*3;
      -- assert bus_data_out = to_stdlogicvector(vdatain) report "error" severity failure;
      command <= CMD_IDLE;
      wait for clk_period*3;
      i := unsigned(i) + 1;
    END LOOP;
    
    wait;
    
 end process;

END;
