library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use STD.TEXTIO.all;
USE IEEE.numeric_std.all;  

entity Filtar_tb is
end Filtar_tb;

architecture Behavioral of Filtar_tb is

    signal reset : std_logic := '1';
    signal clk : std_logic := '0';
    signal data_out : std_logic_vector(7 downto 0);
    
    constant Tclk :time := 20 ns;
     
    signal write_enable : std_logic := '0';
    file my_output : TEXT open WRITE_MODE is "C:\Users\grija\VHDL vezbanje\VLSI_Projekat\VLSI_Projekat.srcs\sources_1\new\rezultat.txt";
    

begin
    
    dut : entity work.Filtar port map(reset => reset, clk => clk, data_out => data_out);
    
    clk_gen : clk <= not clk after Tclk/2;
    
    stimulus : process is
    begin
    
    wait for 4*Tclk;
    reset <= '0';
    
    --524 taktova se ceka da stanje udje u processing ali treba pustiti 0 na izlaz 257 taktova ranije
    --524-257 = 267
    wait for 268*Tclk + Tclk;
    write_enable <= '1';
    
    --256*256 takova cekamo jer toliko piksela ima slika koju obradjujemo
    wait for 65536*Tclk;
    write_enable <= '0';
       
    wait;
    end process;
    
    
    process(clk)  
        variable my_output_line : LINE;  
    begin  
        
        if rising_edge(clk) then
            if(write_enable = '1') then    
                write(my_output_line, to_integer(unsigned(data_out)));
                writeline(my_output,my_output_line);  
            end if;  
        end if;  
    end process;
    
    
end Behavioral;
