----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:40:53 09/30/2013 
-- Design Name: 
-- Module Name:    MEM_WB - Behavioral 
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

entity MEM_WB is
    Port ( clk              : in  STD_LOGIC;
           reset            : in  STD_LOGIC;
           --CONTROL in
           reg_write_in     : in STD_LOGIC;
           mem_to_reg_in    : in STD_LOGIC;
           --CONTROL out
           reg_write_out    : out STD_LOGIC;
           mem_to_reg_out   : out STD_LOGIC;
           --DATA in
           data_in1         : in STD_LOGIC_VECTOR(31 downto 0);
           data_in2         : in STD_LOGIC_VECTOR(31 downto 0);
           data_in3         : in STD_LOGIC_VECTOR(4 downto 0);
           --Data out
           data_out1        : out STD_LOGIC_VECTOR(31 downto 0);
           data_out2        : out STD_LOGIC_VECTOR(31 downto 0);
           data_out3        : out STD_LOGIC_VECTOR(4 downto 0));
end MEM_WB;

architecture Behavioral of MEM_WB is

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

DATA_1_REGISTER : flip_flop
    generic map(N => 32)
    port map (clk => clk, 
              reset => reset, 
              enable => '1', 
              data_in => data_in1, 
              data_out => data_out1
);

DATA_2_REGISTER : flip_flop 
    generic map(N => 32)
    port map (clk => clk, 
              reset => reset, 
              enable => '1', 
              data_in => data_in2, 
              data_out => data_out2
);


DATA_3_REGISTER : flip_flop 
    generic map(N => 5)
    port map(clk => clk, 
             reset => reset, 
             enable => '1', 
             data_in => data_in3, 
             data_out => data_out3
);



CONTROL_SIGNALS : process(clk, reset) 
    begin 
        if reset = '1' then 
            mem_to_reg_out <= '0';
        
        elsif rising_edge(clk) then 
            mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
            
        end if;
        
end process CONTROL_SIGNALS;





end Behavioral;

