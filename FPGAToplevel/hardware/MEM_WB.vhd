library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use work.constants.all;

entity MEM_WB is
    port ( 
        -- Control signals
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        disable : in  STD_LOGIC;
        
        -- Ins
        pc_in : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data_in : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        gene_in : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        rda_in : in  STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
        res_in : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        
        -- Outs
        pc_out : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        data_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        gene_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        rda_out : out STD_LOGIC_VECTOR (REG_ADDR_WIDTH-1 downto 0);
        res_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        
        -- WB Control Ins
        to_reg_in : in  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
        call_in : in  STD_LOGIC;
        reg_write_in : in  STD_LOGIC;
        
        -- WB Control Outs
        to_reg_out : out  STD_LOGIC_VECTOR(TO_REG_OP_WIDTH-1 downto 0);
        call_out : out  STD_LOGIC;
        reg_write_out : out  STD_LOGIC
    );
end MEM_WB;

architecture Behavioral of MEM_WB is
begin


    process (clk, reset, disable, pc_in, data_in, gene_in, rda_in, res_in, to_reg_in, call_in, reg_write_in)
    begin 
        if rising_edge(clk) then
            if reset = '1' then 
                -- Outs
                pc_out <= (others => '0');
                data_out <= (others => '0');
                gene_out <= (others => '0');
                rda_out <= (others => '0');
                res_out <= (others => '0');
                
                -- WB Control Outs
                to_reg_out <= (others => '0');
                call_out <= '0';
                reg_write_out <= '0';
                
            elsif disable = '0' then 
                -- Outs
                pc_out <= pc_in;
                data_out <= data_in;
                gene_out <= gene_in;
                rda_out <= rda_in;
                res_out <= res_in;
                
                -- WB Control Outs
                to_reg_out <= to_reg_in;
                call_out <= call_in;
                reg_write_out <= reg_write_in;
                
            end if;
        end if;
    end process;

end Behavioral;

