----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-28 15:21
-- Tested:   Never
--
-- Description:
-- A cache for 2 CPUs with room for 512 instructions.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionCache is
	generic(
        ADDR_WIDTH : natural := 19;
        INST_WIDTH : natural := 32
	);
	port(
		MemRq   : out STD_LOGIC;
		MemAck  : in  STD_LOGIC;
        
		MemAddr	: out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		MemData : in  STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        
        PCA     : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); 
        PCB     : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); 

		InstA   : out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
		InstB   : out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        
        Halt    : out STD_LOGIC;
        
        Reset   : in  STD_LOGIC;
		Clock   : in  STD_LOGIC
	);
end InstructionCache;

architecture Behavioral of InstructionCache is
	
    component BRAM_TDP is
        generic (
            ADDR_WIDTH	:	natural := 9;
            DATA_WIDTH	:	natural := 32;
            WE_WIDTH	:	natural := 4;
            RAM_SIZE	:	string	:= "18Kb";
            WRITE_MODE	:	string	:= "WRITE_FIRST"
        );
        port (
            A_ADDR	:	in	STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            A_IN	:	in	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            A_OUT	:	out	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            A_WE	:	in	STD_LOGIC;
            A_EN	:	in	STD_LOGIC;
            B_ADDR	:	in	STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            B_IN	:	in	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            B_OUT	:	out	STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            B_WE	:	in	STD_LOGIC;
            B_EN	:	in	STD_LOGIC;
            CLK		:	in	STD_LOGIC
        );
    end component;
    
	type StateType is (Check, Replace);
	
	signal State      : StateType := Check;
    
    signal InstAddrA  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal InstAddrB  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
	signal FaultA     : STD_LOGIC := '0';
	signal FaultB     : STD_LOGIC := '0';
    signal CacheAddrA : STD_LOGIC_VECTOR(9-1 downto 0);
    signal CacheAddrB : STD_LOGIC_VECTOR(9-1 downto 0);
	signal WriteA     : STD_LOGIC := '0';
	signal WriteB     : STD_LOGIC := '0';
    
    signal Stale : boolean(2**ADDR_WIDTH-1 downto 0);
	
begin
    
    InstCache : BRAM_TDP
    generic map(
        ADDR_WIDTH => 9,
        DATA_WIDTH => 32,
        WE_WIDTH   => 4,
        RAM_SIZE   => "18Kb",
        WRITE_MODE => "WRITE_FIRST" -- TODO: Will this create conflicts?
    )
    port map(
        A_ADDR => CacheAddrA,
        A_IN   => MemData,
        A_OUT  => InstA,
        A_WE   => WriteA,
        A_EN   => '1',
        
        B_ADDR => CacheAddrB,
        B_IN   => MemData,
        B_OUT  => InstB,
        B_WE   => WriteB,
        B_EN   => '1',
        
        CLK    => Clock
    );
    
    AddrCache : BRAM_TDP
    generic map(
        ADDR_WIDTH => 9,
        DATA_WIDTH => 32,
        WE_WIDTH   => 4,
        RAM_SIZE   => "18Kb",
        WRITE_MODE => "WRITE_FIRST" -- TODO: Will this create conflicts?
    )
    port map(
        A_ADDR => CacheAddrA,
        A_IN   => PCA,
        A_OUT  => InstAddrA,
        A_WE   => WriteA,
        A_EN   => '1',
        
        B_ADDR => CacheAddrB,
        B_IN   => PCB,
        B_OUT  => InstAddrB,
        B_WE   => WriteB,
        B_EN   => '1',
        
        CLK    => Clock
    );
    
    FaultA <= '1' when Stale(PCA) or InstAddrA /= PCA else '0';
    FaultB <= '1' when Stale(PCB) or InstAddrB /= PCB else '0';
    
    CacheAddrA <= PCA(9-1 downto 0);
    CacheAddrB <= PCB(9-1 downto 0);
    
	StateSelector : process(Clock, State)
	begin
		if rising_edge(Clock) then
			-- Go to replace after receiving memory access after a fault
			if State = Check and (FaultA = '1' or FaultB = '1') and MemAck = '1' then
				State <= Replace;
            -- Stay in replace while connected to memory
            elsif State = Replace and MemAck = '1' then
                State <= Replace;
			else
				State <= Check;
			end if;
		end if;
	end process;
    
	StateMachine : process(State, FaultA, FaultB)
	begin
		if State = Check then
            -- Disconnect from memory
            MemAddr <= (others => 'Z');
            
            -- Don't corrupt the data
            WriteA <= '0';
            WriteB <= '0';
            
            -- Check for faults
            if (FaultA = '1' or FaultB = '1') then
                Halt <= '1';
                MemRq <= '1';
            else
                Halt <= '0';
                MemRq <= '0';
            end if;
		else
            Halt <= '1';
            MemRq <= '1';
            
            -- Replace data
            if (FaultA = '1' and FaultB = '1' and CacheAddrA = CacheAddrB) then
                MemAddr <= PCA;
                WriteA <= '1';
                WriteB <= '1';
            elsif (FaultA = '1') then
                MemAddr <= PCA;
                WriteA <= '1';
                WriteB <= '0';
                Stale(PCA) <= false;
            else
                MemAddr <= PCB;
                WriteA <= '0';
                WriteB <= '1';
                Stale(PCB) <= false;
            end if;
		end if;
	end process;
    
    process (Reset)
    begin
        if Reset = '1' then
            Stale <= (others => true);
        end if;
    end process;
	
end Behavioral;

