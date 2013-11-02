----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:55 11/02/2013 
-- Design Name: 
-- Module Name:    crossover_toplevel - Behavioral 
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

entity crossover_toplevel is
	generic (N : integer :=64; O : integer :=32);
    Port (
				clk : in STD_LOGIC;
				enabled : in STD_LOGIC;
				control_input : in STD_LOGIC_VECTOR (1 downto 0);
				random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
				parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
				child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
				child2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end crossover_toplevel;

architecture Behavioral of crossover_toplevel is

	-- Crossover_toplevel consists of the three different crossover_cores, 
	-- which are chosen by the value from the control_signal.

	COMPONENT crossover_core_split
    PORT(
         enabled : in STD_LOGIC;
			random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
			parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
			child2 : out  STD_LOGIC_VECTOR (N-1 downto 0)
        );
    END COMPONENT;
	
	COMPONENT crossover_core_doublesplit
    PORT(
         enabled : in STD_LOGIC;
			random_number: in STD_LOGIC_VECTOR (O-1 downto 0);
			parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
			child2 : out  STD_LOGIC_VECTOR (N-1 downto 0)
        );
    END COMPONENT;

	COMPONENT crossover_core_xor
    PORT(
         enabled : IN  std_logic;
         random_number1 : IN  std_logic_vector(O-1 downto 0);
			random_number2 : IN  std_logic_vector(O-1 downto 0);
			parent1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			parent2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			child1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
			child2 : out  STD_LOGIC_VECTOR (N-1 downto 0)
        );
    END COMPONENT;

	COMPONENT flip_flop
		generic (N : natural);
		PORT( clk : in STD_LOGIC;
           reset: in STD_LOGIC;
           enable : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (N-1 downto 0));
	END COMPONENT;
	
	-- Multiplexer for choosing output from the selected crossover_core
	COMPONENT multiplexer_triple
		PORT( sel : in  STD_LOGIC_VECTOR (1 downto 0);
           in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
	END COMPONENT;
	
	
	-- Enabled signals for the different cores
	signal split_enabled : STD_LOGIC;
	signal doublesplit_enabled : STD_LOGIC;
	signal xor_enabled : STD_LOGIC;
	
	-- Outputs from different crossover_cores
	signal split_child1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal split_child2 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal doublesplit_child1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal doublesplit_child2 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal xor_child1 : STD_LOGIC_VECTOR (N-1 downto 0);
	signal xor_child2 : STD_LOGIC_VECTOR (N-1 downto 0);
	
	-- Output from flip-flop, used as random_number2 in core_xor
	signal random_number_ff : STD_LOGIC_VECTOR(O-1 downto 0);
	
	-- Output from multiplexer_triple:
	signal mux_control : STD_LOGIC_VECTOR(1 downto 0);
	
	-- random control signal used if random choice of cores.
	-- Based on the 2 most significant bits from the random_number
	signal random_control_input : STD_LOGIC_VECTOR (1 downto 0);

begin

	core_split: crossover_core_split PORT MAP (
          enabled => split_enabled,
          random_number => random_number,
          parent1 => parent1,
          parent2 => parent2,
          child1 => split_child1,
          child2 => split_child2
        );
		  
	core_doublesplit: crossover_core_doublesplit PORT MAP (
          enabled => doublesplit_enabled,
          random_number => random_number,
          parent1 => parent1,
          parent2 => parent2,
          child1 => doublesplit_child1,
          child2 => doublesplit_child2
        );

	core_xor: crossover_core_xor PORT MAP (
          enabled => xor_enabled,
          random_number1 => random_number,
			 random_number2 => random_number_ff,
          parent1 => parent1,
          parent2 => parent2,
          child1 => xor_child1,
          child2 => xor_child2
        );
		 
	-- Since core_xor needs 2 32-bits inputs for random_numbers,
	-- a flip_flop has been chosen as a solution to avoid usin the same number twice.
	-- The current and the previous random_number will be combined together inside the core
	rn2_storage: flip_flop 
		GENERIC MAP(N => 32)
		PORT MAP(
			clk => clk,
			enable => enabled,
			reset => '0',
			data_in => random_number,
			data_out => random_number_ff
		);
	
	-- Multiplexers used in choosing final output, based on which crossover_core is active
	mux1: multiplexer_triple PORT MAP(
			sel => mux_control,
			in0 => split_child1,
         in1 => doublesplit_child1,
			in2 => xor_child1,
         output => child1
		);
		
	mux2: multiplexer_triple PORT MAP(
			sel => mux_control,
			in0 => split_child2,
         in1 => doublesplit_child2,
			in2 => xor_child2,
         output => child2
	);
		
	random_control_input(1 downto 0) <= random_number(O-1 downto O-2);
	
	CROSSOVER: Process (enabled, control_input, random_number, split_enabled, doublesplit_enabled, xor_enabled, mux_control)
	begin
		if enabled = '1' then
			
			CASE control_input IS
				-- Option 1: Use core_split
				WHEN "00" =>
					split_enabled <= '1';
					doublesplit_enabled <= '0';
					xor_enabled <= '0';
					mux_control <= "00";
					
				-- Option 2: Use core_doublesplit
				WHEN "01" =>
					split_enabled <= '0';
					doublesplit_enabled <= '1';
					xor_enabled <= '0';
					mux_control <= "01";
				
				-- Option 3: Use core_xor
				WHEN "10" =>
					split_enabled <= '0';
					doublesplit_enabled <= '0';
					xor_enabled <= '1';
					mux_control <= "10";
			
				-- Option 4: Randomize the use, based on the 2 first bits of the random_number
				WHEN "11" =>
					CASE random_control_input IS
						
						-- Random choices 1 and 2: core_split
						WHEN "00" =>
							split_enabled <= '1';
							doublesplit_enabled <= '0';
							xor_enabled <= '0';
							mux_control <= "00";
							
						WHEN "01" =>
							split_enabled <= '1';
							doublesplit_enabled <= '0';
							xor_enabled <= '0';
							mux_control <= "00";
						
						-- Random choice 3: core_doublesplit
						WHEN "10" =>
							split_enabled <= '0';
							doublesplit_enabled <= '1';
							xor_enabled <= '0';
							mux_control <= "01";
					
						-- Random choice 4: core_xor
						WHEN "11" =>
							split_enabled <= '0';
							doublesplit_enabled <= '0';
							xor_enabled <= '1';
							mux_control <= "10";
						WHEN OTHERS  =>
							--Absolutely nothing more
					END CASE;
					
				WHEN OTHERS =>
					-- Absolutely nothing more
				
			END CASE;
		else
			split_enabled <='0';
			doublesplit_enabled <='0';
			xor_enabled <='0';
		end if;
	end process;
	
end Behavioral;

