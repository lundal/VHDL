library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mutation_core is
    generic (
        N : integer :=64;
        P : integer :=6
    );
    port (
        random_number : in  STD_LOGIC_VECTOR(P+26-1 downto 0);
        chance_input  : in  STD_LOGIC_VECTOR(P-1 downto 0);
        input  : in  STD_LOGIC_VECTOR(N-1 downto 0);
        output : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end mutation_core;

architecture Behavioral of mutation_core is
	 component ShifterVariable is
        generic (
            N : natural := 64;
            M : natural := 6
        );
        port (
            I		:	in	STD_LOGIC_VECTOR(N-1 downto 0);
            O		:	out	STD_LOGIC_VECTOR(N-1 downto 0);
            Left	:	in	STD_LOGIC;
            Arith	:	in	STD_LOGIC;
            Count	:	in	STD_LOGIC_VECTOR(M-1 downto 0)
        );
    end component;
    
    signal one : STD_LOGIC_VECTOR(N-1 downto 0);
    
    signal random_number_chance : STD_LOGIC_VECTOR(P-1 downto 0);
    
	signal random_number1 : STD_LOGIC_VECTOR(6-1 downto 0);
	signal random_number2 : STD_LOGIC_VECTOR(6-1 downto 0);
	signal random_number3 : STD_LOGIC_VECTOR(6-1 downto 0);
	signal random_number4 : STD_LOGIC_VECTOR(6-1 downto 0);
    
    signal mutation_amount : STD_LOGIC_VECTOR(2-1 downto 0);
    
    signal mutation1 : STD_LOGIC_VECTOR(N-1 downto 0);
    signal mutation2 : STD_LOGIC_VECTOR(N-1 downto 0);
    signal mutation3 : STD_LOGIC_VECTOR(N-1 downto 0);
    signal mutation4 : STD_LOGIC_VECTOR(N-1 downto 0);
    
    signal mutation : STD_LOGIC_VECTOR(N-1 downto 0);
	
begin
    
    SHIFTER1 : ShifterVariable
    generic map (
        N => N,
        M => 6
    )
    port map (
        I     => one,
        O     => mutation1,
        Left  => '1',
        Arith => '0',
        Count => random_number1
    );
    
    SHIFTER2 : ShifterVariable
    generic map (
        N => N,
        M => 6
    )
    port map (
        I     => one,
        O     => mutation2,
        Left  => '1',
        Arith => '0',
        Count => random_number2
    );
    
    SHIFTER3 : ShifterVariable
    generic map (
        N => N,
        M => 6
    )
    port map (
        I     => one,
        O     => mutation3,
        Left  => '1',
        Arith => '0',
        Count => random_number3
    );
    
    SHIFTER4 : ShifterVariable
    generic map (
        N => N,
        M => 6
    )
    port map (
        I     => one,
        O     => mutation4,
        Left  => '1',
        Arith => '0',
        Count => random_number4
    );
    
    -- One
    one <= (0 => '1', others => '0');
    
    -- Mutation spots
    random_number1 <= random_number(6-1 downto 0);
    random_number2 <= random_number(12-1 downto 6);
    random_number3 <= random_number(18-1 downto 12);
    random_number4 <= random_number(24-1 downto 18);
    
    -- Mutaton amount
    mutation_amount <= random_number(26-1 downto 24);
    
    -- Mutaton chance
    random_number_chance <= random_number(P+26-1 downto 26);
    
    MUTATE : process(random_number_chance, chance_input, mutation_amount, mutation1, mutation2, mutation3, mutation4)
	begin
        -- Check probability
        if (random_number_chance < chance_input) then
            -- One mutation
            if (mutation_amount = "00") then
                mutation <= mutation1;
            -- Two mutations
            elsif (mutation_amount = "01") then
                mutation <= mutation1 or mutation2;
            -- Three mutations
            elsif (mutation_amount = "10") then
                mutation <= mutation1 or mutation2 or mutation3;
            -- Four mutations
            else
                mutation <= mutation1 or mutation2 or mutation3 or mutation4;
            end if;
        else
            -- No mutations
            mutation <= (others => '0');
        end if;
    end process;
    
    output <= (input and not mutation) or (not input and mutation);
    
end Behavioral;
