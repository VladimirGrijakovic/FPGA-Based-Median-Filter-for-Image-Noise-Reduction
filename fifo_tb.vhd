library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
use work.RAM_definitions_PK.all;

entity fifo_tb is
end fifo_tb;

architecture behavior of fifo_tb is

    -- Signali za testbench
    signal din         : std_logic_vector(7 downto 0);    -- Ulazni podaci za FIFO
    signal reset       : std_logic;                        -- Signal za resetovanje
    signal clk         : std_logic;                        -- Clock signal
    signal read_en     : std_logic;                        -- Signal za omogućavanje čitanja
    signal write_en    : std_logic;                        -- Signal za omogućavanje upisa
    signal dout        : std_logic_vector(7 downto 0);     -- Izlazni podaci iz FIFO

    -- Definisanje perioda takta
    constant clk_period : time := 10 ns;

    -- Instanciranje FIFO komponente
    component fifo is
        generic (
            G_RAM_WIDTH : integer := 8;                      -- Širina podataka RAM-a
            G_RAM_DEPTH : integer := 253;                    -- Dubina FIFO-a
            G_RAM_PERFORMANCE : string := "HIGH_PERFORMANCE" -- Performanse ("HIGH_PERFORMANCE" ili "LOW_LATENCY")
        );
        port (
            din        : in std_logic_vector(7 downto 0);    -- Ulazni podaci
            reset      : in std_logic;                        -- Reset signal
            clk        : in std_logic;                        -- Clock signal
            read_en    : in std_logic;                        -- Signal za omogućavanje čitanja
            write_en   : in std_logic;                        -- Signal za omogućavanje upisa
            dout       : out std_logic_vector(7 downto 0)     -- Izlazni podaci
        );
    end component;

begin
    -- Generisanje takta
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test sekvenca
    stimulus : process
    begin
        -- Inicijalizacija svih signala na početne vrednosti
        reset <= '1';
        din <= (others => '0');    -- Inicijalizacija podataka na '0'
        read_en <= '0';            -- Onemogući čitanje
        write_en <= '0';           -- Onemogući upis
        wait for clk_period;       -- Sačekaj jedan ciklus da bi sve postavke bile učitane

        -- 1. Testiranje Reset-a
        -- Postavi reset na '1' i čekaj nekoliko ciklusa
        reset <= '0';             -- Deaktiviran reset
        wait for clk_period;      -- Čekaj jedan takt nakon reset-a

       
        write_en <= '1';  -- Omogući upis
        for i in 0 to 252 loop
            din <= std_logic_vector(to_unsigned(i, 8));  -- Upisivanje brojeva od 0 do 252
            wait for clk_period;
        end loop;

        
        din <= (others => '0');
        read_en <= '1';
        
        -- Završiti simulaciju nakon što su svi testovi obavljeni
        wait;
    end process;

    -- Instanciranje FIFO komponente
    uut: fifo port map (
        din => din,
        reset => reset,
        clk => clk,
        read_en => read_en,
        write_en => write_en,
        dout => dout
    );

end behavior;
