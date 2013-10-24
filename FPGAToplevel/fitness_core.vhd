
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fitness_core is
    generic (
    MEM_ADDR_BUS : integer := 32;
    MEM_DATA_BUS : integer := 32;
    N            : integer := 32
    );
    
    port( clk                 : in  STD_LOGIC;
          reset               : in  STD_LOGIC;
          processor_enable    : in  STD_LOGIC;
          imem_address        : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          imem_data_in        : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_data_in        : in  STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_address        : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_address_wr     : out STD_LOGIC_VECTOR(MEM_ADDR_BUS-1 downto 0);
          dmem_data_out       : out STD_LOGIC_VECTOR(MEM_DATA_BUS-1 downto 0);
          dmem_write_enable   : out STD_LOGIC);

end fitness_core;

architecture Behavioral of fitness_core is

      OP_CODE		:	 std_logic_vector(OP_CODE_WIDTH-1 downto 0);
		FUNC        :   std_logic_vector(ALU_FUNC_WIDHT-1 downto 0);
      ALU_SOURCE	:   std_logic;
		IMM_SOURCE	:	 std_logic;
		REG_SOURCE  :   std_logic;
      REG_WRITE	:	 std_logic;
      CALL        :   std_logic;
      JUMP        :   std_logic;
      ALU_FUNC    :   std_logic_vector(ALU_FUNC_WIDTH-1 downto 0);
      GENE_OP     :   std_logic_vector(GENE_OP_WIDTH-1 downto 0);
      MEM_OP      :   std_logic_vector(MEM_OP_WIDTH-1 downto 0);
      TO_REG      :   std_logic_vector(TO_REG_OP_WIDTH-1 downto 0)
--SIGNAL DECLERATIONS --

--FETCH Signals
 signal  : std_logic_vector(X downto 0);
 signal XXXXXXXX : std_logic;

--DECODE signals-- 
 signal alu_src_decode : std_logic;
 signal XXXXXXXX : std_logic;
 
 --CONTROL SIGNALS--
 
 --Internally used
 
 --Passing signals
 
 
 --END CONTROL SIGNALS--

--EXECUTE signals--
 signal XXXXXXXX : std_logic_vector(X downto 0);
 signal XXXXXXXX : std_logic;
--MEMORY signals--
 signal XXXXXXXX : std_logic_vector(X downto 0);
 signal XXXXXXXX : std_logic;

--WRITE-BACK signals--
 signal XXXXXXXX : std_logic_vector(X downto 0);
 signal XXXXXXXX : std_logic;



begin


end Behavioral;

