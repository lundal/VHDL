library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use work.constants.all;

entity EX_MEM is
    port ( 
        -- Control signals
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        disable : in  STD_LOGIC;
        
        -- Ins
        pc_in : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        rs_in : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        rt_in : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        rda_in : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
        res_in : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        
        -- Outs
        pc_out : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        rs_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        rt_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        rda_out : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
        res_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        
        -- Mem Control Ins
        jump_in : in  STD_LOGIC;
        gene_op_in : in  GENE_OP_TYPE;
        mem_op_in : in  MEM_OP_TYPE;
        
        -- Mem Control Outs
        jump_out : out  STD_LOGIC;
        gene_op_out : out  GENE_OP_TYPE;
        mem_op_out : out  MEM_OP_TYPE;
        
        -- WB Control Ins
        to_reg_in : in  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
        call_in : in  STD_LOGIC;
        reg_write_in : in  STD_LOGIC;
        
        -- WB Control Outs
        to_reg_out : out  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
        call_out : out  STD_LOGIC;
        reg_write_out : out  STD_LOGIC
    );
end EX_MEM;

architecture Behavioral of EX_MEM is
begin

    process (clk, reset, disable, pc_in, rs_in, rt_in, rda_in, res_in, jump_in, gene_op_in, mem_op_in, to_reg_in, call_in, reg_write_in)
    begin 
        if rising_edge(clk) then
            if reset = '1' then 
                -- Outs
                pc_out <= (others => '0');
                rs_out <= (others => '0');
                rt_out <= (others => '0');
                rda_out <= (others => '0');
                res_out <= (others => '0');
                
                -- Mem Control Outs
                jump_out <= '0';
                gene_op_out <= GENE_NOP;
                mem_op_out <= MEM_NOP;
                
                -- WB Control Outs
                to_reg_out <= (others => '0');
                call_out <= '0';
                reg_write_out <= '0';
                
            elsif disable = '0' then 
                -- Outs
                pc_out <= pc_in;
                rs_out <= rs_in;
                rt_out <= rt_in;
                rda_out <= rda_in;
                res_out <= res_in;
                
                -- Mem Control Outs
                jump_out <= jump_in;
                gene_op_out <= gene_op_in;
                mem_op_out <= mem_op_in;
                
                -- WB Control Outs
                to_reg_out <= to_reg_in;
                call_out <= call_in;
                reg_write_out <= reg_write_in;
                
            end if;
        end if;
    end process;

end Behavioral;

