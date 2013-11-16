library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use work.CONSTANTS.all;

entity forwarding_unit is
    port (
        MEMORY_reg_write        : in  STD_LOGIC;
        WRITEBACK_reg_write        : in  STD_LOGIC;
        rs_addr                 : in  STD_LOGIC_VECTOR (4 downto 0);
        rt_addr                 : in  STD_LOGIC_VECTOR (4 downto 0);
        MEMORY_write_reg_addr   : in  STD_LOGIC_VECTOR (4 downto 0);
        WRITEBACK_write_reg_addr   : in  STD_LOGIC_VECTOR (4 downto 0);
        forward_a               : out FORWARD_TYPE;
        forward_b               : out FORWARD_TYPE
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin

    A_HAZARD : process(WRITEBACK_reg_write, WRITEBACK_write_reg_addr, MEMORY_reg_write, MEMORY_write_reg_addr, rs_addr) begin
        
        -- EXECUTE HAZARD
        if (MEMORY_reg_write = '1')
        and (MEMORY_write_reg_addr /= "00000")
        and (MEMORY_write_reg_addr = rs_addr) 
        then
            forward_a <= FORWARD_MEM;
        
        -- MEMORY HAZARD
        elsif ((WRITEBACK_reg_write = '1')
        and (WRITEBACK_write_reg_addr /= "00000")
        and (WRITEBACK_write_reg_addr = rs_addr))
        then
            forward_a <= FORWARD_WB;
        
        -- NO HAZARD
        else
            forward_a <= FORWARD_NO;
        end if;    
    end process;
    
    B_HAZARD : process(WRITEBACK_reg_write, WRITEBACK_write_reg_addr, MEMORY_reg_write, MEMORY_write_reg_addr, rt_addr) begin
        -- EXECUTE HAZARD
        if ((MEMORY_reg_write = '1')
        and (MEMORY_write_reg_addr /= "00000")
        and (MEMORY_write_reg_addr = rt_addr)) 
        then
            forward_b <= FORWARD_MEM;
        
        -- MEMORY HAZARD
        elsif ((WRITEBACK_reg_write = '1')
        and (WRITEBACK_write_reg_addr /= "00000")
        and (WRITEBACK_write_reg_addr = rt_addr))
        then
            forward_b <= FORWARD_WB;
            
        -- NO HAZARD
        else
            forward_b <= FORWARD_NO;
        end if;    
    end process;

end Behavioral;

