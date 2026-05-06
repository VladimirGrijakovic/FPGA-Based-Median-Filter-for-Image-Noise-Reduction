library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sort2_tb is
end sort2_tb;

architecture Behavioral of sort2_tb is
    signal clk : std_logic := '0';
    signal in1 : std_logic_vector(7 downto 0) := "00000000";
    signal in2 : std_logic_vector(7 downto 0) := "00000000";
    signal out1 : std_logic_vector(7 downto 0);
    signal out2 : std_logic_vector(7 downto 0);
    
    constant Tclk : time := 20ns;
begin
    
    clk_gen : clk <= not clk after Tclk/2;
    
    dut : entity work.sort2 port map(in1 => in1, in2 => in2, out1 => out1, out2 => out2);

    process is
    begin
        
        wait for 4*Tclk;
        in1 <= "00000011";
        in2 <= "00000010";
    
        wait for 4*Tclk;
        in1 <= "00000111";
        in2 <= "00010000";
        
        wait for 4*Tclk;
        in1 <= "00000001";
        in2 <= "00000001";
    
        wait;
    end process;
    
end Behavioral;
