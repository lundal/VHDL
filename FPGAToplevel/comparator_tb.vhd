LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY comparator_tb IS
END comparator_tb;

 
ARCHITECTURE behavior OF comparator_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  -- constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: comparator 
   generic map(N => 5)
   PORT MAP (
          in0 => in0,
          in1 => in1,
          signal_out => signal_out
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      --wait for <clock>_period*10;

      -- insert stimulus here 
      in0 <= "10100";
      in1 <= "10100";

      wait;
   end process;

END;
