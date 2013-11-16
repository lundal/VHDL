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
    
    signal AddrIn     : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal InstAddr   : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal CacheAddr  : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    signal Fault      : STD_LOGIC := '0';
	signal Write      : STD_LOGIC := '0';
    
    signal CounterA : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    signal CounterB : STD_LOGIC_VECTOR(BRAM_ADDR_WIDTH-1 downto 0);
    
    signal PC_Prev : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal PC_Curr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0) := (others => '0');
	
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
        A_ADDR => CacheAddr,
        A_IN   => MemData,
        A_OUT  => Inst,
        A_WE   => Write,
        A_EN   => '1',
        
        B_ADDR => (others => '0'),
        B_IN   => (others => '0'),
        --B_OUT  => Inst,
        B_WE   => '0',
        B_EN   => '0',
        
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
        A_ADDR => CacheAddr,
        A_IN   => AddrIn,
        A_OUT  => InstAddr,
        A_WE   => Write,
        A_EN   => '1',
        
        B_ADDR => CounterB,
        B_IN   => (others => '0'),
        --B_OUT  => InstAddrB,
        B_WE   => Reset,
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
    
    FF_PC : process (Clock, PC)
    begin
        if rising_edge(Clock) then
            PC_Prev <= PC;
        end if;
    end process;
    
    Fault <= '1' when InstAddr = (ADDR_WIDTH-1 downto 0 => '0') or InstAddr /= PC_Prev else '0';
    
    AddrIn <= PC_Curr when Reset = '0' else (others => '0');
    
    PC_Curr <= PC_Prev when Fault = '1' else PC;
    
    CacheAddr <= PC_Curr(BRAM_ADDR_WIDTH-1 downto 0) when Reset = '0' else CounterA;
    
	StateMachine : process(Fault, Reset, MemAck, PC_Curr)
	begin
        if Reset = '1' then
            -- Disconnect from memory
            MemAddr <= (others => 'Z');
            
            -- Reset data
            Write <= '1';
            
            Halt <= '0';
            MemRq <= '0';
        else
            if Fault = '1' then
                if MemAck = '1' then
                    -- Replace data
                    MemRq <= '0';
                    MemAddr <= PC_Curr;
                    Write <= '1';
                    Halt <= '0';
                else
                    -- Wait for ack
                    MemRq <= '1';
                    MemAddr <= (others => 'Z');
                    Write <= '0';
                    Halt <= '1';
                end if;
            else
                -- Everything OK
                MemRq <= '0';
                MemAddr <= (others => 'Z');
                Write <= '0';
                Halt <= '0';
            end if;
        end if;
	end process;
	
end Behavioral;

