library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- TODO: we should use numeric_std instead of std_logic_arith here.
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;
use WORK.CONSTANTS.ALL;


entity decode_stage is
    port( clk                   : in STD_LOGIC;
          reset                 : in STD_LOGIC;
          processor_enable      : in STD_LOGIC;
          
          --Control signals
          reg_write             : in STD_LOGIC;
          imm_src               : in STD_LOGIC;
          reg_src               : in STD_LOGIC;
          reg_store             : in STD_LOGIC;
          
          --Input signals
          instruction           : in STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
          write_data            : in STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
          write_register        : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          
          --Output signals
          rs            		  : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
          rt                    : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
          immediate             : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
          rsa                   : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          rta                   : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          rda                   : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          condition_out         : out STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0));
          
end decode_stage;

architecture Behavioral of decode_stage is

-- COMPONENT declerations
component multiplexor
    generic(N                   : integer);
    Port ( sel                  : in  STD_LOGIC;
           in0                  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1                  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output               : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component register_file 
    port (CLK                   : in  STD_LOGIC;
          RESET                 : in  STD_LOGIC;
          RW                    : in  STD_LOGIC; 
          RS_ADDR               : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0); 
          RT_ADDR               : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          RD_ADDR               : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          WRITE_DATA            : in  STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
          RS                    : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0);
          RT                    : out STD_LOGIC_VECTOR(REG_WIDTH-1 downto 0));
end component;

-- Signal declerations
signal rd_addr_internal                 : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal rsa_internal                 : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal rt_addr_internal                 : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
signal immediate_value_internal         : std_logic_vector(9 downto 0);
signal immediate_address_internal       : std_logic_vector(18 downto 0);
signal immediate_value_out_internal     : std_logic_vector(DATA_WIDTH -1 downto 0);
signal immediate_address_out_internal   : std_logic_vector(DATA_WIDTH-1 downto 0);
signal condition_internal               : std_logic_vector(3 downto 0);
signal rs_signal 								 : std_logic_vector(DATA_WIDTH-1 downto 0);
signal rt_signal 								 : std_logic_vector(DATA_WIDTH-1 downto 0); 

--Output from multiplexors
signal reg_op1                          : std_logic_vector (REG_ADDR_WIDTH-1 downto 0);
signal reg_op2                          : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);




begin

REG_SRC_MUX_MAP : multiplexor
generic map(N => REG_ADDR_WIDTH)
port map( sel => reg_src, 
          in0 =>rsa_internal, 
          in1 => rd_addr_internal, 
          output => reg_op1);

REG_STORE_MUX_MAP : multiplexor 
generic map(N => REG_ADDR_WIDTH)
port map(sel => reg_store, 
        in0 =>rt_addr_internal, 
        in1 =>rd_addr_internal, 
        output =>reg_op2);
        

IMM_MUX_MAP : multiplexor 
generic map(N => DATA_WIDTH)
port map(sel =>imm_src, 
         in0 =>immediate_value_out_internal, 
         in1 => immediate_address_out_internal, 
         output => immediate); 


REGISTER_FILE_MAP : register_file
port map (CLK => clk, 
          RESET => reset, 
          RW => reg_write, 
          RS_ADDR => reg_op1, 
          RT_ADDR => reg_op2, 
          RD_ADDR => write_register, 
          WRITE_DATA => write_data, 
          RS => rs_signal, 
          RT => rt_signal);
 
FORWARDING_RS : process(reg_op1, rs_signal, write_register, reg_write, write_data) 
begin 
	if reg_op1 = write_register
		and reg_write = '1' 
		and write_register /= "00000" then 
		rs <= write_data; 
	else
		rs <= rs_signal;
	end if; 
end process;


FORWARDING_RT : process(reg_op2, rt_signal, write_register, reg_write, write_data) 
begin
	if reg_op2 = write_register 
		and reg_write = '1' 
		and write_register /= "00000" then 
		rt <= write_data; 
	else 
		rt <= rt_signal;
	end if; 

end process; 


     
SPLIT_INSTRUCTION : process(processor_enable, instruction) 
begin 
    if processor_enable = '1' then
       rd_addr_internal <= instruction(23 downto 19);
       rsa_internal <= instruction(18 downto 14);
       rt_addr_internal <= instruction(8 downto 4);
       immediate_value_internal <= instruction(13 downto 4);
       immediate_address_internal <= instruction(18 downto 0);
       condition_internal <= instruction(31 downto 28);
     
     elsif processor_enable = '0' then
        rd_addr_internal  <= (others => '0');
        rsa_internal <= (others => '0');
        rt_addr_internal <= (others => '0');
        immediate_value_internal <= (others => '0');
        immediate_address_internal <= (others => '0');
        condition_internal <= (others => '0');
     end if;
end process;


SIGN_EXTEND_IMMEDIATE_VALUE : process(immediate_value_internal) 
begin 
     immediate_value_out_internal <= SXT(immediate_value_internal, DATA_WIDTH);   
    
end process SIGN_EXTEND_IMMEDIATE_VALUE;


SIGN_EXTEND_IMMEDIATE_ADDRESS : process(immediate_address_internal)
begin 
    immediate_address_out_internal <= SXT(immediate_address_internal, DATA_WIDTH);
end process SIGN_EXTEND_IMMEDIATE_ADDRESS;

--OUTPUT
condition_out <= condition_internal;
rsa <= reg_op1;
rta <= reg_op2;
rda <= rd_addr_internal;



end Behavioral;

