library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


library WORK;
use WORK.CONSTANTS.ALL;


entity execution_stage is
    port (clk                 : in STD_LOGIC;
          reset               : in STD_LOGIC;
          
          -- Control signals
          alu_src             : in STD_LOGIC;
          alu_func            : in STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
          
          
          --Control signals from other stages
          stage4_reg_write    : in STD_LOGIC;
          stage5_reg_write    : in STD_LOGIC;
          
          --Signals in 
          rs          : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          rt          : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          immediate           : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          rsa             : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          rta             : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          rda             : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          
          -- From other stages
          stage4_alu_result   : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          stage5_write_data   : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          stage4_reg_rd       : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          stage5_reg_rd       : in STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          
          --Control signals out
          overflow            : out STD_LOGIC;
			 multiplication_halt : out STD_LOGIC; 
          
          -- Signals out 
          write_register_addr : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
          alu_result          : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
end execution_stage;

architecture Behavioral of execution_stage is

-- COMPONENT declerations
component ALU 
    generic (N : NATURAL);
	port(
		X		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		Y		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
		R		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
		FUNC	:	in	STD_LOGIC_VECTOR(3 downto 0);
		OVERFLOW	:	out STD_LOGIC);
end component ALU; 	

component tri_multiplexor
    generic (N : NATURAL);
    Port ( sel : in  STD_LOGIC_VECTOR (1 downto 0);
           in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output  : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component multiplexor
    generic (N : NATURAL);
    port (sel : in STD_LOGIC;
          in0 : in STD_LOGIC_VECTOR(N-1 downto 0);
          in1 : in STD_LOGIC_VECTOR(N-1 downto 0);
          output : out STD_LOGIC_VECTOR(N-1 downto 0));
end component;


component forwarding_unit 
    Port ( EX_MEM_reg_write        : in  STD_LOGIC;
		  MEM_WB_reg_write        : in  STD_LOGIC;
		  rs_addr                 : in  STD_LOGIC_VECTOR (4 downto 0);
		  rt_addr                 : in  STD_LOGIC_VECTOR (4 downto 0);
		  EX_MEM_write_reg_addr   : in  STD_LOGIC_VECTOR (4 downto 0);
		  MEM_WB_write_reg_addr   : in  STD_LOGIC_VECTOR (4 downto 0);
		  forward_a               : out STD_LOGIC_VECTOR (1 downto 0);
		  forward_b               : out STD_LOGIC_VECTOR (1 downto 0));
end component;




-- Signal declerations

signal tri_mux1_out                : STD_LOGIC_VECTOR(63 downto 0);
signal tri_mux2_out                : STD_LOGIC_VECTOR(63 downto 0);
signal alu_op2                     : STD_LOGIC_VECTOR(63 downto 0);

--Control signals
signal forwardA                    : STD_LOGIC_VECTOR(1 downto 0);
signal forwardB                    : STD_LOGIC_VECTOR(1 downto 0); 

--Ground (Will be ignored)
signal ground_signal               : STD_LOGIC;                          


begin

-- Mappings


TRI_MUX1_MAP : tri_multiplexor
generic map(N => 64)
port map(sel => forwardA, 
         in0 => rs, 
         in1 => stage5_write_data, 
         in2 => stage4_alu_result, 
         output => tri_mux1_out);
         
         
TRI_MUX2_MAP : tri_multiplexor
generic map(N => 64)
port map(sel => forwardB, 
         in0 => rt, 
         in1 => stage5_write_data, 
         in2 => stage4_alu_result,
         output => tri_mux2_out);



ALU_MUX_MAP : multiplexor
generic map(N => 64)
port map(sel => alu_src, 
         in0 => tri_mux2_out, 
         in1 => immediate, 
         output => alu_op2);

ALU_MAP : ALU 
generic map(N => 64)
port map( X => tri_mux1_out, 
          Y =>alu_op2, 
          R => alu_result,
          FUNC => alu_func,
			 OVERFLOW => Overflow
			 );
     


FORWARD_UNIT_MAP : forwarding_unit 
port map(
			EX_MEM_reg_write => stage4_reg_write, 
			MEM_WB_reg_write =>stage5_reg_write, 
			rs_addr => rsa, 
			rt_addr => rta, 
			EX_MEM_write_reg_addr => stage4_reg_rd, 
			MEM_WB_write_reg_addr => stage5_reg_rd, 
			forward_a =>forwardA, 
			forward_b =>forwardB);
			
--Processes


--Output(s)
write_register_addr <= rda;


end Behavioral;

