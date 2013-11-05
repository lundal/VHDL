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
use work.CONSTANTS.all;

library WORK;
use WORK.CONSTANTS.ALL;

entity control_unit is
	port (
		  OP_CODE		:	in	STD_LOGIC_VECTOR(OP_CODE_WIDTH-1 downto 0);
		  FUNC         :  in  STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
        ALU_SOURCE 	:	out	STD_LOGIC;
		  IMM_SOURCE	:	out STD_LOGIC;
		  REG_SOURCE   :  out STD_LOGIC;
        REG_WRITE	   :	out	STD_LOGIC;
        CALL         :  out STD_LOGIC;
        JUMP         :  out STD_LOGIC;
        ALU_FUNC     :  out STD_LOGIC_VECTOR(ALU_FUNC_WIDTH-1 downto 0);
        GENE_OP      :  out STD_LOGIC_VECTOR(GENE_OP_WIDTH-1 downto 0);
        MEM_OP       :  out STD_LOGIC_VECTOR(MEM_OP_WIDTH-1 downto 0);
        TO_REG       :  out STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
		  STORE_SOURCE :  out STD_LOGIC
	);
end entity;

architecture Behavioral of control_unit is
constant MEM_OP_NA  : std_logic_vector(MEM_OP_WIDTH-1 downto 0) := (others => '0');
constant GENE_OP_NA : std_logic_vector(GENE_OP_WIDTH-1 downto 0):= (others => '0');
constant TO_REG_NA  : std_logic_vector(TO_REG_OP_WIDTH-1 downto 0) := (others => '0');





begin

CONTROL_UNIT : process (OP_CODE, FUNC)
    begin 
        case OP_CODE is 
        when OP_CODE_RRR =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= GENE_OP_NA;
            MEM_OP <= MEM_OP_NA; 
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "001";
            REG_WRITE <= '1';
            
        when OP_CODE_RRI =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '1';
            GENE_OP <= GENE_OP_NA; 
            MEM_OP <= MEM_OP_NA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "001";
            REG_WRITE <= '1';
        
        when OP_CODE_CALL =>
            ALU_FUNC <= ALU_FUNC_ADD;
            REG_SOURCE <= '1';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= GENE_OP_NA;  
            MEM_OP <= MEM_OP_NA; 
            JUMP <= '1';
            CALL <= '1';
            TO_REG <= "010";
            REG_WRITE <= '1';
            
        when OP_CODE_JMP => 
            ALU_FUNC <= ALU_FUNC_ADD;
            REG_SOURCE <= '1';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= GENE_OP_NA; 
            MEM_OP <= MEM_OP_NA;
            JUMP <= '1';
            CALL <= '0';
            TO_REG <= TO_REG_NA; 
            REG_WRITE <= '0';
        
        when OP_CODE_LW =>
            ALU_FUNC <= ALU_FUNC_ADD;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '1';
            GENE_OP <= GENE_OP_NA; 
            MEM_OP <= LOAD_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "011";
            REG_WRITE <= '1';
        
        when OP_CODE_LDI =>
            ALU_FUNC <= ALU_FUNC_ADD;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= GENE_OP_NA;
            MEM_OP <= LOAD_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "011";
            REG_WRITE <= '1';

        when OP_CODE_SW =>
            ALU_FUNC <= ALU_FUNC_ADD;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '1';
            GENE_OP <= GENE_OP_NA; 
            MEM_OP <= STORE_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= TO_REG_NA;
            REG_WRITE <= '0';
        
        when OP_CODE_STI =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '1';
            ALU_SOURCE <= '1';
            GENE_OP <= GENE_OP_NA;
            MEM_OP <= STORE_DATA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= TO_REG_NA;
            REG_WRITE <= '1';
        
        when OP_CODE_LDG =>
            ALU_FUNC <= ALU_FUNC_NA;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= LOAD_GENE; 
            MEM_OP <= GENE_OP_NA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "000";
            REG_WRITE <= '1';
        
        when OP_CODE_STG =>
            ALU_FUNC <= ALU_FUNC_NA;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= STORE_GENE; 
            MEM_OP <= MEM_OP_NA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "000";
            REG_WRITE <= '1';
        
        when OP_CODE_SETG =>
            ALU_FUNC <= FUNC;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= GENE_OP_NA; 
            MEM_OP <= MEM_OP_NA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= "001";
            REG_WRITE <= '1';
        when others => 
				ALU_FUNC <= ALU_FUNC_NA;
            REG_SOURCE <= '0';
            IMM_SOURCE <= '0';
            ALU_SOURCE <= '0';
            GENE_OP <= GENE_OP_NA; 
            MEM_OP <= MEM_OP_NA;
            JUMP <= '0';
            CALL <= '0';
            TO_REG <= TO_REG_NA;
            REG_WRITE <= '0';
		  end case;
end process CONTROL_UNIT;


end Behavioral;


