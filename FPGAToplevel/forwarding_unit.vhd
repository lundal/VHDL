----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:53:40 10/24/2013 
-- Design Name: 
-- Module Name:    forwarding_unit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity forwarding_unit is
    Port ( EX_MEM_reg_write        : in  STD_LOGIC;
           MEM_WB_reg_write        : in  STD_LOGIC;
           rs_addr                 : in  STD_LOGIC_VECTOR (4 downto 0);
           rt_addr                 : in  STD_LOGIC_VECTOR (4 downto 0);
           EX_MEM_write_reg_addr   : in  STD_LOGIC_VECTOR (4 downto 0);
           MEM_WB_write_reg_addr   : in  STD_LOGIC_VECTOR (4 downto 0);
           forward_a               : out STD_LOGIC_VECTOR (1 downto 0);
           forward_b               : out STD_LOGIC_VECTOR (1 downto 0));
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin

    A_HAZARD : process(MEM_WB_reg_write, MEM_WB_write_reg_addr, EX_MEM_reg_write, EX_MEM_write_reg_addr, rs_addr) begin
        
        -- EXECUTE HAZARD
        if (EX_MEM_reg_write = '1')
        and (EX_MEM_write_reg_addr /= "00000")
        and (EX_MEM_write_reg_addr = rs_addr) 
        then
            forward_a <= "10";
        
        -- MEMORY HAZARD
        elsif ((MEM_WB_reg_write = '1')
        and (MEM_WB_write_reg_addr /= "00000")
      --  and not ((EX_MEM_reg_write = '1') and (EX_MEM_write_reg_addr /= "00000") and (EX_MEM_write_reg_addr = rs_addr))
        and (MEM_WB_write_reg_addr = rs_addr))
        then
            forward_a <= "01";
        
        -- NO HAZARD
        else
            forward_a <= "00";
        end if;    
    end process;
    
    B_HAZARD : process(MEM_WB_reg_write, MEM_WB_write_reg_addr, EX_MEM_reg_write, EX_MEM_write_reg_addr, rt_addr) begin
        -- EXECUTE HAZARD
        if ((EX_MEM_reg_write = '1')
        and (EX_MEM_write_reg_addr /= "00000")
        and (EX_MEM_write_reg_addr = rt_addr)) 
        then
            forward_b <= "10";
        
        -- MEMORY HAZARD
        elsif ((MEM_WB_reg_write = '1')
        and (MEM_WB_write_reg_addr /= "00000")
        --and not ((EX_MEM_reg_write = '1') and (EX_MEM_write_reg_addr /= "00000") and (EX_MEM_write_reg_addr /= rt_addr))
        and (MEM_WB_write_reg_addr = rt_addr))
        then
            forward_b <= "01";
            
        -- NO HAZARD
        else
            forward_b <= "00";
        end if;    
    end process;

end Behavioral;

