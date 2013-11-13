
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY InstructionCache_tb IS
END InstructionCache_tb;
 
ARCHITECTURE behavior OF InstructionCache_tb IS 
 
    COMPONENT InstructionCache
    PORT(
         MemRq : OUT  std_logic;
         MemAck : IN  std_logic;
         MemAddr : OUT  std_logic_vector(18 downto 0);
         MemData : IN  std_logic_vector(31 downto 0);
         PCA : IN  std_logic_vector(18 downto 0);
         PCB : IN  std_logic_vector(18 downto 0);
         InstA : OUT  std_logic_vector(31 downto 0);
         InstB : OUT  std_logic_vector(31 downto 0);
         Halt : OUT  std_logic;
         Clock : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal MemAck : std_logic := '0';
   signal MemData : std_logic_vector(31 downto 0) := (others => '0');
   signal PCA : std_logic_vector(18 downto 0) := (others => '0');
   signal PCB : std_logic_vector(18 downto 0) := (others => '0');
   signal Clock : std_logic := '0';

 	--Outputs
   signal MemRq : std_logic;
   signal MemAddr : std_logic_vector(18 downto 0);
   signal InstA : std_logic_vector(31 downto 0);
   signal InstB : std_logic_vector(31 downto 0);
   signal Halt : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
   uut: InstructionCache PORT MAP (
          MemRq => MemRq,
          MemAck => MemAck,
          MemAddr => MemAddr,
          MemData => MemData,
          PCA => PCA,
          PCB => PCB,
          InstA => InstA,
          InstB => InstB,
          Halt => Halt,
          Clock => Clock
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clock_period*10;

      

      wait;
   end process;

END;
