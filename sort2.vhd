library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sort2 is
    port(
        in1 : in std_logic_vector(7 downto 0);
        in2 : in std_logic_vector(7 downto 0);
        out1 : out std_logic_vector(7 downto 0);
        out2 : out std_logic_vector(7 downto 0)
    );
end sort2;

architecture Behavioral of sort2 is
    
begin
    
    output_logic : process(in1, in2) is
    begin
        if(unsigned(in1) <= unsigned(in2)) then
            out1 <= in1;
            out2 <= in2;
        else
            out1 <= in2;
            out2 <= in1;
        end if;
    end process;
    

end Behavioral;
