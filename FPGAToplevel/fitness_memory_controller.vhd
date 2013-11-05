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
			processor_enable : in std_logic;
			
			--Control signals in
			mem_op : in std_logic_vector(MEM_OP_WIDTH-1 downto 0);
			ack_mem_ctrl : in std_logic;
			
			--Control signals out
			mem_op_ctrl : out std_logic_vector(MEM_OP_WIDTH-1 downto 0);
			request_bus : out std_logic;
			halt 			: out std_logic;
			
			--BUS in
			addr : in std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
			store_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
			
			--Memory bus controller
			addr_bus : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
			data_bus_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
			data_bus_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
			
			--BUS out
			read_data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0)
						
	);
end fitness_memory_controller;

architecture Behavioral of fitness_memory_controller is

type state_type is (REQUEST, WAIT_FOR_ACK, PERFORM_OPERATION, WAIT_FOR_MEMORY);
signal CURRENT_STATE, NEXT_STATE : state_type;

constant WRITE_DATA : std_logic_vector(MEM_OP_WIDTH-1 downto 0) := "11";
constant READ_DATA  : std_logic_vector(MEM_OP_WIDTH-1 downto 0) := "01";
constant NOP 		  : std_logic_vector(MEM_OP_WIDTH-1 downto 0) := "00";

begin

RUN : process(clk, reset)
	begin 
		if reset = '1' then
			CURRENT_STATE <= REQUEST;
		elsif rising_edge(clk) then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process; 

STATE_MACHINE : process(CURRENT_STATE, mem_op, ack_mem_ctrl) 
	begin 
	case CURRENT_STATE is 
		when REQUEST => 
			--Disconnect from buses
			mem_op_ctrl   		 <= (others => 'Z');
 			addr_bus 		 <= (others => 'Z'); 
			data_bus_out 		 <= (others => 'Z'); 			
			
			case mem_op is
				when NOP => 
					halt <= '0';
					request_bus <= '0';
					NEXT_STATE <= REQUEST;
				when others => 
					halt <= '1';
					request_bus <= '1';
					NEXT_STATE <= WAIT_FOR_ACK; 
			end case;
			
		when WAIT_FOR_ACK =>
			if ack_mem_ctrl = '1' then
				request_bus <= '0';
				addr_bus <= addr; --Got access, put addr on bus
			   mem_op_ctrl <= mem_op; 
				if mem_op = WRITE_DATA then 
					data_bus_out <= store_data; -- If write, put data on data bus
					NEXT_STATE <= PERFORM_OPERATION;
				else 
					NEXT_STATE <= WAIT_FOR_MEMORY;
				end if;
			else 
				NEXT_STATE <= WAIT_FOR_ACK;				
			end if;
		
		when WAIT_FOR_MEMORY => 
			if ack_mem_ctrl = '1' then
				NEXT_STATE <= WAIT_FOR_MEMORY;
			elsif ack_mem_ctrl = '0' then 
				read_data_out <= data_bus_in;
				halt <= '0';
				NEXT_STATE <= REQUEST;
			else 
				read_data_out <= (others => '0');
			end if;
			
		when PERFORM_OPERATION => 
			halt <= '0';
			NEXT_STATE <= REQUEST;
			
	end case;
end process STATE_MACHINE;




end Behavioral;

