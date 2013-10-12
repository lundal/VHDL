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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execution_stage is
    port (clk             : in STD_LOGIC;
          reset           : in STD_LOGIC;
          
          -- Control signals
          reg_dst         : in STD_LOGIC;
          alu_src         : in STD_LOGIC;
          alu_op          : in STD_LOGIC_vector(1 downto 0);
          
          --Signals in 
          pc_incremented  : in STD_LOGIC_VECTOR(31 downto 0);
          rs              : in STD_LOGIC_VECTOR(31 downto 0);
          rt              : in STD_LOGIC_VECTOR(31 downto 0);
          immediate       : in STD_LOGIC_VECTOR(31 downto 0);
          rs_addr         : in STD_LOGIC_VECTOR(4 downto 0);
          rt_addr         : in STD_LOGIC_VECTOR(4 downto 0);
          
          -- Signals out 
          write_register  : out STD_LOGIC_VECTOR(31 downto 0);
          alu_result      : out STD_LOGIC_VECTOR(31 downto 0);
          pc_adder_result : out STD_LOGIC_VECTOR (31 downto 0));
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


-- Signal declerations
 


begin

-- Mappings

PC_ADDR_ADDER_MAP : Adder 
    generic map(N => 32)
    port map(A =>, 
             B =>, 
             R =>, 
             CARRY_IN =>, 
             OVERFLOW =>);
         
ALU_MAP : ALU 
generic MAP(N => 64)
port map( X =>, 
          Y =>, 
          R =>, 
          FUNC =>, 
          FLAGS =>,  
)


MUX_ALU_MAP : multiplexor 
generic map( N => )
port map (sel =>, 
          in0 =>, 
          in1 =>, 
          output);
          
MUX_WRITE_REGISTER_MAP : multiplexor 
generic map(N => 5)
port map( sel =>, 
          in0 =>, 
          in1 =>, 
          output =>); 

end Behavioral;

