----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-28 15:21
-- Tested:   Never
--
-- Description:
-- A cache for 2 CPUs with room for 512 instructions.
-- Address 0 is reserved for cache fault
-- Hold reset state for 256 cycles to clear the cache
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

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
    
    constant BRAM_ADDR_WIDTH : integer := 9;
    
    type StateType is (Check, Replace);
	signal State      : StateType := Check;
    
    signal AddrInA    : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal AddrInB    : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal InstAddrA  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal InstAddrB  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal CacheAddrA : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    signal CacheAddrB : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    signal FaultA     : STD_LOGIC := '0';
	signal FaultB     : STD_LOGIC := '0';
	signal WriteA     : STD_LOGIC := '0';
	signal WriteB     : STD_LOGIC := '0';
    
    signal CounterA : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    signal CounterB : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
	
begin
    
    InstCache : entity WORK.BRAM_TDP
    generic map(
        ADDR_WIDTH => BRAM_ADDR_WIDTH,
        DATA_WIDTH => 32,
        WE_WIDTH   => 4,
        RAM_SIZE   => "18Kb",
        WRITE_MODE => "WRITE_FIRST"
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
    
    AddrCache : entity WORK.BRAM_TDP
    generic map(
        ADDR_WIDTH => BRAM_ADDR_WIDTH,
        DATA_WIDTH => 19,
        WE_WIDTH   => 4,
        RAM_SIZE   => "18Kb",
        WRITE_MODE => "WRITE_FIRST"
    )
    port map(
        A_ADDR => CacheAddrA,
        A_IN   => AddrInA,
        A_OUT  => InstAddrA,
        A_WE   => WriteA,
        A_EN   => '1',
        
        B_ADDR => CacheAddrB,
        B_IN   => AddrInB,
        B_OUT  => InstAddrB,
        B_WE   => WriteB,
        B_EN   => '1',
        
        CLK    => Clock
    );
    
    INCREMENTER : entity WORK.IncrementerDouble
    generic map (
        NUM_WIDTH => BRAM_ADDR_WIDTH
    )
    port map (
        NUM_A     => CounterA,
        NUM_B     => CounterB,
        INCREMENT => Clock
    );
    
    FaultA <= '1' when InstAddrA = (ADDR_WIDTH-1 downto 0 => '0') or InstAddrA /= PCA else '0';
    FaultB <= '1' when InstAddrB = (ADDR_WIDTH-1 downto 0 => '0') or InstAddrB /= PCB else '0';
    
    AddrInA <= PCA when Reset = '0' else (others => '0');
    AddrInB <= PCB when Reset = '0' else (others => '0');
    
    CacheAddrA <= PCA(BRAM_ADDR_WIDTH-1 downto 0) when Reset = '0' else CounterA;
    CacheAddrB <= PCB(BRAM_ADDR_WIDTH-1 downto 0) when Reset = '0' else CounterB;
    
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
    
	StateMachine : process(State, FaultA, FaultB, PCA, PCB, CacheAddrA, CacheAddrB, Reset)
	begin
        if Reset = '1' then
            -- Disconnect from memory
            MemAddr <= (others => 'Z');
            
            -- Reset data
            WriteA <= '1';
            WriteB <= '1';
            
            Halt <= '1';
            MemRq <= '0';
        elsif State = Check then
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
            
                if (CacheAddrA = CacheAddrB) then
                    MemAddr <= PCA;
                    WriteA <= '1';
                    WriteB <= '1';
                elsif (FaultA = '1') then
                    MemAddr <= PCA;
                    WriteA <= '1';
                    WriteB <= '0';
                else
                    MemAddr <= PCB;
                    WriteA <= '0';
                    WriteB <= '1';
                end if;
		end if;
	end process;
	
end Behavioral;

