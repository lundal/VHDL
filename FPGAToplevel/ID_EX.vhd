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


library WORK;
use WORK.CONSTANTS.ALL;


entity ID_EX is
    Port ( clk                          : in  STD_LOGIC;
           reset                        : in  STD_LOGIC;
           enable                       : in  STD_LOGIC;
           
           -- CONTROL SIGNALS in
           alu_src_in                   : in  STD_LOGIC;
           reg_write_in                 : in  STD_LOGIC;
           jump_in                      : in  STD_LOGIC;
           alu_func_in                  : in  STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
           cond_in                      : in  STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0);
           gene_op_in                   : in  STD_LOGIC_VECTOR(GEN_OP_WIDTH-1 downto 0);
           mem_operation_in             : in  STD_LOGIC_VECTOR(MEM_OP-1 downto 0);
           to_reg_operation_in          : in  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           
           
           -- CONTROL SIGNALS out
           alu_src_out                  : out  STD_LOGIC;
           reg_write_out                : out  STD_LOGIC;
           jump_out                     : out  STD_LOGIC;
           alu_func_out                 : out  STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
           cond_out                     : out  STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0);
           gene_op_out                  : out  STD_LOGIC_VECTOR(GEN_OP_WIDTH-1 downto 0);
           mem_operation_out            : out  STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0);
           to_reg_operation_out         : out  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           
           --DATA in
           data_in1                     : in  STD_LOGIC_VECTOR (INST_WIDTH-1 downto 0);
           data_in2                     : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_in3                     : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_in4                     : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_in5                     : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           data_in6                     : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           data_in7                     : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
          
           --DATA out
           data_out1                    : out STD_LOGIC_VECTOR (INST_WIDTH-1 downto 0);
           data_out2                    : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_out3                    : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_out4                    : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_out5                    : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           data_out6                    : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           data_out7                    : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0)
           );
end ID_EX;

architecture Behavioral of ID_EX is

--Component declerations
component flip_flop 
    generic(N : integer := 64);
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

--DATA IN/OUT mappings 
DATA_1_REGISTER : flip_flop
generic map(N => INST_WIDTH)
port map (clk => clk, 
          reset =>reset, 
          enable => enable,
          data_in => data_in1, 
          data_out => data_out1
);


DATA_2_REGISTER : flip_flop 
generic map(N => DATA_WIDTH)
port map (clk => clk, 
          reset => reset, 
          enable => enable, 
          data_in => data_in2, 
          data_out => data_out2
);

DATA_3_REGISTER : flip_flop 
generic map( N => DATA_WIDTH)
port map( clk => clk,
          reset => reset, 
          enable => enable, 
          data_in => data_in3,
          data_out => data_out3
);

DATA_4_REGISTER : flip_flop 
generic map(N => DATA_WIDTH)
port map(clk => clk, 
         reset => reset, 
         enable => enable, 
         data_in => data_in4, 
         data_out => data_out4);


DATA_5_REGISTER : flip_flop 
generic map (N => REG_ADDR_WIDTH)
port map (clk => clk, 
          reset => reset, 
          enable => enable,
          data_in => data_in5,
          data_out => data_out5
);


DATA_6_REGISTER : flip_flop 
generic map(N => REG_ADDR_WIDTH)
port map ( clk => clk,
           reset => reset, 
           enable => enable,
           data_in => data_in6,
           data_out => data_out6
);

DATA_7_REGISTER : flip_flop 
generic map(N => REG_ADDR_WIDTH)
port map (clk => clk, 
          reset => reset, 
          enable => enable,
          data_in => data_in7, 
          data_out => data_out7
);

-- Control SIGNALS mapping

CONTROL_ALU_FUNCTION : flip_flop
generic map(N => ALU_FUNC_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => enable, 
          data_in => alu_func_in, 
          data_out => alu_func_out);
          
CONTROL_CONDITION : flip_flop
generic map(N => COND_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => enable,
          data_in => cond_in, 
          data_out => cond_out);
          
CONTROL_GEN_OPERATION : flip_flop
generic map(N => GEN_OPERATION_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => enable, 
          data_in => gen_op_in, 
          data_out => gen_op_out);
          
CONTROL_MEM_OPERATION : flip_flop 
generic map(N => MEM_OPERATION_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => enable,
          data_in => mem_operation_in, 
          data_out => mem_operation_out);
          
          
CONTROL_TO_REG_OPERATION : flip_flop 
generic map(N => TO_REG_OPERATION_WIDTH)
port map( clk => clk, 
          reset => reset,
          enable => enable, 
          data_in => to_reg_operation_in, 
          data_out => to_reg_operation_out);



CONTROL_SIGNALS : process (clk)
    begin 
        if reset = '1' then 
            --Reset signals
            alu_src_out <= '0';
            reg_write_out <= '0';
            jump_out <= '0';
            
        elsif rising_edge(clk) then 
            alu_src_out <= alu_src_in;
            reg_write_out <= reg_write_in;
            jump_out <= jump_in;
        end if;
end process CONTROL_SIGNALS;

end Behavioral;

