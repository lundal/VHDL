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
	
	type StateType is (Choose, Feed);
	
	signal State       : StateType := Choose;
	signal HasRequest  : STD_LOGIC := '0';
	
begin
	
	MemCE <= '1';
	MemWE <= '0';
	MemAddr <= Addr;
	Data <= MemData;
	
	-- Check if any 
	HasRequest <= '0' when Request(NUM_CACHES-1 downto 0) = (NUM_CACHES-1 downto 0 => '0') else '1';
	
	StateSelector : process(Clock, Enabled, HasRequest)
	begin
		if rising_edge(Clock) then
			-- Only go to Feed if there is a request and it is enabled
			if Enabled = '1' and State = Choose and HasRequest = '1' then
				State <= Feed;
			else
				State <= Choose;
			end if;
		end if;
	end process;
	
	StateMachine : process(State, HasRequest, Request)
		variable Chosen : integer range 0 to NUM_CACHES := 0;
	begin
		if State = Choose then
			-- Reset Ack signals
			Ack <= (others => '0');
			
			-- Choose
			for I in 0 to NUM_CACHES-1 loop
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
		else
			-- Let the cache nom on the memory!
			
			-- This is the only cycle with access, so reset Ack
			Ack <= (others => '0');
		end if;
	end process;
	
end Behavioral;

