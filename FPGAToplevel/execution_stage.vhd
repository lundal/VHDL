----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:05 10/12/2013 
-- Design Name: 
-- Module Name:    execution_stage - Behavioral 
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

library WORK;
use WORK.ALU_CONSTANTS.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execution_stage is
    port (clk               : in STD_LOGIC;
          reset             : in STD_LOGIC;
          
          -- Control signals
          reg_dst           : in STD_LOGIC;
          alu_src           : in STD_LOGIC;
          alu_op            : in STD_LOGIC_vector(1 downto 0);
          
          --Signals in 
          pc_incremented    : in STD_LOGIC_VECTOR(31 downto 0);
          read_data1        : in STD_LOGIC_VECTOR(63 downto 0);
          read_data2        : in STD_LOGIC_VECTOR(63 downto 0);
          immediate_value   : in STD_LOGIC_VECTOR (63 downto 0);
          immediate_address : in STD_LOGIC_VECTOR (31 downto 0);
          immediate         : in STD_LOGIC_VECTOR(31 downto 0);
          rs_addr           : in STD_LOGIC_VECTOR(4 downto 0);
          rt_addr           : in STD_LOGIC_VECTOR(4 downto 0);
          rd_addr           : in STD_LOGIC_VECTOR(4 downto 0);
          
          -- From other stages
          stage3_alu_result : in STD_LOGIC_VECTOR(63 downto 0);
          stage4_write_data : in STD_LOGIC_VECTOR(63 downto 0);
          
          -- Signals out 
          write_register    : out STD_LOGIC_VECTOR(31 downto 0);
          alu_result        : out STD_LOGIC_VECTOR(31 downto 0);
          addr_adder_result : out STD_LOGIC_VECTOR (31 downto 0);
          write_data        : out STD_LOGIC_VECTOR (63 downto 0);
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
		FLAGS	:	out ALU_FLAGS);
end component ALU; 	

component tri_multiplexor
    generic (N : NATURAL);
    Port ( sel : in  STD_LOGIC_VECTOR (1 downto 0);
           in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output  : in  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component multiplexor
    generic (N : NATURAL);
    port (sel : in STD_LOGIC;
          in0 : in STD_LOGIC_VECTOR(N-1 downto 0);
          in1 : in STD_LOGIC_VECTOR(N-1 downto 0);
          output : out STD_LOGIC_VECTOR(N-1 downto 0));
end component;

component Adder
    generic (N : NATURAL);
    port ( A			: in	STD_LOGIC_VECTOR(N-1 downto 0);
           B			: in	STD_LOGIC_VECTOR(N-1 downto 0);
		   R			: out	STD_LOGIC_VECTOR(N-1 downto 0);
		   CARRY_IN	    : in	STD_LOGIC;
		   OVERFLOW	    : out	STD_LOGIC
	);
end component;

component alu_control_unit
    Port ( alu_op  : in  STD_LOGIC_VECTOR (1 downto 0);
           function_code : in  STD_LOGIC_VECTOR (5 downto 0);
           alu_ctrl_out : in  STD_LOGIC_VECTOR (3 downto 0));
end component;


component forwarding_unit 
    Port ( rs : in  STD_LOGIC_VECTOR (4 downto 0);
           rt : in  STD_LOGIC_VECTOR (4 downto 0);
           stage3_reg_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           stage4_reg_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           stage3_reg_write : in  STD_LOGIC;
           stage4_reg_write : in  STD_LOGIC;
           forwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           forwardB : out  STD_LOGIC_VECTOR (1 downto 0));
end component;




-- Signal declerations

signal tri_mux1_out : STD_LOGIC_VECTOR(63 downto 0);
signal tri_mux2_out : STD_LOGIC_VECTOR(63 downto 0);
signal alu_op2      : STD_LOGIC_VECTOR(63 downto 0);

--Control signals
signal forwardA : STD_LOGIC_VECTOR(1 downto 0);
signal forwardB : STD_LOGIC_VECTOR(1 downto 0); 



begin

-- Mappings




TRI_MUX1_MAP : tri_multiplexor
generic map(N => 64)
port map(sel => forwardA, 
         in0 => read_data1, 
         in1 => stage4_write_data, 
         in2 => stage3_alu_result, 
         output => tri_mux1_out);
         
         
TRI_MUX2_MAP : tri_multiplexor
generic map(N => 64)
port map(sel => forwardB, 
         in0 => read_data2, 
         in1 => stage4_write_data, 
         in2 => stage3_alu_result,
         output => tri_mux2_out);

ALU_MUX_MAP : multiplexor
generic map(N => 64)
port map(sel => alu_src, 
         in0 => tri_mux2_out, 
         in1 => immediate_value, 
         output => alu_op2);

ALU_MAP : ALU 
generic map(N => 64)
port map( X => tri_mux1_out, 
          Y =>alu_op2, 
          R => alu_result,
          FUNC =>,
          FLAGS =>);
          


--Processes




end Behavioral;

