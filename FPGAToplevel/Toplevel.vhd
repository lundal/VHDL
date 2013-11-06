----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:08:24 05/03/2012 
-- Design Name: 
-- Module Name:    toplevel - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;
use work.CONSTANTS.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity toplevel is

	generic  (
		MEM_ADDR_BUS	: integer	:= 32;
		MEM_DATA_BUS	: integer	:= 32 );

	Port (
		clk            : in STD_LOGIC;
		reset          : in STD_LOGIC;
		command        : in  STD_LOGIC_VECTOR (0 to 31);
		bus_address_in : in  STD_LOGIC_VECTOR (0 to 31);
		bus_data_in    : in  STD_LOGIC_VECTOR (0 to 31);
		status         : out  STD_LOGIC_VECTOR (0 to 31);
		bus_data_out   : out  STD_LOGIC_VECTOR (0 to 31)
	); 
end toplevel;

architecture Behavioral of toplevel is

	component fitness_core
    port( 
			-- Bit signals
			 clk 					 		: in  STD_LOGIC;
          reset 				 		: in  STD_LOGIC;
          processor_enable  		: in  STD_LOGIC;
          
			 --Control signals
			 halt_inst 					: in  STD_LOGIC; 
			 
			 --Bus signals related to instruction cache
			 imem_address 		 		: out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
			 imem_data_in 		 		: in  STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
          
			 --Bus signals related to data memory
			 request_bus_data 		: out STD_LOGIC;
			 ack_mem_ctrl 	    		: in  STD_LOGIC;
			 dmem_data_in 		 		: in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          dmem_address 		 		: out STD_LOGIC_VECTOR(MEM_ADDR_WIDTH-1 downto 0);
          dmem_address_wr 	 		: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          dmem_data_out 	 		: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
          dmem_write_enable 		: out STD_LOGIC;
			 
			 --Bus signals related to genetic storage
			 pmem_data_out 			: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			 pmem_data_in 				: in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			 pipeline_settings_out 	: out STD_LOGIC_VECTOR(SETTINGS_WIDTH-1 downto 0);
			 request_bus_rated 		: out STD_LOGIC_vector(GENE_OP_WIDTH-1 downto 0);
			 ack_gene_ctrl 	  		: in  STD_LOGIC;
		 	 request_bus_unrated  	: out STD_LOGIC;
			 
			 gen_pipeline_settings  : in STD_LOGIC_VECTOR(SETTINGS_WIDTH-1 downto 0)
			 
			 );
	end component fitness_core; 
	
	component com
	port ( 
		clk				: in  STD_LOGIC;
		reset				: in  STD_LOGIC;
		command			: in  STD_LOGIC_VECTOR (0 to 31);
		bus_address_in	: in  STD_LOGIC_VECTOR (0 to 31);
		bus_data_in		: in  STD_LOGIC_VECTOR (0 to 31);
		status			: out  STD_LOGIC_VECTOR (0 to 31);
		bus_data_out 	: out  STD_LOGIC_VECTOR (0 to 31);
		read_addr		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS - 1 downto 0);
		read_data		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS - 1 downto 0);
		write_addr		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS - 1 downto 0);
		write_data		: out  STD_LOGIC_VECTOR (MEM_DATA_BUS - 1 downto 0);       
		write_enable	: out  STD_LOGIC;    
		write_imem 		: out STD_LOGIC;
		processor_enable : out  STD_LOGIC
	);
	end component;
	
	
	component MEMORY is
		generic (M :NATURAL :=MEM_ADDR_COUNT; N :NATURAL :=DDATA_BUS); 
		port(
			CLK			: in STD_LOGIC;
			RESET			:	in  STD_LOGIC;	
			W_ADDR		:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Address to write data
			WRITE_DATA	:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Data to be written
			MemWrite		:	in  STD_LOGIC;									-- Write Signal
			ADDR			:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Address to access data
			READ_DATA	:	out STD_LOGIC_VECTOR (N-1 downto 0)		-- Data read from memory
		);
	end component MEMORY;
	
	signal proc_enable				: std_logic;
	signal com_write_en				: std_logic;
	signal dmem_write_enable_com	: std_logic;
	signal imem_write_enable_com	: std_logic;
	signal instr_data					: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal instr_addr					: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_address_wr			: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_write_data			: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_address				: std_logic_vector(MEM_ADDR_WIDTH-1 downto 0); 
	signal dmem_address_wr_proc	: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_data_in				: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_write_data_proc	: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_address_proc		: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_write_enable_proc	: std_logic;
	signal dmem_address_wr_com		: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_write_data_com		: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_address_com			: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal com_write_imem			: std_logic;
	
	--Signals that are not avalible during these tests
	signal request_bus_data 		: std_logic; 
	signal ack_mem_ctrl 				: std_logic; 
	signal placeholder 				: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal dmem_data_out 	 		: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal dmem_write_enable 		: STD_LOGIC;
	signal pmem_data_out 			: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal pmem_data_in 				: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal pipeline_settings_out 	: STD_LOGIC_VECTOR(SETTINGS_WIDTH-1 downto 0);
	signal request_bus_rated 		: STD_LOGIC_vector(GENE_OP_WIDTH-1 downto 0);
	signal ack_gene_ctrl 	  		: STD_LOGIC;
	signal request_bus_unrated  	: STD_LOGIC;
	signal gen_pipeline_settings  : STD_LOGIC_VECTOR(SETTINGS_WIDTH-1 downto 0);
	signal placeholder_addr 		: std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	
begin

	TDT4255_COM : com port map(
		clk				=> clk,
		reset				=> reset,
		command			=> command,
		bus_address_in	=> bus_address_in,
		bus_data_in		=> bus_data_in,
		status			=> status,
		bus_data_out	=> bus_data_out,
		processor_enable	=> proc_enable,
		read_data		=> dmem_data_in,
		read_addr		=> dmem_address_com,
		write_addr		=> dmem_address_wr_com,
		write_data		=> dmem_write_data_com,
		write_enable	=> com_write_en,
		write_imem		=> com_write_imem
	);
	
	DMEM_MUX : process(clk, reset, dmem_address_proc, dmem_address_wr_proc, dmem_write_data_proc, dmem_write_enable_proc,
					dmem_address_com, dmem_address_wr_com, dmem_write_data_com, dmem_write_enable_com, proc_enable)
	begin
		if proc_enable = '1' then          
			dmem_address		<= (others => '0');
			dmem_address_wr	<= (others => '0');
			dmem_write_data	<= (others => '0');
			dmem_write_enable	<= '0';
		else
			dmem_address		<= placeholder_addr;
			dmem_address_wr	<= dmem_address_wr_com;
			dmem_write_data	<= dmem_write_data_com;
			dmem_write_enable <= dmem_write_enable_com;
		end if;
	end process;
	
	IMEM_WRITE_ENABLE_MUX : process(com_write_imem, com_write_en)
	begin
		if com_write_imem = '1' then
			imem_write_enable_com <= com_write_en;
			dmem_write_enable_com <= ZERO1b;
		else
			imem_write_enable_com <= ZERO1b;
			dmem_write_enable_com <= com_write_en;
		end if;
	end process;
	

	INST_MEM: MEMORY generic map (M=>MEM_ADDR_COUNT, N=>IDATA_BUS) 
	port map(
		CLK			=> clk,
		RESET		=> reset,
		W_ADDR		=> dmem_address_wr_com,		-- ADDRESS TO BE WRITTEN
		WRITE_DATA	=> dmem_write_data_com,		-- DATA TO BE WRITTEN
		ADDR		=> instr_addr,					-- ADDRESS TO BE READ
		READ_DATA	=> instr_data,					-- DATA READ OUT
		MemWrite	=> imem_write_enable_com
	);
	
	
	FITNESS_CORE_PROCESSOR : fitness_core
	port map(
			-- Bit signals
			 clk => clk, 
          reset => reset, 
          processor_enable => proc_enable,
          
			 --Control signals
			 halt_inst => '0', 
			 
			 --Bus signals related to instruction cache
			 imem_address 	=> instr_addr, 
			 imem_data_in  => instr_data, 
          
			  --Bus signals related to data memory
			 request_bus_data 		=> request_bus_data, 
			 ack_mem_ctrl 	    		=> '0', 
			 dmem_data_in 		 		=> placeholder,
          dmem_address 		 		=> placeholder_addr,
          dmem_address_wr 	 		=> placeholder, 
          dmem_data_out 	 		=> dmem_data_out,
          dmem_write_enable 		=> dmem_write_enable, 
			 
			 --Bus signals related to genetic storage
			 pmem_data_out 		   => pmem_data_out, 
			 pmem_data_in 				=> placeholder, 
			 pipeline_settings_out 	=> pipeline_settings_out,
			 request_bus_rated 		=> request_bus_rated,
			 ack_gene_ctrl 	  		=> '0',
		 	 request_bus_unrated  	=> request_bus_unrated, 
			 
			 gen_pipeline_settings  => gen_pipeline_settings
			 
			 );
	
	
end Behavioral;

