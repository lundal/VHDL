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
           enable           : in  STD_LOGIC;
           
           --CONTROL in
           to_reg_op_in     : in  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           call_in          : in  STD_LOGIC;
           
           --CONTROL out
           to_reg_op_out    : out STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           call_out         : out STD_LOGIC;
           
           --DATA in
           data_in1         : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_in2         : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_in3         : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_in4         : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_in5         : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
           
           --Data out
           data_out1         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_out2         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_out3         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_out4         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_out5         : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0));
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
    generic map(N => INST_WIDTH)
    port map (clk => clk, 
              reset => reset, 
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
    generic map(N => DATA_WIDTH)
    port map(clk => clk, 
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
            data_out => data_out4
);

DATA_5_REGISTER : flip_flop 
generic map(N => REG_ADDR_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => enable, 
             data_in => data_in5, 
             data_out => data_out5
);



CONTROL_TO_REG : flip_flop 
generic map(N => TO_REG_OP_WIDTH)
    port map(clk => clk, 
            reset => reset, 
            enable => enable, 
            data_in => to_reg_op_in, 
            data_out => to_reg_op_out
);


CONTROL_SIGNALS : process(clk, reset) 
    begin 
        if reset = '1' then 
            call_out <= '0';
        
        elsif rising_edge(clk) then 
            if enable = '1' then 
                call_out <= call_in;
            end if; 
        end if;
        
end process CONTROL_SIGNALS;





end Behavioral;

