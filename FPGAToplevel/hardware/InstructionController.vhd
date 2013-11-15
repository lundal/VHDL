----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-10-22 15:20
-- Tested:   Never
--
-- Description:
-- Provides caches with access to the instruction memory.
-- Chooses cache based on the round robin principle.
-- Access takes 2 cycles: 1. Caches request access, 2. Selected cache gets access
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionController is
	generic(
		NUM_CACHES : natural := 2;
        ADDR_WIDTH : natural := 19;
        INST_WIDTH : natural := 32
	);
	port(
		MemCE   : out   STD_LOGIC;
		MemWE   : out   STD_LOGIC;
		MemLBUB : out   STD_LOGIC;
		MemAddr	: out   STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		MemData : inout STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
		Request : in    STD_LOGIC_VECTOR(NUM_CACHES-1 downto 0);
		Ack     : out   STD_LOGIC_VECTOR(NUM_CACHES-1 downto 0);
		Addr    : in    STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		Data    : out   STD_LOGIC_VECTOR(INST_WIDTH-1 downto 0);
		Enabled : in    STD_LOGIC;
		Clock   : in    STD_LOGIC
	);
end InstructionController;

architecture Behavioral of InstructionController is
	
	signal HasRequest  : STD_LOGIC := '0';
	
begin
	
	MemCE <= '0';
	MemWE <= '1';
    MemLBUB <= '0';
	MemAddr <= Addr;
	Data <= MemData;
	
	-- Check if any 
	HasRequest <= '0' when Request(NUM_CACHES-1 downto 0) = (NUM_CACHES-1 downto 0 => '0') else '1';
	
	process(Clock, Enabled, HasRequest)
        variable Chosen : integer range 0 to NUM_CACHES-1 := 0;
	begin
		if rising_edge(Clock) and Enabled = '1' and HasRequest = '1' then
            -- Reset ack
            Ack <= (others => '0');
            
            
            -- Go to next (to prevent starvation)
            if Chosen = NUM_CACHES-1 then
                Chosen := 0;
            else
                Chosen := Chosen + 1;
            end if;
                    
            -- Choose (or return to first)
            for I in 0 to NUM_CACHES-2 loop
                if Request(Chosen) = '0' then
                    if Chosen = NUM_CACHES-1 then
                        Chosen := 0;
                    else
                        Chosen := Chosen + 1;
                    end if;
                end if;
            end loop;
            
            -- Send Ack
            if HasRequest = '1' then
                Ack(Chosen) <= '1';
            end if;
		end if;
	end process;
	
end Behavioral;

