LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_bram IS
END tb_bram;
 
ARCHITECTURE behavior OF tb_bram IS 
 
    COMPONENT BRAM_TDP
    PORT(
         A_ADDR : IN  std_logic_vector(8 downto 0);
         A_IN : IN  std_logic_vector(31 downto 0);
         A_OUT : OUT  std_logic_vector(31 downto 0);
         A_WE : IN  std_logic;
         A_EN : IN  std_logic;
         B_ADDR : IN  std_logic_vector(8 downto 0);
         B_IN : IN  std_logic_vector(31 downto 0);
         B_OUT : OUT  std_logic_vector(31 downto 0);
         B_WE : IN  std_logic;
         B_EN : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A_ADDR : std_logic_vector(8 downto 0) := (others => '0');
   signal A_IN : std_logic_vector(31 downto 0) := (others => '0');
   signal A_WE : std_logic := '0';
   signal A_EN : std_logic := '0';
   signal B_ADDR : std_logic_vector(8 downto 0) := (others => '0');
   signal B_IN : std_logic_vector(31 downto 0) := (others => '0');
   signal B_WE : std_logic := '0';
   signal B_EN : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal A_OUT : std_logic_vector(31 downto 0);
   signal B_OUT : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
   uut: BRAM_TDP PORT MAP (
          A_ADDR => A_ADDR,
          A_IN => A_IN,
          A_OUT => A_OUT,
          A_WE => A_WE,
          A_EN => A_EN,
          B_ADDR => B_ADDR,
          B_IN => B_IN,
          B_OUT => B_OUT,
          B_WE => B_WE,
          B_EN => B_EN,
          CLK => CLK
        );

   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

	stim_proc: process
	begin		
		wait for 100 ns;	
		
		wait for CLK_period*10;
		
		A_ADDR <= "000000001";
		A_IN <= X"00000002";
		A_EN <= '1';
		A_WE <= '1';
		
		B_ADDR <= "000000011";
		B_IN <= X"00000004";
		B_EN <= '1';
		B_WE <= '1';
		
		wait for CLK_period;
		
		A_ADDR <= "000000010";
		A_IN <= X"00000003";
		A_EN <= '1';
		A_WE <= '1';
		
		B_ADDR <= "000000100";
		B_IN <= X"00000005";
		B_EN <= '1';
		B_WE <= '1';
		
		wait for CLK_period;
		
		A_ADDR <= "000000011";
		A_EN <= '1';
		A_WE <= '0';
		
		B_ADDR <= "000000001";
		B_EN <= '1';
		B_WE <= '0';
		
		wait for CLK_period;
		
		A_ADDR <= "000000100";
		A_EN <= '1';
		A_WE <= '0';
		
		B_ADDR <= "000000010";
		B_EN <= '1';
		B_WE <= '0';
		
		wait;
	end process;

END;
