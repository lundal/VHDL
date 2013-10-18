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
    Port ( clk                    : in  STD_LOGIC;
           reset                  : in  STD_LOGIC;
           enable                 : in  STD_LOGIC;
           
           --Control signals
           signal gene_op_in      : in  STD_LOGIC_VECTOR (GENE_OP_WIDTH-1 downto 0);
           signal cond_in         : in  STD_LOGIC_VECTOR (COND_WIDTH-1 downto 0);
           signal jump_in         : in  STD_LOGIC;
           signal mem_op_in       : in  STD_LOGIC_VECTOR (MEM_OP_WIDTH-1 downto 0);
           signal to_reg_in       : in  STD_LOGIC_VECTOR (TO_REG_OP_WIDTH-1 downto 0);
           signal call_in         : in  STD_LOGIC;
           signal overflow_in     : in  STD_LOGIC;
           
           --Control signals out 
           signal gene_op_out     : out STD_LOGIC_VECTOR (GENE_OP_WIDTH-1 downto 0);
           signal cond_out        : out STD_LOGIC_VECTOR (COND_WIDTH-1 downto 0);
           signal jump_out        : out STD_LOGIC;
           signal mem_op_out      : out STD_LOGIC_VECTOR (MEM_OP_WIDTH-1 downto 0);
           signal to_reg_out      : out STD_LOGIC_VECTOR (TO_REG_OP_WIDTH-1 downto 0);
           signal call_out        : out STD_LOGIC;
           signal overflow_out    : out STD_LOGIC;
           
           --Data in 
           signal data_in1        : in  STD_LOGIC_VECTOR  (INST_WIDTH-1 downto 0);
           signal data_in2        : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal data_in3        : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal data_in4        : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal data_in5        : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           
           --Data out
           signal data_out1       : out STD_LOGIC_VECTOR (INST_WIDTH-1 downto 0);
           signal data_out2       : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal data_out3       : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal data_out4       : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal data_out5       : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0)
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
generic map(N => DATA_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => enable,
             data_in => data_in1,
             data_out => data_out1
);


DATA_2_REGISTER : flip_flop 
generic map(N => DATA_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => enable,
             data_in => data_in2,
             data_out => data_out2
);


DATA_3_REGISTER : flip_flop 
generic map(N => DATA_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => enable, 
             data_in => data_in3,
             data_out => data_out3
);


DATA_4_REGISTER : flip_flop 
generic map(N => REG_ADDR_WIDTH)
    port map (clk => clk, 
              reset => reset, 
              enable => enable, 
              data_in => data_in4, 
              data_out => data_out4
);


CONTROL_COND : flip_flop
generic map(N => COND_WIDTH)
port map(clk => clk, 
         reset => reset,
         enable => enable,
         data_in => cond_in, 
         data_out => cond_out);
         
CONTROL_GENE_OP : flip_flop 
generic map(N => GENE_OP_WIDTH)
port map(clk => clk,
         reset => reset,
         enable => enable,
         data_in => gene_op_in, 
         data_out => gene_op_out);
         
CONTROL_TO_REG : flip_flop
generic map(N => TO_REG_OP_WIDTH)
port map(clk => clk, 
         reset => reset, 
         data_in =>to_reg_in, 
         data_out =>to_reg_out);
         
CONTROL_MEM_OP : flip_flop 
generic map(N => MEM_OP_WIDTH)
port map(clk => clk, 
         reset => reset, 
         enable => enable,
         data_in => mem_op_in, 
         data_out =>mem_op_out);



CONTROL_SIGNALS : process(clk, reset)
    begin
        if reset = '1' then 
           call_out <= '0';
           jump_out <= '0'; 
        elsif rising_edge(clk) then 
           call_in <= call_in;
           jump_in <= jump_in;
        end if;
end process CONTROL_SIGNALS;    




end Behavioral;

