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
	processor_enable 	    : in STD_LOGIC;
   halt                  : out STD_LOGIC; 
	
	--Processor related control signals in
	overflow_in 			 : in STD_LOGIC;
	jump_in 					 : in STD_LOGIC;
	gene_op_in 				 : in STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0);
	cond_op_in 				 : in STD_LOGIC_VECTOR(COND_WIDTH-1 downto 0); 
	mem_op_in 				 : in STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0);
	
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
	request_data_bus 		 : out STD_LOGIC; 
	
	--Processor related bus signals in 
	fitness_in 				 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	gene_in 					 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	res_in 					 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	pc_incremented 		 : in STD_LOGIC_VECTOR(19-1 downto 0);
	
	--Processor related bus signals out 
	gene_out 				 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	data_out 				 : out STD_LOGIC_VECTOR(DATA_WIDTh-1 downto 0);
	pc_out 					 : out STD_LOGIC_VECTOR(19-1 downto 0);
	pc_jump_addr 			 : out STD_LOGIC_VECTOR (19-1 downto 0);
	
	-- Genetic related bus signals in 
	genetic_data_in 		: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	--Genetic related bus signals out 
	genetic_data_out 		: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	--Data memory related bus signals in 
	data_mem_bus_in		 : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	
	
	--Data memory related bus signals out 
	data_mem_bus_out		 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	data_mem_addr_bus 	 : out STD_LOGIC_VECTOR(17-1 downto 0)
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
        OP       => gene_op_in,
        FITNESS  => fitness_in,
        GENE_IN  => gene_in,
        GENE_OUT => gene_out,
        HALT     => genetic_halt_signal,
        CLK      => clk
    );



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
				

--This will also react as an flip_flop for reg_write
FLUSH_PIPELINE : process(clk, reset, flush_counter, execute_signal, jump_in, cond_op_in, condition_signal, reg_write_in, flush)
begin 
	if reset = '1' then 
		flush_counter <= "00";
		flush <= '0';
	elsif rising_edge(clk) then
		if flush = '1' then
			flush_counter <= flush_counter + "01";
			condition_signal <= "0000";
			reg_write_out <= '0';
			call_out <= '0';
			if flush_counter = "11" then 
				flush <= '0';
			end if;
		elsif execute_signal = '1' and jump_in = '1' then
			flush <= '1';
			flush_counter <= "01";
			condition_signal <= "0000";
			reg_write_out <= '0';
			call_out <= '0';
		
		elsif execute_signal <= '0' then
			reg_write_out <= '0';
			call_out <= '0';
			flush_counter <= "00";
			flush <= '0';
			condition_signal <= "0000";
		else 
			flush_counter <= "00";
			flush <= '0';
			condition_signal <= cond_op_in; 
			reg_write_out <= reg_write_in;
			call_out <= call_in;
		end if;
	end if;
end process;



jump_signal <= jump_in and execute_signal;

			
--Sign extend pc_incremented
pc_incremented_signal <= SXT(pc_incremented, 64);

--Split result to fit as memory addr
mem_addr_signal <= res_in(18 downto 0);

halt <= genetic_halt_signal or mem_halt_signal;


pc_jump_addr <= pc_out_signal(19-1 downto 0);
pc_out <= pc_out_signal(19-1 downto 0); 


--TODO: Remove later 

data_out <= (others => '0');

end Behavioral;

