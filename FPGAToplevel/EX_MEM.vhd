----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:40:08 09/30/2013 
-- Design Name: 
-- Module Name:    EX_MEM - Behavioral 
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

entity EX_MEM is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           --Control signals
           signal branch_in       : in STD_LOGIC;
           signal mem_read_in     : in STD_LOGIC;
           signal mem_write_in    : in STD_LOGIC;
           signal reg_write_in    : in STD_LOGIC;
           signal mem_to_reg_in   : in STD_LOGIC;
           --Control signals out 
           signal branch_out      : out STD_LOGIC;
           signal mem_read_out    : out STD_LOGIC;
           signal mem_write_out   : out STD_LOGIC;
           signal reg_write_out   : out STD_LOGIC;
           signal mem_to_reg_out  : out STD_LOGIC;
           --Data in 
           signal data_in1        : in STD_LOGIC_VECTOR(31 downto 0);
           signal data_in2        : in STD_LOGIC_VECTOR(31 downto 0);
           signal data_in3        : in STD_LOGIC_VECTOR (31 downto 0);
           signal data_in4        : in STD_LOGIC_VECTOR (4 downto 0);
           --Data out
           signal data_out1       : out STD_LOGIC_VECTOR(31 downto 0);
           signal data_out2       : out STD_LOGIC_VECTOR(31 downto 0);
           signal data_out3       : out STD_LOGIC_VECTOR(31 downto 0);
           signal data_out4       : out STD_LOGIC_VECTOR(4 downto 0)
           );
end EX_MEM;

architecture Behavioral of EX_MEM is

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

--Signal declerations 


begin

--Signals are represented from top to bottom (see pipeline figure)

DATA_1_REGISTER : flip_flop 
generic map(N => 32)
    port map(clk => clk, 
             reset => reset, 
             enable => '1',
             data_in => data_in1,
             data_out => data_out1
);


DATA_2_REGISTER : flip_flop 
generic map(N => 32)
    port map(clk => clk, 
             reset => reset, 
             enable => '1',
             data_in => data_in2,
             data_out => data_out2
);


DATA_3_REGISTER : flip_flop 
generic map(N => 32)
    port map(clk => clk, 
             reset => reset, 
             enable => '1', 
             data_in => data_in3,
             data_out => data_out3
);


DATA_4_REGISTER : flip_flop 
generic map(N => 5)
    port map (clk => clk, 
              reset => reset, 
              enable => '1', 
              data_in => data_in4, 
              data_out => data_out4
);




CONTROL_SIGNALS : process(clk, reset)
    begin
        if reset = '1' then 
            mem_write_out <= '0';
            reg_write_out <= '0';
            
        elsif rising_edge(clk) then 
            branch_out <= branch_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end if;
end process CONTROL_SIGNALS;    




end Behavioral;

