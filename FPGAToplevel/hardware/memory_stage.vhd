library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;                                          
use IEEE.STD_LOGIC_SIGNED.ALL;  
use work.constants.all;


entity memory_stage is
	Port(
	--Bit signals
	clk  					    : in STD_LOGIC;
	reset 				    : in STD_LOGIC;
   halt                  : out STD_LOGIC;
   halt_pipeline 			 : in STD_LOGIC; 
	
	--Processor related control signals in
	overflow_in 			 : in STD_LOGIC;
	jump_in 					 : in STD_LOGIC;
	gene_op_in 				 : in STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0);
	cond_op_in 				 : in STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0); 
	mem_op_in 				 : in MEM_OP_TYPE;
	
	reg_write_in			 : in STD_LOGIC;
	call_in 					 : in STD_LOGIC;
	
	--Processor related control signals out
	reg_write_out 			 : out STD_LOGIC;
	call_out 				 : out STD_LOGIC;
	
	--Genetic pipeline related control signals in 
	ack_genetic_ctrl 		 : in STD_LOGIC;
	
	--Genetic pipeline related control signals out 
	genetic_request_0     : out STD_LOGIC;
	genetic_request_1     : out STD_LOGIC;
	
	--Memory related control signals in 
	ack_mem_ctrl 			 : in STD_LOGIC; 
	
	--Memory related control signals out 
	data_request_0 		 : out STD_LOGIC;
   data_request_1 		 : out STD_LOGIC; 
	
	--Processor related bus signals in 
	fitness_in 				 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	gene_in 					 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	res_in 					 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	pc_incremented 		 : in STD_LOGIC_VECTOR(19-1 downto 0);
	
	--Processor related bus signals out 
	gene_out 				 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	data_out 				 : out STD_LOGIC_VECTOR(DATA_WIDTh-1 downto 0);
	pc_out 					 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	pc_jump_addr 			 : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
	
	-- Genetic related bus signals in 
	genetic_data_in 		: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	--Genetic related bus signals out 
	genetic_data_out 		: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	--Data memory related bus signals in 
	data_mem_bus_in		 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	
	--Data memory related bus signals out 
	data_mem_bus_out		 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	data_mem_addr_bus 	 : out STD_LOGIC_VECTOR(ADDR_WIDTH-2-1 downto 0)
	);
end memory_stage;

architecture Behavioral of memory_stage is

signal genetic_halt_signal : std_logic;
signal mem_halt_signal  	: std_logic;

signal data_bus_in              : std_logic_vector(DATA_WIDTH-1 downto 0);
signal data_bus_out 				  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal settings_gen_signal_out  : std_logic_vector(SETTINGS_WIDTH-1 downto 0);
signal gene_out_signal 			  : std_logic_vector(DATA_WIDTH-1 downto 0); 
signal pc_incremented_signal    : std_logic_vector(DATA_WIDTH-1 downto 0);

signal mem_op_ctrl_signal 		  : std_logic_vector(GENE_OP_WIDTH-1 downto 0);


signal execute_signal 			  : std_logic;
signal execute_flipflop_signal  : std_logic; 
signal pc_out_signal 			  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal res_signal 				  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal jump_signal 				  : std_logic;
signal flush_counter 			  : std_logic_vector(1 downto 0);
signal condition_signal			  : std_logic_vector(COND_WIDTH-1 downto 0); 
signal flush 						  : std_logic; 

signal reg_write_signal 		  : std_logic;
signal mem_op_signal 			  : MEM_OP_TYPE := MEM_NOP;
signal gene_op_signal 			  : std_logic_vector(GENE_OP_WIDTH-1 downto 0) := (others => '0');	



begin


fitness_genetic_controller : entity work.fitness_genetic_controller
port map ( 
        -- To/from genetic pipeline
        REQUEST_0 => genetic_request_0,
        REQUEST_1 => genetic_request_1,
        
		  ACK      => ack_genetic_ctrl,
        DATA_IN  => genetic_data_in,
        DATA_OUT => genetic_data_out, 
        
        -- To/from processor
        OP       => gene_op_signal,
        FITNESS  => fitness_in,
        GENE_IN  => gene_in,
        GENE_OUT => gene_out,
        HALT     => genetic_halt_signal,
        CLK      => clk
    );


fitness_memory_controller : entity work.fitness_memory_controller
port map (
        -- Control signals
        REQUEST_0 => data_request_0,
        REQUEST_1 => data_request_1, 
        ACK       => ack_mem_ctrl, 
        
        -- Processor
        ADDR_IN  => res_in(ADDR_WIDTH-2-1 downto 0),
        DATA_IN  => gene_in,
        DATA_OUT => data_out,
        
        -- Memory
        MEM_ADDR  => data_mem_addr_bus, 
        MEM_DATA_IN  => data_mem_bus_in, 
        MEM_DATA_OUT => data_mem_bus_out, 
        
        OP   => mem_op_signal, 
        HALT => mem_halt_signal, 
        CLK  => clk 
    );


conditional_unit : entity work.conditional_unit 
generic map(N => DATA_WIDTH)
port map (
		     COND => cond_op_in,
			  ALU_RES => res_signal,
			  ALU_OVF => overflow_in,
		     EXEC => execute_signal
	);



multiplexor : entity work.multiplexor 
generic map(N => DATA_WIDTH)
port map ( sel =>jump_signal, 
			  in0 => pc_incremented_signal, 
			  in1 =>res_in, 
			  output => pc_out_signal 
			  );



--Used to delay alu result for one cycle
flip_flop : entity work.flip_flop	
generic map(N => 64)
port map(clk => clk, 
			reset => reset,
			enable => halt_pipeline, 
			data_in => res_in,
			data_out => res_signal);
				

--This will also react as an flip_flop for reg_write
FLUSH_PIPELINE : process(clk, reset, flush_counter, execute_signal, jump_in, cond_op_in, condition_signal, reg_write_in, flush)
begin 
	if reset = '1' then 
		flush_counter <= "00";
		flush <= '0';
	elsif rising_edge(clk) and halt_pipeline = '0' then
		if flush = '1' then
			flush_counter <= flush_counter + "01";
			reg_write_out <= '0';
			call_out <= '0';
			mem_op_signal <= MEM_NOP;
			gene_op_signal <= "00";
			if flush_counter = "11" then 
				flush <= '0';
			end if;
		--Flush pipeline 
		elsif execute_signal = '1' and jump_in = '1' and halt_pipeline = '0' then
			flush <= '1';
			flush_counter <= "00";
			reg_write_out <= '0';
			call_out <= '0';
			mem_op_signal <= MEM_NOP; 
		--Flush current
		elsif execute_signal <= '0' and halt_pipeline = '0' then
			reg_write_out <= '0';
			call_out <= '0';
			flush_counter <= "00";
			flush <= '0';
			mem_op_signal <= MEM_NOP; 
			gene_op_signal <= "00";
			
		else 
			--flush_counter <= "00";
			--flush <= '0';
			reg_write_out <= reg_write_in;
			call_out <= call_in;
			mem_op_signal <= mem_op_in; 
			gene_op_signal <= gene_op_in; 
		end if;
	end if;
end process;



jump_signal <= jump_in and execute_signal;

			
--Sign extend pc_incremented
pc_incremented_signal <= SXT(pc_incremented, DATA_WIDTH);



halt <= genetic_halt_signal or mem_halt_signal;


pc_jump_addr <= pc_out_signal(ADDR_WIDTH-1 downto 0);
pc_out <= pc_out_signal; 

end Behavioral;

