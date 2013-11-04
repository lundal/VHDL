----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-04 14:33
-- Tested:   Never
--
-- Description:
-- TODO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UnratedController is
    generic (
        NUM_PROC   : natural := 4
    );
    port (
        REQUEST_SET  : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        REQUEST_PROC : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        REQUEST_GENE : in  STD_LOGIC;
        ACK_PROC     : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        ACK_GENE     : out STD_LOGIC;
        STORE        : out STD_LOGIC;
        WRITE_FIT    : out STD_LOGIC;
        WRITE_GENE   : out STD_LOGIC;
        CLK	         : in  STD_LOGIC
    );
end UnratedController;

architecture Behavioral of UnratedController is
    
    -- Internal signals
    signal request_int     : STD_LOGIC_VECTOR(NUM_PROC downto 0);
    signal ack_int         : STD_LOGIC_VECTOR(NUM_PROC downto 0);
	signal has_request     : STD_LOGIC := '0';
	signal has_request_set : STD_LOGIC := '0';
    
    -- State
	type   state_type is (Choose, Gene, Proc);
	signal state       : state_type := Choose;
begin
    
    -- Combine request and ack signals
    request_int <= REQUEST_PROC & REQUEST_GENE;
    ACK_PROC    <= ack_int(NUM_PROC downto 1);
    ACK_GENE    <= ack_int(0);
    
	-- Check if any request
	has_request <= '0' when request_int(NUM_PROC downto 0) = (NUM_PROC downto 0 => '0') else '1';
    
	-- Check if any settings request
	has_request_set <= '0' when REQUEST_SET(NUM_PROC-1 downto 0) = (NUM_PROC-1 downto 0 => '0') else '1';
    
	STATE_SELECTOR : process(CLK, state, has_request, has_request_set, request_int, ack_int)
	begin
		if rising_edge(CLK) then
            -- Default state
            state <= Choose;
            
            case state is
                when Choose =>
                    -- If ack given to genetic
                    if (ack_int(0) = '1') then
                        state <= Gene;
                    -- If ack given to processor
                    elsif (has_request = '1') then
                        state <= Proc;
                    elsif (has_request_set = '1') then
                        state <= Choose;
                    end if;
                when Gene =>
                    if (request_int(0) = '0') then
                        state <= Choose;
                    end if;
                when Proc =>
                    state <= Choose;
            end case;
		end if;
	end process;
    
	STATE_MACHINE : process(state)
	begin
        case state is
            when Choose =>
                -- Ack given to genetic
                if (ack_int(0) = '1') then
                    STORE <= '0';
                    WRITE_FIT <= '0';
                    WRITE_GENE <= '0';
                -- Ack given to processor
                elsif (ack_int /= (NUM_PROC downto 0 => '0')) then
                    STORE <= '1';
                    WRITE_FIT <= '1';
                    WRITE_GENE <= '0';
                -- No ack given
                else
                    STORE <= '0';
                    WRITE_FIT <= '0';
                    WRITE_GENE <= '0';
                end if;
            when Gene =>
                STORE <= '0';
                WRITE_FIT <= '0';
                WRITE_GENE <= '0';
            when Proc =>
                STORE <= '1';
                WRITE_FIT <= '0';
                WRITE_GENE <= '1';
        end case;
	end process;
    
    -- Forked out from the state selector since it was extremely complex
    CHOOSER : process (CLK, state, has_request, has_request_set, REQUEST_GENE)
		variable chosen_set : integer range 0 to NUM_PROC-1 := 0;
		variable chosen     : integer range 0 to NUM_PROC   := 0;
    begin
        if (rising_edge(CLK)) then
			-- Reset Ack signals
			ack_int <= (others => '0');
            
            -- If state is changing back to Choose
            if (state = Proc or (state = Gene and REQUEST_GENE = '0')) then
            
                -- Check if there exists a settings request
                if (has_request_set = '1') then
                    
                    -- Go to next (to prevent starvation)
                    if (chosen_set = NUM_PROC-1) then
                        chosen_set := 0;
                    else
                        chosen_set := chosen_set + 1;
                    end if;
                    
                    -- Choose next (or return to original if none)
                    for i in 0 to NUM_PROC-2 loop
                        if REQUEST_SET(chosen) = '0' then
                            if (chosen_set = NUM_PROC-1) then
                                chosen_set := 0;
                            else
                                chosen_set := chosen_set + 1;
                            end if;
                        end if;
                    end loop;
                    
                    -- Send ack
                    ack_int(chosen_set) <= '1';
                    
                -- Check if there exists a request
                elsif (has_request = '1') then
                    
                    -- Go to next (to prevent starvation)
                    if (chosen = NUM_PROC) then
                        chosen := 0;
                    else
                        chosen := chosen + 1;
                    end if;
                    
                    -- Choose next (or return to original if none)
                    for i in 0 to NUM_PROC-1 loop
                        if request_int(chosen) = '0' then
                            if (chosen = NUM_PROC) then
                                chosen := 0;
                            else
                                chosen := chosen + 1;
                            end if;
                        end if;
                    end loop;
                    
                    -- Send ack
                    ack_int(chosen) <= '1';
                    
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;

