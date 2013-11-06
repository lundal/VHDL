library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crossover_toplevel is
	generic (
        N : integer := 64
    );
    port (
        control_input : in  STD_LOGIC_VECTOR(3-1 downto 0);
        random_number : in  STD_LOGIC_VECTOR(N-1 downto 0);
        parent1       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        parent2       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        child1        : out STD_LOGIC_VECTOR(N-1 downto 0);
        child2        : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end crossover_toplevel;

architecture Behavioral of crossover_toplevel is

	-- Crossover_toplevel consists of the three different crossover_cores, 
	-- which are chosen by the value from the control_signal.
    
	component crossover_core_split is
        generic (
            N : integer := 64;
            R : integer := 6
        );
        port (
            random_number : in  STD_LOGIC_VECTOR(R-1 downto 0);
            parent1       : in  STD_LOGIC_VECTOR(N-1 downto 0);
            parent2       : in  STD_LOGIC_VECTOR(N-1 downto 0);
            child1        : out STD_LOGIC_VECTOR(N-1 downto 0);
            child2        : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    component crossover_core_doublesplit is
        generic (
            N : integer := 64;
            R : integer := 6
        );
        port (
            random_number1 : in  STD_LOGIC_VECTOR(R-1 downto 0);
            random_number2 : in  STD_LOGIC_VECTOR(R-1 downto 0);
            parent1        : in  STD_LOGIC_VECTOR(N-1 downto 0);
            parent2        : in  STD_LOGIC_VECTOR(N-1 downto 0);
            child1         : out STD_LOGIC_VECTOR(N-1 downto 0);
            child2         : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    component crossover_core_xor is
        generic (
            N : integer := 64
        );
        port (
            random_number : in  STD_LOGIC_VECTOR(N-1 downto 0);
            parent1       : in  STD_LOGIC_VECTOR(N-1 downto 0);
            parent2       : in  STD_LOGIC_VECTOR(N-1 downto 0);
            child1        : out STD_LOGIC_VECTOR(N-1 downto 0);
            child2        : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    -- Outputs from different crossover_cores
    signal split_child1 : STD_LOGIC_VECTOR (N-1 downto 0);
    signal split_child2 : STD_LOGIC_VECTOR (N-1 downto 0);
    signal doublesplit_child1 : STD_LOGIC_VECTOR (N-1 downto 0);
    signal doublesplit_child2 : STD_LOGIC_VECTOR (N-1 downto 0);
    signal xor_child1 : STD_LOGIC_VECTOR (N-1 downto 0);
    signal xor_child2 : STD_LOGIC_VECTOR (N-1 downto 0);
    
    --
    signal random_ctrl : STD_LOGIC_VECTOR(2-1 downto 0);
begin
    
    CORE_SPLIT : crossover_core_split
    generic map (
        N => N,
        R => 6
    )
    port map (
        random_number => random_number(6-1 downto 0),
        parent1       => parent1,
        parent2       => parent2,
        child1        => split_child1,
        child2        => split_child2
    );
    
    CORE_DOUBLESPLIT : crossover_core_doublesplit
    generic map (
        N => N,
        R => 6
    )
    port map (
        random_number1 => random_number(12-1 downto 6),
        random_number2 => random_number(6-1 downto 0),
        parent1        => parent1,
        parent2        => parent2,
        child1         => doublesplit_child1,
        child2         => doublesplit_child2
    );
    
    CORE_XOR : crossover_core_xor
    generic map (
        N => N
    )
    port map (
        random_number => random_number,
        parent1       => parent1,
        parent2       => parent2,
        child1        => xor_child1,
        child2        => xor_child2
    );
    
    -- Get some bits for party mode
    random_ctrl <= random_number(2-1 downto 0);
    
    CROSSOVER: Process (control_input, random_ctrl, split_child1, split_child2, doublesplit_child1, doublesplit_child2, xor_child1, xor_child2, parent1, parent2)
    begin
		case control_input is
            when "000" =>
                -- Split
                child1 <= split_child1;
                child2 <= split_child2;
            when "001" =>
                -- Double Split
                child1 <= doublesplit_child1;
                child2 <= doublesplit_child2;
            when "010" =>
                -- XOR
                child1 <= xor_child1;
                child2 <= xor_child2;
            when "011" =>
                -- OFF
                child1 <= parent1;
                child2 <= parent2;
            when others =>
                -- Party mode :D
                case random_ctrl is
                    when "00" =>
                        -- Split
                        child1 <= split_child1;
                        child2 <= split_child2;
                    when "01" =>
                        -- Double Split
                        child1 <= doublesplit_child1;
                        child2 <= doublesplit_child2;
                    when "10" =>
                        -- XOR
                        child1 <= xor_child1;
                        child2 <= xor_child2;
                    when others =>
                        -- OFF
                        child1 <= parent1;
                        child2 <= parent2;
                end case;
        end case;
    end process;
    
end Behavioral;

