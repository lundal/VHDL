----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:07 10/14/2013 
-- Design Name: 
-- Module Name:    genetic_pipeline - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity genetic_pipeline is
	generic (N : integer :=64; O : integer :=32);
    Port (
				enabled : in STD_LOGIC;
				input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				output1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				output2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end genetic_pipeline;

architecture Behavioral of genetic_pipeline is

begin

--Crossover_core_advanced used for crossover from 2 parens to 2 children
component crossover_core_advanced
	--generic (N:integer; O: integer);
	port (
				enabled : in STD_LOGIC;
				random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
				parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				child2 : out  STD_LOGIC_VECTOR (N-1 downto 0)
			);
end component crossover_core_advanced;

end Behavioral;

