LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_OddEvenMerge IS
END tb_OddEvenMerge;

ARCHITECTURE behavior OF OddEvenMerge_tb IS

    COMPONENT OddEvenMerge
        PORT(
            clk       : IN  STD_LOGIC;
            a0        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a1        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a2        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a3        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a4        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a5        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a6        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a7        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            a8        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            s    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        );
    END COMPONENT;

    -- Signali za povezivanje
    SIGNAL clk_tb : STD_LOGIC := '0';
    SIGNAL a0, a1, a2, a3, a4, a5, a6, a7, a8 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    -- Instanciranje 
    uut: COMPONENT OddEvenMerge
        PORT MAP (
            clk       => clk_tb,
            a0        => a0,
            a1        => a1,
            a2        => a2,
            a3        => a3,
            a4        => a4,
            a5        => a5,
            a6        => a6,
            a7        => a7,
            a8        => a8,
            s => s
        );

    -- Proces za generisanje clock signala
    -- Nisam znao da iskoristim ugradjeni :(
    clk_process : PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR 10 ns;
        clk_tb <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    -- Testovi
    stim_proc: PROCESS
    BEGIN
        -- Test 1: Brojevi u rastućem poretku
        a0 <= "00000001";
        a1 <= "00000010";
        a2 <= "00000011";
        a3 <= "00000100";
        a4 <= "00000101";
        a5 <= "00000110";
        a6 <= "00000111";
        a7 <= "00001000";
        a8 <= "00001001";
        WAIT FOR 20 ns;

        -- Test 2: Brojevi poredjani nasumicno
        a0 <= "00110101";
        a1 <= "01011010";
        a2 <= "00011101";
        a3 <= "11010100";
        a4 <= "01100111";
        a5 <= "10101000";
        a6 <= "00010101";
        a7 <= "11101010";
        a8 <= "01010100";
        WAIT FOR 20 ns;

        -- Test 3: Brojevi u opadajucem poretku
        a0 <= "11111111";
        a1 <= "11111110";
        a2 <= "11111101";
        a3 <= "11111100";
        a4 <= "11111011";
        a5 <= "11111010";
        a6 <= "11111001";
        a7 <= "11111000";
        a8 <= "11110111";
        WAIT FOR 20 ns;

        -- Test 4: Nisu uneseni svi brojevi (neki su 0)
        a0 <= "00000000";
        a1 <= "00000011";
        a2 <= "00000000";
        a3 <= "00000000";
        a4 <= "00000000";
        a5 <= "00000001";
        a6 <= "00000000";
        a7 <= "00000000";
        a8 <= "00000111";
        WAIT FOR 20 ns;

        -- Završiti simulaciju
        WAIT;
    END PROCESS;

END behavior;