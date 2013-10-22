----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-22 19:04
-- Updated:  2013-10-22 19:04
-- Tested:   Never
--
-- Description:
-- Toplevel design for the project
-- Hooked up with fake memory for now
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Toplevel is
	generic(
		NUM_PROC_PAIRS : natural := 4;
		ADDR_WIDTH : natural := 19;
		INST_WIDTH : natural := 32;
		DATA_WIDTH : natural := 16
	);
	port(
		SCU_Enable : in  STD_LOGIC;
		SCU_State  : in  STD_LOGIC_VECTOR(1 downto 0);
		SCU_High   : in  STD_LOGIC;
		SCU_CE     : in  STD_LOGIC;
		SCU_WE     : in  STD_LOGIC;
		SCU_Addr   : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		SCU_Data   : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		
		Inst_CE    : out STD_LOGIC;
		Inst_WE    : out STD_LOGIC;
		Inst_Addr  : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		Inst_Data  : inout STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
		
		Data_CE    : out STD_LOGIC;
		Data_WE    : out STD_LOGIC;
		Data_Addr  : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		Data_Data  : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		
		Clock      : in STD_LOGIC
	);
end Toplevel;

architecture Behavioral of Toplevel is
	
	component MemMux is
		generic(
			ADDR_WIDTH : natural := 19;
			DATA_WIDTH : natural := 16
		);
		port(
			CE     : out STD_LOGIC;
			WE     : out STD_LOGIC;
			ADDR   : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
			DATA   : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			
			A_CE   : in  STD_LOGIC;
			A_WE   : in  STD_LOGIC;
			A_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
			A_DATA : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			
			B_CE   : in  STD_LOGIC;
			B_WE   : in  STD_LOGIC;
			B_ADDR : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
			B_DATA : inout STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			
			Sel    : in  STD_LOGIC
		);
	end component;
	
	component InstructionController is
		generic(
			N : natural := 2
		);
		port(
			MemCE   : out STD_LOGIC;
			MemWE   : out STD_LOGIC;
			MemAddr	: out STD_LOGIC_VECTOR (18 downto 0);
			MemData : inout STD_LOGIC_VECTOR (31 downto 0);
			Request : in  STD_LOGIC_VECTOR (N-1 downto 0);
			Ack     : out STD_LOGIC_VECTOR (N-1 downto 0);
			Addr    : in  STD_LOGIC_VECTOR (18 downto 0);
			Data    : out STD_LOGIC_VECTOR (31 downto 0);
			Enabled : in  STD_LOGIC;
			Clock   : in  STD_LOGIC
		);
	end component;
	
	-- Mux signals
	signal InstSel : STD_LOGIC;
	signal DataSel : STD_LOGIC;
	
	signal SCU_Data_Inst : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
	
	-- SCU Instruction signals
	signal InstHigh : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal InstLow  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal InstConc : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
	
	-- Instruction controller signals
	signal InstCE   : STD_LOGIC;
	signal InstWE   : STD_LOGIC;
	signal InstAddr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
	signal InstData : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
	signal InstRq   : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
	signal InstAck  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS-1 downto 0);
	signal InstAddrBus : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); -- To processors
	signal InstDataBus : STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0); -- To processors
	
	-- Data controller signals
	signal DataCE   : STD_LOGIC;
	signal DataWE   : STD_LOGIC;
	signal DataAddr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
	signal DataData : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal DataRq   : STD_LOGIC_VECTOR(NUM_PROC_PAIRS*2-1 downto 0);
	signal DataAck  : STD_LOGIC_VECTOR(NUM_PROC_PAIRS*2-1 downto 0);
	signal DataAddrBus : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); -- To processors
	signal DataDataBus : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); -- To processors
	
begin
	
	StateDecoder : process(SCU_State)
	begin
		case SCU_State is
			when "00" =>
				InstSel <= '1';
				DataSel <= '1';
			when "01" =>
				InstSel <= '0';
				DataSel <= '1';
			when "10" =>
				InstSel <= '1';
				DataSel <= '0';
			when others =>
				InstSel <= '1';
				DataSel <= '1';
		end case;
	end process;
	
	-- Concatenate high and low instruction parts
	InstConc <= InstHigh & InstLow;
	SCU_Data_Inst <= InstConc;
	
	InstLatches : process(SCU_High, SCU_Data)
	begin
		-- Update InstHigh when High is set
		if SCU_High = '1' then
			InstHigh <= SCU_Data;
		end if;
		-- Update InstLow when Low is set
		if SCU_High = '0' then
			InstLow <= SCU_Data;
		end if;
	end process;
	
	InstMux : MemMux
	generic map(
		ADDR_WIDTH => ADDR_WIDTH,
		DATA_WIDTH => INST_WIDTH
	)
	port map(
		CE     => Inst_CE,
		WE     => Inst_WE,
		ADDR   => Inst_Addr,
		DATA   => Inst_Data,
		
		A_CE   => SCU_CE,
		A_WE   => SCU_WE,
		A_ADDR => SCU_Addr,
		A_DATA => SCU_Data_Inst,
		
		B_CE   => InstCE,
		B_WE   => InstWE,
		B_ADDR => InstAddr,
		B_DATA => InstData,
		
		Sel    => InstSel
	);
	
	InstCtrl : InstructionController
	generic map(
		N => NUM_PROC_PAIRS
	)
	port map(
		MemCE   => InstCE,
		MemWE   => InstWE,
		MemAddr	=> InstAddr,
		MemData => InstData,
		Request => InstRq,
		Ack     => InstAck,
		Addr    => InstAddrBus,
		Data    => InstDataBus,
		Enabled => SCU_Enable,
		Clock   => Clock
	);
	
end Behavioral;

