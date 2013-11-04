----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-03 13:16
-- Tested:   2013-11-04 14:06
--
-- Description:
-- TODO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GeneticController is
    port (
        RATED_RQ    : out STD_LOGIC;
        RATED_ACK   : in  STD_LOGIC;
        UNRATED_RQ  : out STD_LOGIC;
        UNRATED_ACK : in  STD_LOGIC;
        SEL_0_RUN   : out STD_LOGIC;
        SEL_0_DONE  : in  STD_LOGIC;
        SEL_1_RUN   : out STD_LOGIC;
        SEL_1_DONE  : in  STD_LOGIC;
        STORE       : out STD_LOGIC;
        ENABLE      : in  STD_LOGIC;
        CLK	        : in  STD_LOGIC
    );
end GeneticController;

architecture Behavioral of GeneticController is
    
    -- State
	type   state_type is (Ready, Run, Save);
	signal state       : state_type := Ready;
    
begin
    
	StateSelector : process(CLK, state, RATED_ACK, UNRATED_ACK, SEL_0_DONE, SEL_1_DONE)
	begin
		if rising_edge(CLK) then
			-- Only go to Feed if there is a request and it is enabled
            case state is
                when Ready =>
                    if (RATED_ACK = '1') then
                        state <= Run;
                    end if;
                when Run =>
                    if (SEL_0_DONE = '1' and SEL_1_DONE = '1') then
                        state <= Save;
                    end if;
                when Save =>
                    if (UNRATED_ACK = '1') then
                        state <= Ready;
                    end if;
            end case;
		end if;
	end process;
    
	StateMachine : process(CLK, state, ENABLE, RATED_ACK, UNRATED_ACK, SEL_0_DONE, SEL_1_DONE)
	begin
        -- Only go to Feed if there is a request and it is enabled
        case state is
            when Ready =>
                -- Stay away from unrated pool
                STORE <= '0';
                UNRATED_RQ <= '0';
                
                -- Request rated pool if enabled (stop signal when given ack)
                if (ENABLE = '1' and RATED_ACK = '0') then
                    RATED_RQ <= '1';
                else
                    RATED_RQ <= '0';
                end if;
                
                -- Start selection cores if given access
                if (RATED_ACK = '1') then
                    SEL_0_RUN <= '1';
                    SEL_1_RUN <= '1';
                else
                    SEL_0_RUN <= '0';
                    SEL_1_RUN <= '0';
                end if;
                
            when Run =>
                -- Stay away from unrated pool
                STORE <= '0';
                UNRATED_RQ <= '0';
                
                -- Keep selection cores from restarting
                SEL_0_RUN <= '0';
                SEL_1_RUN <= '0';
                
                -- Request unrated pool if done
                if (SEL_0_DONE = '1' and SEL_1_DONE = '1') then
                    RATED_RQ <= '1';
                else
                    RATED_RQ <= '0';
                end if;
                
            when Save =>
                -- Stay away from rated pool
                RATED_RQ <= '0';
                
                -- Keep selection cores from restarting
                SEL_0_RUN <= '0';
                SEL_1_RUN <= '0';
                
                -- Request unrated pool (stop signal when given ack)
                if (UNRATED_ACK = '0') then
                    UNRATED_RQ <= '1';
                else
                    UNRATED_RQ <= '0';
                end if;
                
                -- Store when given ack
                if (UNRATED_ACK = '1') then
                    STORE <= '1';
                else
                    STORE <= '0';
                end if;
        end case;
	end process;
    
end Behavioral;
