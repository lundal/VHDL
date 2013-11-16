library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fetch_stage is
    generic ( processor_id : natural);
    Port ( clk 				: in STD_LOGIC;
           reset 				: in STD_LOGIC;
           pc_update 		: in STD_LOGIC;
           pc_src 			: in STD_LOGIC; 
			  pc_jump_addr 	: in STD_LOGIC_VECTOR(19-1 downto 0);
           pc_incremented 	: out STD_LOGIC_VECTOR(19-1 downto 0);
           pc_signal 		: out STD_LOGIC_VECTOR(19-1 downto 0));
end fetch_stage;

architecture Behavioral of fetch_stage is

-- SIGNAL declerations
signal ground_signal 		  : STD_LOGIC; 
signal pc_incremented_signal : STD_LOGIC_VECTOR(19-1 downto 0) := std_logic_vector(to_unsigned(processor_id, 19));
signal pc_out_signal         : STD_LOGIC_VECTOR(19-1 downto 0) := std_logic_vector(to_unsigned(processor_id, 19));
signal pc_input_signal       : STD_LOGIC_VECTOR(19-1 downto 0) := std_logic_vector(to_unsigned(processor_id, 19));

begin



MUX : entity work.multiplexor 
generic map(N => 19)
port map(
			sel => pc_src, 
			in0 => pc_incremented_signal, 
			in1 => pc_jump_addr, 
			output => pc_input_signal);


          
PROGRAM_COUNTER_MAP : entity work.pc
generic map(default => processor_id)
port map(clk => clk, 
         reset => reset, 
         pc_update => pc_update, 
         addr => pc_input_signal, 
         addr_out => pc_out_signal);
         

PC_INCREMENTER : entity work.Adder 
generic map(N => 19)
port map( A => pc_out_signal, 
          B => "0000000000000000001", 
          R => pc_incremented_signal,
          CARRY_IN => '0',
          OVERFLOW => ground_signal);
         
         
-- Pass the incremented value and the pc addr to the next stage
pc_incremented <= pc_incremented_signal;
pc_signal <= pc_out_signal;

end Behavioral;
