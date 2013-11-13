library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 


library WORK;
use WORK.CONSTANTS.ALL;


entity ID_EX is
    Port ( clk                          : in  STD_LOGIC;
           reset                        : in  STD_LOGIC;
           halt                         : in  STD_LOGIC;
           
           -- PC in
           pc_incremented_in : in std_logic_vector(INST_WIDTH-1 downto 0);
           
           -- PC out
           pc_incremented_out : out std_logic_vector(INST_WIDTH-1 downto 0);
           
           -- CONTROL SIGNALS in
           alu_src_in                   : in  STD_LOGIC;
           reg_write_in                 : in  STD_LOGIC;
           jump_in                      : in  STD_LOGIC;
           alu_func_in                  : in  STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
           cond_in                      : in  STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0);
           gene_op_in                   : in  STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0);
           mem_operation_in             : in  STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0);
           to_reg_operation_in          : in  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           call_in							 : in  STD_LOGIC;
           
           -- CONTROL SIGNALS out
           alu_src_out                  : out  STD_LOGIC;
           reg_write_out                : out  STD_LOGIC;
           jump_out                     : out  STD_LOGIC;
           alu_func_out                 : out  STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
           cond_out                     : out  STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0);
           gene_op_out                  : out  STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0);
           mem_operation_out            : out  STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0);
           to_reg_operation_out         : out  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           call_out                     : out  STD_LOGIC;
           
			  --DATA in
           rs_in                     : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           rt_in                     : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           imm_in                     : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           rsa_in                     : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           rta_in                     : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           rda_in                     : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
          
           --DATA out
           rs_out                    : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           rt_out                    : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           imm_out                    : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           rsa_out                    : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           rta_out                    : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           rda_out                    : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0)
           );
end ID_EX;

architecture Behavioral of ID_EX is

--Component declerations
component flip_flop 
    generic(N : integer := DATA_WIDTH);
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

PC_INCREMENTED : flip_flop
generic map(N => INST_WIDTH)
port map(clk => clk, 
			reset => reset, 
			enable => halt, 
			data_in => pc_incremented_in, 
			data_out => pc_incremented_out);


RS_REGISTER : flip_flop
generic map(N => DATA_WIDTH)
port map (clk => clk, 
          reset =>reset, 
          enable => halt,
          data_in => rs_in,
          data_out => rs_out
);


RT_REGISTER : flip_flop 
generic map(N => DATA_WIDTH)
port map (clk => clk, 
          reset => reset, 
          enable => halt, 
          data_in => rt_in,
          data_out => rt_out
);

IMM_REGISTER : flip_flop 
generic map( N => DATA_WIDTH)
port map( clk => clk,
          reset => reset, 
          enable => halt, 
          data_in => imm_in,
          data_out => imm_out
);

RSA_REGISTER : flip_flop 
generic map(N => REG_ADDR_WIDTH)
port map(clk => clk, 
         reset => reset, 
         enable => halt, 
         data_in => rsa_in,
         data_out => rsa_out);


RTA_REGISTER : flip_flop 
generic map (N => REG_ADDR_WIDTH)
port map (clk => clk, 
          reset => reset, 
          enable => halt,
          data_in => rta_in,
          data_out => rta_out
);


RDA_REGISTER : flip_flop 
generic map(N => REG_ADDR_WIDTH)
port map ( clk => clk,
           reset => reset, 
           enable => halt,
           data_in => rda_in,
           data_out => rda_out
);

-- Control SIGNALS mapping

CONTROL_ALU_FUNCTION : flip_flop
generic map(N => ALU_FUNC_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => halt, 
          data_in => alu_func_in,
          data_out => alu_func_out);
          
CONTROL_CONDITION : flip_flop
generic map(N => COND_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => halt,
          data_in => cond_in,
          data_out => cond_out);
          
CONTROL_GEN_OPERATION : flip_flop
generic map(N => GENE_OP_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => halt, 
          data_in => gene_op_in,
          data_out => gene_op_out);
          
CONTROL_MEM_OPERATION : flip_flop 
generic map(N => MEM_OP_WIDTH)
port map( clk => clk, 
          reset => reset, 
          enable => halt,
          data_in => mem_operation_in,
          data_out => mem_operation_out);
          
          
CONTROL_TO_REG_OPERATION : flip_flop 
generic map(N => TO_REG_OP_WIDTH)
port map( clk => clk, 
          reset => reset,
          enable => halt, 
          data_in => to_reg_operation_in,
          data_out => to_reg_operation_out);



CONTROL_SIGNALS : process (clk, reset, halt)
    begin 
        if reset = '1' then 
            --Reset signals
            alu_src_out <= '0';
            reg_write_out <= '0';
            jump_out <= '0';
				call_out <= '0';
            
        elsif rising_edge(clk) and halt = '0' then 
				alu_src_out <= alu_src_in;
            reg_write_out <= reg_write_in;
            jump_out <= jump_in;
				call_out <= call_in;
        end if;
end process CONTROL_SIGNALS;

end Behavioral;

