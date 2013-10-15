----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:39:10 09/30/2013 
-- Design Name: 
-- Module Name:    ID_EX - Behavioral 
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
use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_EX is
    Port ( clk                          : in  STD_LOGIC;
           reset                        : in  STD_LOGIC;
           --SIGNALS in
           reg_dst_in                   : in  STD_LOGIC;
           alu_op_in                    : in  STD_LOGIC_VECTOR(1 downto 0);
           alu_src_in                   : in  STD_LOGIC;
           branch_in                    : in  STD_LOGIC;
           mem_read_in                  : in  STD_LOGIC;
           mem_write_in                 : in  STD_LOGIC;
           reg_write_in                 : in  STD_LOGIC;
           mem_to_reg_in                : in  STD_LOGIC;
           --SIGNALS out
           reg_dst_out                  : out STD_LOGIC;
           alu_op_out                   : out STD_LOGIC_VECTOR(1 downto 0);
           alu_src_out                  : out STD_LOGIC;
           branch_out                   : out STD_LOGIC;
           mem_read_out                 : out STD_LOGIC;
           mem_write_out                : out STD_LOGIC;
           reg_write_out                : out STD_LOGIC;
           mem_to_reg_out               : out STD_LOGIC;
           --DATA in
           data_in1                     : in  STD_LOGIC_VECTOR (31 downto 0);
           data_in2                     : in  STD_LOGIC_VECTOR (31 downto 0);
           data_in3                     : in  STD_LOGIC_VECTOR (31 downto 0);
           data_in4                     : in  STD_LOGIC_VECTOR (31 downto 0);
           data_in5                     : in  STD_LOGIC_VECTOR (4 downto 0);
           data_in6                     : in  STD_LOGIC_VECTOR (4 downto 0);
           --DATA out
           data_out1                    : out STD_LOGIC_VECTOR (31 downto 0);
           data_out2                    : out STD_LOGIC_VECTOR (31 downto 0);
           data_out3                    : out STD_LOGIC_VECTOR (31 downto 0);
           data_out4                    : out STD_LOGIC_VECTOR (31 downto 0);
           data_out5                    : out STD_LOGIC_VECTOR (4 downto 0);
           data_out6                    : out STD_LOGIC_VECTOR (4 downto 0)
           );
end ID_EX;

architecture Behavioral of ID_EX is

--Component declerations
component flip_flop 
    generic(N : integer := 32);
    Port ( clk      : in std_logic;
           reset    : in std_logic;
           enable   : in std_logic;
           data_in  : in std_logic_vector(N-1 downto 0);
           data_out : out std_logic_vector(N-1 downto 0)
    );
end component flip_flop;


--Signals 


begin

-- Mappings
--WIRES based on the instruction  
DATA_1_REGISTER : flip_flop
generic map(N => 32)
port map (clk => clk, 
          reset =>reset, 
          enable => '1', -- Not sure yet 
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
generic map( N => 32)
port map( clk => clk,
          reset => reset, 
          enable => '1', 
          data_in => data_in3,
          data_out => data_out3
);


DATA_4_REGISTER : flip_flop 
generic map (N => 32)
port map (clk => clk, 
          reset => reset, 
          enable => '1',
          data_in => data_in4,
          data_out => data_out4
);


DATA_5_REGISTER : flip_flop 
generic map(N => 5)
port map ( clk => clk,
           reset => reset, 
           enable => '1',
           data_in => data_in5,
           data_out => data_out5
);

DATA_6_REGISTER : flip_flop 
generic map(N => 5)
port map (clk => clk, 
          reset => reset, 
          enable => '1',
          data_in => data_in6, 
          data_out => data_out6
);

-- Control SIGNALS
CONTROL_SIGNALS : process (clk)
    begin 
        if reset = '1' then 
            --Reset signals
            reg_write_out <= '0';
            mem_write_out <= '0';
        elsif rising_edge(clk) then 
            reg_dst_out <= reg_dst_in;
            alu_op_out <= alu_op_in;
            alu_src_out <= alu_src_in;
            branch_out <= branch_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in; 
        end if;
end process CONTROL_SIGNALS;

end Behavioral;

