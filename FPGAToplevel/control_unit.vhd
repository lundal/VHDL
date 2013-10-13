----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:19:42 10/12/2013 
-- Design Name: 
-- Module Name:    control_unit - Behavioral 
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

entity control_unit is
    Port ( reset : in  STD_LOGIC;
           op_code : in  STD_LOGIC_VECTOR (5 downto 0);
           reg_dst : out  STD_LOGIC_VECTOR (1 downto 0);
           alu_src : out  STD_LOGIC;
           branch : out  STD_LOGIC;
           mem_write  : out  STD_LOGIC;
           reg_write : out  STD_LOGIC;
           mem_to_reg : out  STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

--OPCODES 
constant OP_CODE_RRR           : STD_LOGIC_VECTOR(3 downto 0) := "1000";
constant OP_CODE_RRI           : STD_LOGIC_VECTOR(3 downto 0) := "1100";
constant OP_CODE_RI            : STD_LOGIC_VECTOR(3 downto 0) := "0011"; --Jump and call
constant OP_CODE_LW            : STD_LOGIC_VECTOR(3 downto 0) := "0000";
constant OP_CODE_SW            : STD_LOGIC_VECTOR(3 downto 0) := "0001";
constant OP_CODE_LDI           : STD_LOGIC_VECTOR(3 downto 0) := "0100";
constant OP_CODE_STI           : STD_LOGIC_VECTOR(3 downto 0) := "1010";

constant OP_CODE_LDG           : STD_LOGIC_VECTOR(3 downto 0) := "1001";
constant OP_CODE_SETG          : STD_LOGIC_VECTOR(3 downto 0) := "1001";
constant OP_CODE_STG           : STD_LOGIC_VECTOR(3 downto 0) := "1010";


begin

CONTROL_UNIT_PROCESS : process (op_code, reset)
    begin 
         if reset = '1' then 
            alu_op <= "00";
            reg_dst <= '0';
            alu_src <= '0';
            branch <= '0';
            mem_read <= '0';
            mem_write <= '0';
            reg_write <= '0';
            mem_to_reg <= '0';
         else 
            case op_code is
            while  OP_CODE_RRR =>
                --Set signals
            
            while OP_CODE_RRI => 
                --Set signals
                
            while OP_CODE_RI => 
                --Set signals 
            
            while OP_CODE_LW => 
                --Set signals 
                
            while OP_CODE_SW => 
                --Set signals 
            
            while OP_CODE_LDI => 
                --Set signals 
            
            while OP_CODE_STI => 
                --Set signals 
            
            while OP_CODE_LDG => 
                --Set signals 
                
            while OP_CODE_SETG => 
                --Set signal 
             
            while OP_CODE_STG =>
                --Set signals 
                
            while others => 
                --Should not happen, just to prevent latches
                alu_op <= "00";
                reg_dst <= '0';
                alu_src <= '0';
                branch <= '0';
                mem_read <= '0';
                mem_write <= '0';
                reg_write <= '0';
                mem_to_reg <= '0';
          
           end case;
        end if;
end process CONTROL_UNIT_PROCESS; 



end Behavioral;

