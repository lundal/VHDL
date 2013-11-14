library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity EX_MEM is
    Port ( clk                    : in  STD_LOGIC;
           reset                  : in  STD_LOGIC;
           halt                   : in  STD_LOGIC;
           
           -- PC in
           pc_incremented_in : in std_logic_vector(19-1 downto 0);
           
           -- PC out
           pc_incremented_out : out std_logic_vector(19-1 downto 0);
           
           --Control signals
           signal gene_op_in      : in  STD_LOGIC_VECTOR (GENE_OP_WIDTH-1 downto 0);
           signal cond_in         : in  STD_LOGIC_VECTOR (COND_WIDTH-1 downto 0);
           signal jump_in         : in  STD_LOGIC;
           signal mem_op_in       : in  STD_LOGIC_VECTOR (MEM_OP_WIDTH-1 downto 0);
           signal to_reg_in       : in  STD_LOGIC_VECTOR (TO_REG_OP_WIDTH-1 downto 0);
           signal call_in         : in  STD_LOGIC;
           signal overflow_in     : in  STD_LOGIC;
			  signal reg_write_in 	 : in  STD_LOGIC;
           
           --Control signals out 
           signal gene_op_out     : out STD_LOGIC_VECTOR (GENE_OP_WIDTH-1 downto 0);
           signal cond_out        : out STD_LOGIC_VECTOR (COND_WIDTH-1 downto 0);
           signal jump_out        : out STD_LOGIC;
           signal mem_op_out      : out STD_LOGIC_VECTOR (MEM_OP_WIDTH-1 downto 0);
           signal to_reg_out      : out STD_LOGIC_VECTOR (TO_REG_OP_WIDTH-1 downto 0);
           signal call_out        : out STD_LOGIC;
           signal overflow_out    : out STD_LOGIC;
			  signal reg_write_out   : out STD_LOGIC;
           
           --Data in 
           signal rs_in        : in  STD_LOGIC_VECTOR  (DATA_WIDTH-1 downto 0);
           signal rt_in        : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal res_in        : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal rda_in        : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
           
           --Data out
           signal rs_out       : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal rt_out       : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal res_out       : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           signal rda_out       : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0)
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


PC_INCREMENTED : flip_flop 
generic map(N => 19)
	port map (clk => clk, 
			    reset => reset, 
				 enable => halt, 
				 data_in => pc_incremented_in, 
				 data_out => pc_incremented_out);

RS_REGISTER : flip_flop
generic map(N => DATA_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => halt,
             data_in => rs_in,
             data_out => rs_out
);


RT_REGISTER : flip_flop
generic map(N => DATA_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => halt,
             data_in => rt_in,
             data_out => rt_out
);


RES_REGISTER : flip_flop
generic map(N => DATA_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => halt, 
             data_in => res_in,
             data_out => res_out
);


RDA_REGISTER : flip_flop
generic map(N => REG_ADDR_WIDTH)
    port map (clk => clk, 
              reset => reset, 
              enable => halt, 
              data_in => rda_in,
              data_out => rda_out
);


CONTROL_COND : flip_flop
generic map(N => COND_WIDTH)
port map(clk => clk, 
         reset => reset,
         enable => halt,
         data_in => cond_in, 
         data_out => cond_out);
         
CONTROL_GENE_OP : flip_flop
generic map(N => GENE_OP_WIDTH)
port map(clk => clk,
         reset => reset,
         enable => halt,
         data_in => gene_op_in, 
         data_out => gene_op_out);
         
CONTROL_TO_REG : flip_flop
generic map(N => TO_REG_OP_WIDTH)
port map(clk => clk, 
         reset => reset, 
         enable => halt, 
   		data_in =>to_reg_in, 
         data_out =>to_reg_out);
         
CONTROL_MEM_OP : flip_flop
generic map(N => MEM_OP_WIDTH)
port map(clk => clk, 
         reset => reset, 
         enable => halt,
         data_in => mem_op_in, 
         data_out =>mem_op_out);



CONTROL_SIGNALS : process(clk, reset, halt)
    begin
        if reset = '1' then 
           call_out <= '0';
           jump_out <= '0'; 
			  reg_write_out <= '0';
        elsif rising_edge(clk) and halt = '0' then 
           call_out <= call_in;
           jump_out <= jump_in;
			  reg_write_out <= reg_write_in; 
        end if;
end process CONTROL_SIGNALS;    




end Behavioral;

