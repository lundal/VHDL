LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_PRNG IS
END tb_PRNG;
 
ARCHITECTURE behavior OF tb_PRNG IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PRNG
    generic (
        WIDTH : integer := 32
    );
    port (
       RANDOM : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
       CLK    : in  STD_LOGIC
    );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal random : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: PRNG PORT MAP (
        random => random,
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
        --Random number generator should be produsing different outputs at each clock cyccle
        wait;
    end process;
END;
