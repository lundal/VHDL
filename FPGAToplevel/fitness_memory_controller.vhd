----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:52:07 11/01/2013 
-- Design Name: 
-- Module Name:    fitness_memory_controller - Behavioral 
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
use Work.CONSTANTS.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fitness_memory_controller is
	Port (
			clk : in std_logic;
			reset : in std_logic;
			
			--Control signals in
			mem_op : in std_logic_vector(MEM_OP_WIDTH-1 downto 0);
			request_ack : in std_logic;
			
			
			--Control signals out
			op_mem_ctrl : out std_logic_vector(MEM_OP_WIDTH-1 downto 0);
			request_bus : out std_logic;
			halt 			: out std_logic;
			
			--BUS in
			addr : in std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
			store_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
			
			--Memory bus controller
			addr_mem_ctrl : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
			data_mem_ctrl : out std_logic_vector(DATA_WIDTH-1 downto 0);
			read_data_mem_ctrl : in std_logic_vector(DATA_WIDTH-1 downto 0);
			
			--BUS out
			read_data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0)
						
	);
end fitness_memory_controller;

architecture Behavioral of fitness_memory_controller is

type state_type is (REQUEST, WAIT_FOR_ACK);
signal CURRENT_STATE, NEXT_STATE : state_type;

constant WRITE_DATA : std_logic_vector(MEM_OP_WIDTH-1 downto 0) := "11";
constant READ_DATA  : std_logic_vector(MEM_OP_WIDTH-1 downto 0) := "01";

begin

RUN : process(clk)
	begin 
		if reset = '1' then
			CURRENT_STATE <= REQUEST;
		elsif rising_edge(clk) then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process; 

STATE_MACHINE : process(CURRENT_STATE, mem_op, request_ack) 
	begin 
	case CURRENT_STATE is 
		when REQUEST => 
			op_mem_ctrl <= mem_op;
			addr_mem_ctrl <= addr;
			read_data_out <= read_data_mem_ctrl;
			addr_mem_ctrl <= addr;
			
			case mem_op is 
			when READ_DATA =>
				halt <= '1';
				request_bus <= '1';
				NEXT_STATE <= WAIT_FOR_ACK;
			
			when WRITE_DATA =>
				halt <= '1';
				request_bus <= '1';
				NEXT_STATE <= WAIT_FOR_ACK;
			when others => 
				halt <= '1';
				request_bus <= '1';
			end case;
			
		when WAIT_FOR_ACK =>
			if request_ack = '1' then
				NEXT_STATE <= REQUEST;
			end if;
	end case;
end process STATE_MACHINE;




end Behavioral;

