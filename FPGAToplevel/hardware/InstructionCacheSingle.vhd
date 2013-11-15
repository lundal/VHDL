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

entity InstructionCacheSingle is
	generic(
        ADDR_WIDTH : natural := 19;
        INST_WIDTH : natural := 32
	);
	port(
		MemRq   : out STD_LOGIC;
		MemAck  : in  STD_LOGIC;
        
		MemAddr	: out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		MemData : in  STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        
        PC      : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0); 
		Inst    : out STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
        
        Halt    : out STD_LOGIC;
        
        Reset   : in  STD_LOGIC;
		Clock   : in  STD_LOGIC
	);
end InstructionCacheSingle;

architecture Behavioral of InstructionCacheSingle is
    
    constant BRAM_ADDR_WIDTH : integer := 9;
    
    type StateType is (Check, Replace);
	signal State      : StateType := Check;
    
    signal AddrInA    : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal AddrInB    : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal InstAddrA  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal InstAddrB  : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal CacheAddrA : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    signal CacheAddrB : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    signal Fault      : STD_LOGIC := '0';
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
        A_OUT  => Inst,
        A_WE   => WriteA,
        A_EN   => '1',
        
        B_ADDR => CacheAddrB,
        B_IN   => MemData,
        --B_OUT  => Inst,
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
        --B_OUT  => InstAddrB,
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
    
    Fault <= '1' when InstAddrA = (ADDR_WIDTH-1 downto 0 => '0') or InstAddrA /= PC else '0';
    
    AddrInA <= PC when Reset = '0' else (others => '0');
    AddrInB <= PC when Reset = '0' else (others => '0');
    
    CacheAddrA <= PC(BRAM_ADDR_WIDTH-1 downto 0) when Reset = '0' else CounterA;
    CacheAddrB <= PC(BRAM_ADDR_WIDTH-1 downto 0) when Reset = '0' else CounterB;
    
	StateMachine : process(Fault, Reset, MemAck, PC)
	begin
        if Reset = '1' then
            -- Disconnect from memory
            MemAddr <= (others => 'Z');
            
            -- Reset data
            WriteA <= '1';
            WriteB <= '1';
            
            Halt <= '1';
            MemRq <= '0';
        elsif Fault = '1' then
            Halt <= '1';
            
            -- Ask for access and 
            if MemAck = '0' then
                MemAddr <= (others => 'Z');
                MemRq <= '1';
            else
                MemRq <= '0';
                MemAddr <= PC;
            end if;
            
            -- Fetch data until correct (might get lucky)
            WriteA <= '1';
            WriteB <= '0';
        else
            -- Disconnect from memory
            MemAddr <= (others => 'Z');
            
            -- Don't corrupt the data
            WriteA <= '0';
            WriteB <= '0';
            
            Halt <= '0';
            MemRq <= '0';
        end if;
	end process;
	
end Behavioral;

