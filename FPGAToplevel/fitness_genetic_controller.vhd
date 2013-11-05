library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONSTANTS.all;

entity fitness_genetic_controller is
	Port ( 
			clk 						: in std_logic;
			reset 					: in std_logic;
			processor_enable	   : in std_logic;
			
			-- Control signals in
			gene_op 				   : in std_logic_vector (GENE_OP_WIDTH-1 downto 0);
			ack_gene_ctrl 		   : in std_logic;
		   settings_in          : in std_logic_vector (SETTINGS_WIDTH-1 downto 0);

			-- Control signals out
			halt 				      : out std_logic;
			request_bus_rated    : out std_logic_vector (GENE_OP_WIDTH-1 downto 0);
			request_bus_unrated  : out std_logic;
			setting_out 		   : out std_logic_vector (SETTINGS_WIDTH-1 downto 0);
			
			--BUS in 
			fitness_in 			   : in std_logic_vector (DATA_WIDTH-1 downto 0);
			gene_in 				   : in std_logic_vector (DATA_WIDTH-1 downto 0);
			data_pool_bus_in     : in std_logic_vector (DATA_WIDTH-1 downto 0);
			
			--BUS out
			gene_out 			   : out std_logic_vector (DATA_WIDTH-1 downto 0);
			data_pool_bus_out    : out std_logic_vector (DATA_WIDTH-1 downto 0)
			);
end fitness_genetic_controller;

architecture Behavioral of fitness_genetic_controller is

type state_type is (REQUEST,WAIT_FOR_ACK ,LOAD_GENE, STORE_FITNESS, STORE_GENE);
signal CURRENT_STATE, NEXT_STATE : state_type;

constant LOAD 				: std_logic_vector(GENE_OP_WIDTH-1 downto 0) := "01";
constant STORE 			: std_logic_vector(GENE_OP_WIDTH-1 downto 0) := "10";
constant NOP 				: std_logic_vector(GENE_OP_WIDTH-1 downto 0) := "00";
constant SETTINGS 		: std_logic_vector(GENE_OP_WIDTH-1 downto 0) := "11";


begin

RUN : process(clk, reset) 
	begin 
		if reset = '1' then
			CURRENT_STATE <= REQUEST;
		elsif rising_edge(clk) then 
			if processor_enable = '1' then 
				CURRENT_STATE <= NEXT_STATE;
			end if;
		end if;
			
end process;


STATE_MACHINE : process (CURRENT_STATE, gene_op)
	begin 
	case CURRENT_STATE is 
	when REQUEST => 
		data_pool_bus_out <= (others => 'Z');
		
		case gene_op is 
			when STORE => 
				request_bus_rated <= gene_op;
				halt <= '1';
			when SETTINGS => 
				request_bus_rated <= gene_op;
				halt <= '1';
			when LOAD =>
				request_bus_unrated <= '1';
				halt <= '1';
			when others => 
				--Request access to the rated pool
				request_bus_rated <= (others => '0');
				request_bus_unrated <= '0';
				halt <= '1';
		end case;
		NEXT_STATE <= WAIT_FOR_ACK;
		
	when WAIT_FOR_ACK => 
		if ack_gene_ctrl = '1' then
			request_bus_rated <= (others => '0');
			request_bus_unrated <= '0';
			case gene_op is 
				when STORE => 
					NEXT_STATE <= STORE_FITNESS;
				when LOAD => 
					--The pool should start laoding the memory here
					NEXT_STATE <= LOAD_GENE;
				when others => 
					NEXT_STATE <= REQUEST;
			end case;
		end if;
		NEXT_STATE <= WAIT_FOR_ACK;
	
	when STORE_FITNESS => 
		data_pool_bus_out <= fitness_in;
		NEXT_STATE <= STORE_GENE;
	
	when STORE_GENE => 
		data_pool_bus_out <= gene_in;
		NEXT_STATE <= REQUEST; 
	
	when LOAD_GENE =>
		--Finished loading the gene 
		gene_out <= data_pool_bus_in;
	
	when others => 
		NEXT_STATE <= REQUEST; 
	
	end case;

end process;


end Behavioral;

