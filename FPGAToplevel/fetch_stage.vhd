library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetch_stage is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           pc_update : in STD_LOGIC;
           pc_input : in STD_LOGIC_VECTOR(31 downto 0);
           pc_incremented : out STD_LOGIC_VECTOR(31 downto 0);
           pc_signal : out STD_LOGIC_VECTOR(31 downto 0));
end fetch_stage;

architecture Behavioral of fetch_stage is

component Adder
    generic (N : NATURAL);
    port ( A			: in	STD_LOGIC_VECTOR(N-1 downto 0);
           B			: in	STD_LOGIC_VECTOR(N-1 downto 0);
		   R			: out	STD_LOGIC_VECTOR(N-1 downto 0);
		   CARRY_IN	    : in	STD_LOGIC;
		   OVERFLOW	    : out	STD_LOGIC
	);
end component;


component pc 
    port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           pc_update : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR(31 downto 0);
           addr_out : out STD_LOGIC_VECTOR(31 downto 0));
end component;

-- SIGNAL declerations
signal ground_signal : STD_LOGIC; 
signal pc_incremented_signal : STD_LOGIC_VECTOR(31 downto 0);
signal pc_out_signal         : STD_LOGIC_VECTOR(31 downto 0);

begin


          
PROGRAM_COUNTER_MAP : pc 
port map(clk => clk, 
         reset => reset, 
         pc_update => pc_update, 
         addr => pc_input, 
         addr_out => pc_out_signal);
         

PC_INCREMENTER_MAP : Adder 
generic map(N => 32)
port map( A => pc_out_signal, 
          B => "00000000000000000000000000000001", 
          R => pc_incremented_signal,
          CARRY_IN => '0',
          OVERFLOW => ground_signal);
         
         
-- Pass the incremented value and the pc addr to the next stage
pc_incremented <= pc_incremented_signal;
pc_signal <= pc_out_signal;

end Behavioral;
