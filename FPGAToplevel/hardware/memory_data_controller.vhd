----------------------------------------------------------------------------------
-- Engineer: Per Thomas Lundal
-- Project:  Galapagos
-- Created:  2013-11-14 00:47
-- Tested:   Never
--
-- Description:
-- TODO
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory_data_controller is
    generic (
        NUM_PROC   : natural := 4;
        ADDR_WIDTH : natural := 19;
        DATA_WIDTH : natural := 64
    );
    port (
        -- Control signals
        REQUEST_0 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        REQUEST_1 : in  STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        ACK       : out STD_LOGIC_VECTOR(NUM_PROC-1 downto 0);
        
        -- Buses
        PROC_ADDR     : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        PROC_DATA_IN  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        PROC_DATA_OUT : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        
        -- Memory
        MEM_ADDR   : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        MEM_DATA   : inout STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0);
        MEM_ENABLE : out STD_LOGIC;
        MEM_WRITE  : out STD_LOGIC;
        MEM_LBUB   : out STD_LOGIC;
        
        CLK : in  STD_LOGIC
    );
end memory_data_controller;

architecture Behavioral of memory_data_controller is
    
    signal counter : UNSIGNED(2-1 downto 0) := (others => '0');
    
    -- Internal control signals
    signal read_0 : STD_LOGIC := '0';
    signal read_1 : STD_LOGIC := '0';
    signal read_2 : STD_LOGIC := '0';
    signal read_3 : STD_LOGIC := '0';
    signal fetch : STD_LOGIC := '0';
    signal write : STD_LOGIC := '0';
    signal increment : STD_LOGIC := '0';
    
    -- Flip-Flop data
    signal read_0_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal read_1_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal read_2_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal read_3_data : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal write_data : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal write_out : STD_LOGIC_VECTOR(DATA_WIDTH/4-1 downto 0) := (others => '0');
    signal addr : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0) := (others => '0');
    
    -- State machine
    type state_type is (Choose, ReadFetch, Read, WriteFetch, Write0, Write1, Write2);
    signal state : state_type := Choose;
    
begin
    
    FF_READ_0 : process (CLK, read_0, MEM_DATA)
    begin 
        if rising_edge(CLK) and read_0 ='1' then 
            read_0_data <= MEM_DATA;
        end if;
    end process;
    
    FF_READ_1 : process (CLK, read_1, MEM_DATA)
    begin 
        if rising_edge(CLK) and read_1 ='1' then 
            read_1_data <= MEM_DATA;
        end if;
    end process;
    
    FF_READ_2 : process (CLK, read_2, MEM_DATA)
    begin 
        if rising_edge(CLK) and read_2 ='1' then 
            read_2_data <= MEM_DATA;
        end if;
    end process;
    
    FF_READ_3 : process (CLK, read_3, MEM_DATA)
    begin 
        if rising_edge(CLK) and read_3 ='1' then 
            read_3_data <= MEM_DATA;
        end if;
    end process;

    INCREMENTER : process (CLK, increment)
    begin
        if rising_edge(CLK) and increment = '0' then
            counter <= counter + 1;
        end if;
    end process;
    
    DECODER : process (counter)
    begin
        -- Default values
        read_0 <= '0';
        read_1 <= '0';
        read_2 <= '0';
        read_3 <= '0';
        
        if counter = 0 then
            read_0 <= '1';
        elsif counter = 1 then
            read_1 <= '1';
        elsif counter = 2 then
            read_2 <= '1';
        else
            read_3 <= '1';
        end if;
    end process;
    
    FF_DATA_IN : process (CLK, fetch, PROC_DATA_IN)
    begin 
        if rising_edge(CLK) and fetch ='1' then 
            write_data <= PROC_DATA_IN;
        end if;
    end process;
    
    FF_ADDR : process (CLK, fetch, PROC_ADDR)
    begin 
        if rising_edge(CLK) and fetch ='1' then 
            addr <= PROC_ADDR;
        end if;
    end process;
    
    -- MUX: Write out
    write_out <= write_data(NUM_PROC*4/4-1 downto NUM_PROC*3/4) when counter = 0 else
                 write_data(NUM_PROC*3/4-1 downto NUM_PROC*2/4) when counter = 1 else
                 write_data(NUM_PROC*2/4-1 downto NUM_PROC*1/4) when counter = 2 else
                 write_data(NUM_PROC*1/4-1 downto NUM_PROC*0/4) when counter = 3;
    
    -- Tristate
    MEM_DATA <= write_out when write = '1' else (others => 'Z');
    
    -- Memory address
    MEM_ADDR <= STD_LOGIC_VECTOR(UNSIGNED(addr) + counter);
    
    -- Concatenate output
    PROC_DATA_OUT <= read_0_data & read_1_data & read_2_data & read_3_data;
    
    STATE_CHANGER : process (CLK, state)
    begin
        if rising_edge(CLK) then
            case state is
                when Choose =>
                    null;
                
                when ReadFetch =>
                    state <= Read;
                
                when Read =>
                    if counter = 3 then
                        state <= Choose;
                    else
                        state <= Read;
                    end if;
                
                when WriteFetch =>
                    state <= Write0;
                
                when Write0 =>
                    state <= Write1;
                
                when Write1 =>
                    state <= Write2;
                
                when Write2 =>
                    if counter = 3 then
                        state <= Choose;
                    else
                        state <= Write0;
                    end if;
                
            end case;
        end if;
    end process;
    
    STATE_MACHINE : process (CLK, state)
    begin
        -- Defaults
        MEM_ENABLE <= '1';
        MEM_WRITE <= '1';
        MEM_LBUB <= '1';
        fetch <= '1';
        write <= '0';
        increment <= '0';
        
        case state is
            when Choose =>
                null;
            
            when ReadFetch =>
                MEM_ENABLE <= '0';
                MEM_LBUB <= '0';
            
            when Read =>
                MEM_ENABLE <= '0';
                MEM_LBUB <= '0';
            
            when WriteFetch =>
                fetch <= '1';
            
            when Write0 =>
                if CLK = '1' then
                    MEM_WRITE <= '1';
                    MEM_LBUB <= '1';
                else
                    MEM_WRITE <= '0';
                    MEM_LBUB <= '0';
                end if;
            
            when Write1 =>
                MEM_ENABLE <= '0';
                MEM_WRITE <= '0';
                MEM_LBUB <= '0';
                
                write <= '1';
            
            when Write2 =>
                if CLK = '1' then
                    write <= '1';
                else
                    write <= '0';
                end if;
                
                increment <= '1';
                
        end case;
    end process;
end Behavioral;
