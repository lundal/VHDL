----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-03 13:16
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
        REQUEST_PROC : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        REQUEST_GENE : in  STD_LOGIC;
        ACK_PROC     : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        ACK_GENE     : out STD_LOGIC;
        INCREMENT    : out STD_LOGIC := '0';
        CLK	         : in  STD_LOGIC
    );
end UnratedController;

architecture Behavioral of UnratedController is
    
    signal request_int : STD_LOGIC_VECTOR(NUM_PROC downto 0) := (others => '0');
    signal ack_int     : STD_LOGIC_VECTOR(NUM_PROC downto 0) := (others => '0');
	signal has_request : STD_LOGIC := '0';
    
begin
    
    -- Combine request and ack signals
    request_int <= REQUEST_PROC & REQUEST_GENE;
    ACK_PROC    <= ack_int(NUM_PROC downto 1);
    ACK_GENE    <= ack_int(0);
    
	-- Check if any request
	has_request <= '0' when request_int(NUM_PROC downto 0) = (NUM_PROC downto 0 => '0') else '1';
    
    CTRL : process (CLK)
		variable chosen : integer range 0 to NUM_PROC := 0;
    begin
        if (rising_edge(CLK)) then
			-- Reset Ack signals
			ack_int <= (others => '0');
            
            -- Do not increment if none connected
            INCREMENT <= '0';
            
            -- Check if there exists a request
            if (has_request = '1') then
                
                -- Go to next (to prevent starvation)
                if (chosen = NUM_PROC) then
                    chosen := 0;
                else
                    chosen := chosen + 1;
                end if;

                -- Choose next (or return to first if none)
                for i in 0 to NUM_PROC-2 loop
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
                
                -- Increment if connected to processor
                if (chosen /= 0) then
                    INCREMENT <= '1';
                end if;
                
            end if;
        end if;
    end process;
    
end Behavioral;
