library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity MEM_WB is
    Port ( clk              : in  STD_LOGIC;
           reset            : in  STD_LOGIC;
           halt             : in  STD_LOGIC;
           
           -- PC in
           pc_incremented_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
           
           -- PC out
           pc_incremented_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
           
           --CONTROL in
           to_reg_op_in     : in  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           call_in          : in  STD_LOGIC;
			  reg_write_in     : in STD_LOGIC; 
           
           --CONTROL out
           to_reg_op_out    : out STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
           call_out         : out STD_LOGIC;
			  reg_write_out    : out STD_LOGIC; 
           
           --DATA in
           gene_in         : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           res_in         : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_in         : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  rda_in         : in  STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0);
           
           --Data out
           gene_out         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           res_out         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           data_out         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           rda_out         : out STD_LOGIC_VECTOR(REG_ADDR_WIDTH-1 downto 0)
       );
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

begin


PC_INCREMENTED : flip_flop 
	generic map(N => DATA_WIDTH)
	port map(clk => clk, 
				reset => reset, 
				enable => halt, 
				data_in => pc_incremented_in,
				data_out => pc_incremented_out);

GENE_REGISTER : flip_flop
    generic map(N => DATA_WIDTH)
    port map (clk => clk, 
              reset => reset, 
              enable => halt, 
              data_in => gene_in,
              data_out => gene_out
);


RES_REGISTER : flip_flop
    generic map(N => DATA_WIDTH)
    port map (clk => clk, 
              reset => reset, 
              enable => halt, 
              data_in => res_in,
              data_out => res_out
);


DATA_REGISTER : flip_flop
    generic map(N => DATA_WIDTH)
    port map(clk => clk, 
             reset => reset, 
             enable => halt, 
             data_in => data_in,
             data_out => data_out
);


RDA_REGISTER : flip_flop
generic map(N => REG_ADDR_WIDTH)
    port map(clk => clk, 
            reset => reset, 
            enable => halt, 
            data_in => rda_in,
            data_out => rda_out
);


CONTROL_TO_REG : flip_flop
generic map(N => TO_REG_OP_WIDTH)
    port map(clk => clk, 
            reset => reset, 
            enable => halt, 
            data_in => to_reg_op_in,
            data_out => to_reg_op_out
);


CONTROL_SIGNALS : process(clk, reset, reg_write_in, call_in) 
    begin 
        if reset = '1' then 
            reg_write_out <= '0';
				call_out <= '0';
        
        elsif rising_edge(clk) then 
            if halt = '0' then 
                --reg_write_out <= reg_write_in; 
					 --call_out <= call_in;
            end if; 
        end if;
		  reg_write_out <= reg_write_in; 
		  call_out <= call_in; 
        
end process CONTROL_SIGNALS;

end Behavioral;
