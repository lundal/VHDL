----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:25 10/13/2013 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity forwarding_unit is
    Port ( rs : in  STD_LOGIC_VECTOR (4 downto 0);
           rt : in  STD_LOGIC_VECTOR (4 downto 0);
           stage3_reg_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           stage4_reg_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           stage3_reg_write : in  STD_LOGIC;
           stage4_reg_write : in  STD_LOGIC;
           forwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           forwardB : out  STD_LOGIC_VECTOR (1 downto 0));
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin


FORWARD_UNIT : process (rs, rt, stage3_reg_rd, stage4_reg_rd, stage3_reg_write, stage4_reg_write)
    begin 
        -- MEM hazard
        if (stage4_reg_write = '1' 
            and (stage4_reg_rd /= "00000")
            and not (stage3_reg_write = '1' and (stage3_reg_rd /= "00000"))
                and (stage3_reg_rd /= rs)
            and (stage4_reg_rd = rs)) then 
            
            forwardA <= "01";
            
        else 
            forwardA <= "00";
        end if; 
        
        
        if (stage4_reg_write = '1' 
            and (stage4_reg_rd /= "00000")
            and not (stage3_reg_write = '1' and (stage3_reg_rd /= "00000"))
                and (stage3_reg_rd = rt)
            and (stage4_reg_rd = rt)) then 
            
            forwardB <= "01";
        else 
            forwardB <= "00";
        end if;
            
            
       --EX hazard 
        if (stage3_reg_write = '1'
            and (stage3_reg_rd /= "0000")
            and (stage3_reg_rd = rs)) then 
            
            forwardA <= "10";
        end if;
        
        if (stage3_reg_write = '1'
            and (stage3_reg_rd /= "00000")
            and (stage3_reg_rd = rt)) then 
             
            forwardB <= "10";
        end if;
            
              
end process FORWARD_UNIT;


end Behavioral;

