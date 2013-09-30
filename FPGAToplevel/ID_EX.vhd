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
           reg_dst_in                   : in  STD_LOGIC;
           alu_op_in                    : in  STD_LOGIC_VECTOR(1 downto 0);
           alu_src_in                   : in  STD_LOGIC;
           branch_in                    : in  STD_LOGIC;
           mem_read_in                  : in  STD_LOGIC;
           mem_write_in                 : in  STD_LOGIC;
           reg_write_in                 : in  STD_LOGIC;
           mem_to_reg_in                : in  STD_LOGIC;
           reg_dst_out                  : out STD_LOGIC;
           alu_op_out                   : out STD_LOGIC_VECTOR(1 downto 0);
           alu_src_out                  : out STD_LOGIC;
           branch_out                   : out STD_LOGIC;
           mem_read_out                 : out STD_LOGIC;
           mem_write_out                : out STD_LOGIC;
           reg_write_in                 : out STD_LOGIC;
           mem_to_reg_out               : out STD_LOGIC;
           read_data_1_in               : in  STD_LOGIC_VECTOR (31 downto 0);
           read_data_2_in               : in  STD_LOGIC_VECTOR (31 downto 0);
           sign_extended_in             : in  STD_LOGIC_VECTOR (31 downto 0);
           instruction_in               : in  STD_LOGIC_VECTOR (31 downto 0);
           incremented_instruction_in   : in  STD_LOGIC_VECTOR (31 downto 0);
           instruction_20_16_in         : in  STD_LOGIC_VECTOR (4 downto 0);
           instruction_15_11_in         : in  STD_LOGIC_VECTOR (4 downto 0);
           incremented_instruction_out  : out STD_LOGIC_VECTOR (31 downto 0);
           read_data_1_out              : out STD_LOGIC_VECTOR (31 downto 0);
           read_data_2_out              : out STD_LOGIC_VECTOR (31 downto 0);
           sign_extended_out            : out STD_LOGIC_VECTOR (31 downto 0);
           instruction_20_16_out        : out STD_LOGIC_VECTOR (4 downto 0);
           instruction_15_11_out        : out STD_LOGIC_VECTOR (4 downto 0)
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
INCREMENTED_REGISTER : flip_flop
generic map(N => 32)
port map (clk => clk, 
          reset =>reset, 
          enable => '1', -- Not sure yet 
          data_in => incremented_instruction_in, 
          data_out => incremented_instruction_out
);


READ_DATA_1_REGISTER : flip_flop 
generic map(N => 32)
port map (clk => clk, 
          reset => reset, 
          enable => '1', 
          data_in => read_data_1_in, 
          data_out => read_data_1_out
);

READ_DATA_2_REGISTER : flip_flop 
generic map( N => 32)
port map( clk => clk,
          reset => reset, 
          enable => '1', 
          data_in => read_data_2_in,
          data_out => read_data_2_out
);


SIGN_EXTEND_REGISTER : flip_flop 
generic map (N => 32)
port map (clk => clk, 
          reset => reset, 
          enable => '1',
          data_in => sign_extended_in,
          data_out => sign_extended_out
);


INSTRUCTION_20_16_REGISTER : flip_flop 
generic map(N => 5)
port map ( clk => clk,
           reset => reset, 
           enable => '1',
           data_in => instruction_20_16_in,
           data_out => instruction_20_16_out 
);

INSTRUCTION_15_11_REGISTER : flip_flop 
generic map(N => 5)
port map (clk => clk, 
          reset => reset, 
          enable => '1',
          data_in => instruction_15_11_in, 
          data_out => instruction_15_11_out
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
            alu_op_in <= alu_op_out;
            alu_src_in <= alu_src_out;
            branch_in <= branch_out;
            mem_read_out <= mem_read_in;
            mem_write_in <= mem_write_out;
            reg_write_in <= reg_write_out;
            mem_to_reg_in <= mem_to_reg_in; 
        end if;
end process CONTROL_SIGNALS;

end Behavioral;

