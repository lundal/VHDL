----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:41 09/21/2013 
-- Design Name: 
-- Module Name:    Control Unit - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.CONSTANTS.ALL;

entity control_unit is
	port (
		OP_CODE		:	in	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0);
		FUNC        :   in  STD_LOGIC_VECTOR(ALU_FUNC_WIDHT-1 downto 0);
        ALU_SOURCE	:	out	STD_LOGIC;
		IMM_SOURCE	:	out STD_LOGIC;
		REG_SOURCE  :   out STD_LOGIC;
        REG_WRITE	:	out	STD_LOGIC;
        CALL        :   out STD_LOGIC;
        JUMP        :   out STD_LOGIC;
        ALU_FUNC    :   out STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
        GENE_OP     :   out STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0);
        MEM_OP      :   out STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0);
        TO_REG      :   out STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0)
	);
end entity;

architecture Behavioral of control_unit is

begin

CONTROL_UNIT : process (OP_CODE)
    begin 
        case OP_CODE is 
        when RRR =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= NOP; 
            MEM_OP <= NOP;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "001";
            REG_WRITE <= '1';
            
        when RRI =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '1';
            GENE_OP <= NOP; 
            MEM_OP <= NOP;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "001";
            REG_WRITE <= '1';
        
        when CALL =>
            ALU_FUNC <= ADD;
            REG_SOURCE <= '1';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= NOP; 
            MEM_OP <= NOP;
            JUMP <= '1';
            CALL <= '1';
            TO_REG <= "010";
            REG_WRITE <= '1';
            
        when JUMP => 
            ALU_FUNC <= ADD;
            REG_SOURCE <= '1';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= NOP; 
            MEM_OP <= NOP;
            JUMP <= '1';
            CALL <= '0';
            TO_REG <= NOP;
            REG_WRITE <= '0';
        
        when LOAD =>
            ALU_FUNC <= ADD;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '1';
            GENE_OP <= NOP; 
            MEM_OP <= LOAD_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "011";
            REG_WRITE <= '1';
        
        when LOAD_IMM =>
            ALU_FUNC <= ADD;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= NOP; 
            MEM_OP <= LOAD_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "011";
            REG_WRITE <= '1';

        when STORE =>
            ALU_FUNC <= ADD;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '1';
            GENE_OP <= NOP; 
            MEM_OP <= STORE_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= NOP;
            REG_WRITE <= '0';
        
        when STORE_IMM =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= NOP; 
            MEM_OP <= STORE_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= NOP;
            REG_WRITE <= '1';
        
        when LOAD_GENE =>
            ALU_FUNC <= NOP;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= LOAD_GENE; 
            MEM_OP <= NOP;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "000";
            REG_WRITE <= '1';
        
        when STORE_GENE =>
            ALU_FUNC <= NOP;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= NOP; 
            MEM_OP <= NOP;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "000";
            REG_WRITE <= '1';
        
        when SET_GENE_OPS =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= NOP; 
            MEM_OP <= NOP;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "001";
            REG_WRITE <= '1';
        
        
            
        end case;
end process CONTROL_UNIT;


end Behavioral;


