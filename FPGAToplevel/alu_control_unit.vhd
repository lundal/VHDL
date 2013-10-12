----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:38:35 10/12/2013 
-- Design Name: 
-- Module Name:    alu_control_unit - Behavioral 
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

library WORK;
use WORK.ALU_CONSTANTS.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_control_unit is
    Port ( alu_op  : in  STD_LOGIC_VECTOR (1 downto 0);
           function_code : in  STD_LOGIC_VECTOR (5 downto 0);
           alu_ctrl_out : in  STD_LOGIC_VECTOR (3 downto 0));
end alu_control_unit;

architecture Behavioral of alu_control_unit is

begin

ALU_CONTROL_PROCESS : process(alu_op, func)
    begin 
        case alu_op is
        when "00" => 
            
            
            
        when "01" =>
            --Arithmetic
            alu_ctrl_out <= function_code;
        
        when "10" =>
         
        when others =>
            --nothing
            alu_ctrl_out <= "0000";
        
        

end Behavioral;

