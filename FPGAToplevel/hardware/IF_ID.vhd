library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity IF_ID is
    Port ( 
           -- bit signals
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           halt : in  STD_LOGIC;
			  processor_enable : in std_logic; 
           
           -- bus in
           instruction_in  : in  STD_LOGIC_VECTOR (INST_WIDTH-1 downto 0);
           pc_incremented_in : in std_logic_vector(ADDR_WIDTH-1 downto 0);
           
           -- bus out
           pc_incremented_out : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
           instruction_out : out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0)
           
           );
end IF_ID;


architecture behavioral of IF_ID is

--Component declerations
component flip_flop 
    generic(N : NATURAL);
    Port ( clk : in std_logic;
           reset : in std_logic;
           enable : in std_logic;
           data_in : in std_logic_vector(INST_WIDTH-1 downto 0);
           data_out : out std_logic_vector(INST_WIDTH-1 downto 0)
    );
end component flip_flop;

begin


--    STATE_MACHINE : process(clk, reset, processor_enable, CURRENT_STATE)
--    begin 
--        if reset = '1' then 
--            CURRENT_STATE <= STATE_DISABLED;
--        elsif rising_edge(clk) then 
--            if processor_enable = '1' and CURRENT_STATE = STATE_DISABLED then 
--                CURRENT_STATE <= STATE_RUNNING;
--            else
--                CURRENT_STATE <= STATE_DISABLED;
--            end if;
--        end if;
--    end process;


    TEST : process (reset, clk, pc_incremented_in, instruction_in, processor_enable, halt)
    begin
        if reset = '1' then 
            pc_incremented_out <= (others => '0');
				instruction_out <= (others => '0');
        elsif rising_edge(clk) and halt = '0' then 
				pc_incremented_out <= pc_incremented_in;
        end if;
        
        if halt = '0' then
            instruction_out <= instruction_in;
        end if; 
          
    end process;


--Mappings
--INCREMENTED_REGISTER : flip_flop
--generic map(N => INST_WIDTH)
--port map (clk => clk,
--          reset => reset,
--          enable => halt, 
--          data_in => pc_incremented_in, 
--          data_out => pc_incremented_out
--);
--
----The register file works as an flip-flop, no no need to use one more clock cycle here
--instruction_out <= instruction_in;
--
--INSTRUCTION_REGISTER : flip_flop 
--generic map(N => INST_WIDTH)
--port map (clk => clk, 
--          reset => reset, 
--          enable => halt,
--          data_in => instruction_in,
--          data_out => instruction_out
--);

end behavioral;
