library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;                                          
use IEEE.STD_LOGIC_SIGNED.ALL;  
use work.constants.all;


entity memory_stage is
	Port(
	--Bit signals
	clk  					    : in std_logic;
	reset 				    : in std_logic;
	processor_enable 	    : in std_logic; 
	
	--Control signals in
	overflow_in 			 : in std_logic;
	jump_in 					 : in std_logic;
	gene_op_in 				 : in std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	cond_op_in 				 : in std_logic_vector(COND_WIDTH-1 downto 0); 
	mem_op_in 				 : in std_logic_vector(MEM_OP_WIDTH-1 downto 0);
	ack_mem_ctrl 			 : in std_logic;
	ack_gene_ctrl 			 : in std_logic;
	gen_pipeline_settings : in std_logic_vector(SETTINGS_WIDTH-1 downto 0);
	
	reg_write_in			 : in std_logic;

	--Control signals out
	halt 					 	 : out std_logic;
	request_bus_rated  	 : out std_logic_vector(GENE_OP_WIDTH-1 downto 0);
	request_bus_unrated 	 : out std_logic;
	request_bus_data	 	 : out std_logic;
	reg_write_out 			 : out std_logic;
	
	--Bus signals in 
	fitness_in 				 : in std_logic_vector(DATA_WIDTH-1 downto 0);
	gene_in 					 : in std_logic_vector(DATA_WIDTH-1 downto 0);
	res_in 					 : in std_logic_vector(DATA_WIDTH-1 downto 0);
	pc_incremented 		 : in std_logic_vector(INST_WIDTH-1 downto 0);
	data_mem_bus_in		 : in std_logic_vector(DATA_WIDTH-1 downto 0);
	data_pool_bus_in		 : in std_logic_vector(DATA_WIDTH-1 downto 0);
	
	--Bus signals out
	gene_out 				 : out std_logic_vector(DATA_WIDTH-1 downto 0);
	data_out 				 : out std_logic_vector(DATA_WIDTh-1 downto 0);
	pc_out 					 : out std_logic_vector(DATA_WIDTH-1 downto 0);
	addr_mem_bus 			 : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	data_mem_bus_out		 : out std_logic_vector(DATA_WIDTH-1 downto 0);
	data_pool_bus_out		 : out std_logic_vector(DATA_WIDTH-1 downto 0);
	pc_jump_addr 			 : out std_logic_vector(INST_WIDTH-1 downto 0)
	);
end memory_stage;

architecture Behavioral of memory_stage is

signal halt_signal_genetic_ctrl : std_logic;
signal halt_signal_mem_ctrl 	  : std_logic;

signal data_bus_in              : std_logic_vector(DATA_WIDTH-1 downto 0);
signal data_bus_out 				  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal settings_gen_signal_out  : std_logic_vector(SETTINGS_WIDTH-1 downto 0);
signal gene_out_signal 			  : std_logic_vector(DATA_WIDTH-1 downto 0); 
signal pc_incremented_signal    : std_logic_vector(DATA_WIDTH-1 downto 0);

signal mem_op_ctrl_signal 		  : std_logic_vector(GENE_OP_WIDTH-1 downto 0);
signal mem_addr_signal 			  : std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);

signal execute_signal 			  : std_logic;
signal execute_flipflop_signal  : std_logic; 
signal pc_out_signal 			  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal res_signal 				  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal jump_signal 				  : std_logic;
signal flush_counter 			  : std_logic_vector(1 downto 0);
signal condition_signal			  : std_logic_vector(COND_WIDTH-1 downto 0); 
signal flush 						  : std_logic; 

signal reg_write_signal 		  : std_logic;
signal mem_op_signal 			  : std_logic_vector(MEM_OP_WIDTH-1 downto 0);
signal gene_op_signal 			  : std_logic_vector(GENE_OP_WIDTH-1 downto 0);	

--Remove this signal later
signal jippi						  : std_logic_vector(DATA_WIDTH-1 downto 0);

type state_type is (NOT_TAKEN, TAKEN);
signal CURRENT_STATE, NEXT_STATE: state_type;



begin

--fitness_genetic_controller : entity work.fitness_genetic_controller
--port map( 
--			--Bit signals
--			clk => clk,
--			
--			-- Control signals in
--			gene_op => gene_op_in, 
--			ack_gene_ctrl => ack_gene_ctrl,
--		   settings_in => gen_pipeline_settings,
--
--			-- Control signals out
--			halt => halt_signal_genetic_ctrl,
--			request_bus_rated => request_bus_rated,
--			request_bus_unrated => request_bus_unrated,
--			setting_out => settings_gen_signal_out,
--			
--			--BUS in 
--			fitness_in => fitness_in,
--			gene_in => gene_in,
--			data_pool_bus_in =>data_pool_bus_in,
--			
--			--BUS out
--			gene_out => gene_out_signal,
--			data_pool_bus_out => data_pool_bus_out);
--




conditional_unit : entity work.conditional_unit 
generic map(N => 64)
port map (
		     COND => cond_op_in,
			  ALU_RES => res_signal,
			  ALU_OVF => overflow_in,
		     EXEC => execute_signal
	);



multiplexor : entity work.multiplexor 
generic map(N => 64)
port map ( sel =>jump_signal, 
			  in0 => pc_incremented_signal, 
			  in1 =>res_in, 
			  output => pc_out_signal 
			  );



--Used to delay alu result for one cycle
flip_flop : entity work.flip_flop
	port map(clk => clk, 
				reset => reset,
				enable => '0', 
				data_in => res_in,
				data_out => res_signal);
				



RUN : process(clk, reset, flush_counter, execute_signal, jump_in, flush, cond_op_in, condition_signal, reg_write_in)
begin 
	if reset = '1' then 
		flush_counter <= "00";
		flush <= '0';
	elsif rising_edge(clk) then
		if flush = '1' then
			flush_counter <= flush_counter + "01";
			condition_signal <= "0000";
			reg_write_out <= '0';
			if flush_counter = "11" then 
				flush <= '0';
			end if;
		elsif execute_signal = '1' and jump_in = '1' then
			flush <= '1';
			flush_counter <= "01";
			condition_signal <= "0000";
			reg_write_out <= '0';
		else 
			condition_signal <= cond_op_in; 
			reg_write_out <= reg_write_in; 
		end if;
	end if;
end process;

jump_signal <= jump_in and execute_signal;

--THE_DECIDER : process(jump_in, execute_signal, execute_signal, CURRENT_STATE, cond_op_in)
--begin
--		
--		if jump_signal = '1'  and CURRENT_STATE = NOT_TAKEN then
--			NEXT_STATE <= TAKEN;
--			flush_counter <= (others => '0');
--		elsif CURRENT_STATE <= TAKEN then
--			if flush_counter /= "11" then 
--					flush_counter <= flush_counter + "01";
--					condition_signal <= "0000";
--			else 
--				NEXT_STATE <= NOT_TAKEN; 
--			end if;
--		else 
--			condition_signal <= cond_op_in; 
--			NEXT_STATE <= NOT_TAKEN;
--		end if;
--	
--
--end process;





--fitness_memory_controller : entity work.fitness_memory_controller 
--port map (
--			Bit signals
--			clk => clk,
--			reset => reset,
--			processor_enable => processor_enable, 
--			
--			Control signals in
--			mem_op => mem_op_in,
--			ack_mem_ctrl => ack_mem_ctrl, 
--			
--			Control signals out
--			mem_op_ctrl => mem_op_ctrl_signal, 
--			request_bus => request_bus_data,
--			halt 			=> halt_signal_mem_ctrl,
--			
--			BUS in
--			addr => mem_addr_signal, 
--			store_data => gene_in,
--			
--			Memory bus controller
--			addr_bus => addr_mem_bus, 
--			data_bus_out => data_mem_bus_out, 
--			data_bus_in => data_mem_bus_in, 
--			
--			BUS out
--			read_data_out => data_out);
			
			
--Sign extend pc_incremented
pc_incremented_signal <= SXT(pc_incremented, 64);

--Split result to fit as memory addr
mem_addr_signal <= res_in(18 downto 0);

halt <= halt_signal_genetic_ctrl or halt_signal_mem_ctrl;

pc_jump_addr <= pc_out_signal(31 downto 0);
pc_out <= pc_out_signal; 


--TODO: Remove later 
gene_out <= (others => '0');
data_out <= (others => '0');

end Behavioral;

