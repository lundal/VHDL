
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:15:19 10/03/2013 
-- Design Name: 
-- Module Name:    write_back - Behavioral 
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

entity write_back_stage is
    Port ( 
				--Control signals in 
				to_reg : in std_logic_vector(TO_REG_OP_WIDTH-1 downto 0);
				call   : in std_logic;
				
				--Bus signals in 
				pc_incremented_in : in std_logic_vector(19-1 downto 0);
				gene_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
				res_in  : in std_logic_vector(DATA_WIDTH-1 downto 0);
				data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
				RDA_in 	: in std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
				
				-- Bus signals out
				WBA 		: out std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
				WBD 		: out std_logic_vector(DATA_WIDTH-1 downto 0));
				
end write_back_stage;

architecture Behavioral of write_back_stage is



signal WBD_out_signal : std_logic_vector(DATA_WIDTH-1 downto 0);
signal WBA_out_signal : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);


begin
multiplexor4 : entity work.multiplexor4 
	port map( sel => to_reg, 
			    in0 => gene_in, 
				 in1 => res_in, 
				 in2 =>  X"00000000000" & "0" & pc_incremented_in, 
				 in3 => data_in, 
				 output => WBD_out_signal
				
	);

multiplexor : entity work.multiplexor
	generic map(N => 5)
	port map( sel =>call, 
			    in0 => RDA_in, 
				 in1 => "11111", 
				 output => WBA_out_signal
	);


--Output signals
WBD <= WBD_out_signal;
WBA <= WBA_out_signal;


end Behavioral;