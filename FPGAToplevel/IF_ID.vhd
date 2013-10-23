----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:35:50 09/30/2013 
-- Design Name: 
-- Module Name:    IF_ID - Behavioral 
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

entity IF_ID is
    generic(N : integer := 32);
    Port ( clk       : in  STD_LOGIC;
           reset     : in  STD_LOGIC;
           enable    : in  STD_LOGIC;
           data_in1  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           data_in2  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           pc_incremented_in : in std_logic_vector(INST_WIDTH-1 downto 0);
           
           data_out1 : out STD_LOGIC_VECTOR(N-1 downto 0);
           data_out2 : out STD_LOGIC_VECTOR(N-1 downto 0);
           pc_incremented_out : out std_logic_vector(INST_WIDTH-1 downto 0)
           
           );
end IF_ID;

architecture Behavioral of IF_ID is


--Component declerations
component flip_flop 
    generic(N : NATURAL);
    Port ( clk      : in std_logic;
           reset    : in std_logic;
           enable   : in std_logic;
           data_in  : in std_logic_vector(N-1 downto 0);
           data_out : out std_logic_vector(N-1 downto 0)
    );
end component flip_flop;


begin

--Mappings
INCREMENTED_REGISTER : flip_flop
generic map(N => 32)
port map (clk => clk,
          reset => reset,
          enable => enable, 
          data_in => data_in1, 
          data_out => data_out1
);


INSTRUCTION_REGISTER : flip_flop 
generic map(N => 32)
port map (clk => clk, 
          reset => reset, 
          enable => enable,
          data_in => data_in2,
          data_out => data_out2
);


end Behavioral;

