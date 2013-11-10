----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:38:11 11/10/2013 
-- Design Name: 
-- Module Name:    Branching_unit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONSTANTS.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Branching_unit is
	Port(
		  --Bit signals
		  clk : in std_logic;
		  reset : in std_logic;
		  
		  --Control signal
		  cond_op : in std_logic_vector(COND_WIDTH-1 downto 0);
		  overflow : in std_logic;
		  res 		: in std_logic_vector(DATA_WIDTH-1 downto 0);
		  
		  --Control signals out
		  exec		: out std_logic
			
		  --Output control signals
	
	);
end Branching_unit;
signal stored_condition_code : std_logic_vector(COND_WIDTH-1 downto 0);
signal condition_code  : std_logic_vector(COND_WIDTH-1 downto 0);


type state_type is (STATE_READY, STATE_BRANCH);

signal CURRENT_STATE, NEXT_STATE: state_type;

architecture Behavioral of Branching_unit is

begin

--
--RUN : process(clk)
--begin 
--	if reset = '1' then 
--		CURRENT_STATE <= STATE_READY;
--	elsif rising_edge(clk) then 
--		CURRENT_STATE <= NEXT_STATE;
--	end if;
--end process;
		
	

flip_flop : entity work.flip_flop 
	port map(clk =>clk, 
				reset => reset,
				enable => '0', 
				data_in => condition_code, 
				data_out => stored_condition_code);
				


conditional_unit : entity work.conditional_unit 
generic map(N => 64)
port map (
		     COND => condition_code,
			  ALU_RES => res,
			  ALU_OVF => overflow,
		     EXEC => exec
	);

end Behavioral;


