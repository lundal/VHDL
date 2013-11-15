LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY tb_fakeinstmem IS
END tb_fakeinstmem;
 
ARCHITECTURE behavior OF tb_fakeinstmem IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FakeInstMem
    PORT(
         IMEM_CE_HI : IN  std_logic;
         IMEM_CE_LO : IN  std_logic;
         IMEM_WE_HI : IN  std_logic;
         IMEM_WE_LO : IN  std_logic;
         IMEM_DATA_HI : OUT  std_logic_vector(15 downto 0);
         IMEM_DATA_LO : OUT  std_logic_vector(15 downto 0);
         IMEM_ADDR : IN  std_logic_vector(18 downto 0);
         IMEM_LBUB : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal IMEM_CE_HI : std_logic := '0';
   signal IMEM_CE_LO : std_logic := '0';
   signal IMEM_WE_HI : std_logic := '0';
   signal IMEM_WE_LO : std_logic := '0';
   signal IMEM_ADDR : std_logic_vector(18 downto 0) := (others => '0');
   signal IMEM_LBUB : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal IMEM_DATA_HI : std_logic_vector(15 downto 0);
   signal IMEM_DATA_LO : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FakeInstMem PORT MAP (
          IMEM_CE_HI => IMEM_CE_HI,
          IMEM_CE_LO => IMEM_CE_LO,
          IMEM_WE_HI => IMEM_WE_HI,
          IMEM_WE_LO => IMEM_WE_LO,
          IMEM_DATA_HI => IMEM_DATA_HI,
          IMEM_DATA_LO => IMEM_DATA_LO,
          IMEM_ADDR => IMEM_ADDR,
          IMEM_LBUB => IMEM_LBUB,
          clk => clk
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

        
        IMEM_CE_HI <= '0';
        IMEM_CE_LO <= '0';
        IMEM_WE_HI <= '0';
        IMEM_WE_LO <= '0';
        IMEM_ADDR <= "0000000000000000000";
        IMEM_LBUB <= '0';

      wait;
   end process;

END;
