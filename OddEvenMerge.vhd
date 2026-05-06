library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--package pkg is
--    type regs_type is array(0 to 8) of std_logic_vector(7 downto 0);
--end pkg;

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use work.pkg.all;


entity OddEvenMerge is
    port(
        clk : in std_logic;
        --a : in regs_type; 
        a0 : in std_logic_vector(7 downto 0);
        a1 : in std_logic_vector(7 downto 0);
        a2 : in std_logic_vector(7 downto 0);
        a3 : in std_logic_vector(7 downto 0);
        a4 : in std_logic_vector(7 downto 0);
        a5 : in std_logic_vector(7 downto 0);
        a6 : in std_logic_vector(7 downto 0);
        a7 : in std_logic_vector(7 downto 0);
        a8 : in std_logic_vector(7 downto 0);
        
        s : out std_logic_vector(7 downto 0)
    );
end OddEvenMerge;

architecture Behavioral of OddEvenMerge is
    type regs_type is array(0 to 8) of std_logic_vector(7 downto 0);
    type all_regs is array(0 to 9) of regs_type;
    signal regs : all_regs;
    
    --izlaz prvog stepena:
    signal s1 : regs_type;
    --izlaz drugog stepena:
    signal s2 : regs_type;
    --izlaz treceg stepena:
    signal s3 : regs_type;
    --izlaz cetvrtog stepena:
    signal s4 : regs_type;
    --izlaz petog stepena:
    signal s5 : regs_type;
    --izlaz sestog stepena:
    signal s6 : regs_type;
    --izlaz sedmog stepena:
    signal s7 : regs_type;
    --izlaz osmog stepena:
    signal s8 : regs_type;
    --izlaz devetog stepena:
    signal s9 : regs_type;
    
begin

    --ulaz
    in_regs_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(0)(0) <= a0;
            regs(0)(1) <= a1;
            regs(0)(2) <= a2;
            regs(0)(3) <= a3;
            regs(0)(4) <= a4;
            regs(0)(5) <= a5;
            regs(0)(6) <= a6;
            regs(0)(7) <= a7;
            regs(0)(8) <= a8;
        end if;
    end process;
  
    
    --prvi stepen
    k11: entity work.sort2 port map(in1 => a0, in2 => a1, out1 => s1(0), out2 => s1(1));
    k12: entity work.sort2 port map(in1 => a2, in2 => a3, out1 => s1(2), out2 => s1(3));
    k13: entity work.sort2 port map(in1 => a4, in2 => a5, out1 => s1(4), out2 => s1(5));
    k14: entity work.sort2 port map(in1 => a6, in2 => a7, out1 => s1(6), out2 => s1(7));
    s1(8) <= a8;
    
    regs1_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(1) <= s1;
        end if;
    end process;
    
    --drugi stepen
    k21: entity work.sort2 port map(in1 => regs(1)(0), in2 => regs(1)(2), out1 => s2(0), out2 => s2(2));
    k22: entity work.sort2 port map(in1 => regs(1)(4), in2 => regs(1)(6), out1 => s2(4), out2 => s2(6));
    k23: entity work.sort2 port map(in1 => regs(1)(1), in2 => regs(1)(3), out1 => s2(1), out2 => s2(3));
    k24: entity work.sort2 port map(in1 => regs(1)(5), in2 => regs(1)(7), out1 => s2(5), out2 => s2(7));
    s2(8) <= regs(1)(8);
    
    regs2_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(2) <= s2;
        end if;
    end process;
    
    --treci stepen
    k31: entity work.sort2 port map(in1 => regs(2)(1), in2 => regs(2)(2), out1 => s3(1), out2 => s3(2));
    k32: entity work.sort2 port map(in1 => regs(2)(5), in2 => regs(2)(6), out1 => s3(5), out2 => s3(6));
    s3(0) <= regs(2)(0);
    s3(3) <= regs(2)(3);
    s3(4) <= regs(2)(4);
    s3(7) <= regs(2)(7);
    s3(8) <= regs(2)(8);
    
    regs3_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(3) <= s3;
        end if;
    end process;
    
    --cetvrti stepen
    k41: entity work.sort2 port map(in1 => regs(3)(0), in2 => regs(3)(4), out1 => s4(0), out2 => s4(4));
    k42: entity work.sort2 port map(in1 => regs(3)(1), in2 => regs(3)(5), out1 => s4(1), out2 => s4(5));
    k43: entity work.sort2 port map(in1 => regs(3)(2), in2 => regs(3)(6), out1 => s4(2), out2 => s4(6));
    k44: entity work.sort2 port map(in1 => regs(3)(3), in2 => regs(3)(7), out1 => s4(3), out2 => s4(7));
    s4(8) <= regs(3)(8);
    
    regs4_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(4) <= s4;
        end if;
    end process;
    
    --peti stepen
    k51: entity work.sort2 port map(in1 => regs(4)(2), in2 => regs(4)(4), out1 => s5(2), out2 => s5(4));
    k52: entity work.sort2 port map(in1 => regs(4)(3), in2 => regs(4)(5), out1 => s5(3), out2 => s5(5));
    s5(0) <= regs(4)(0);
    s5(1) <= regs(4)(1);
    s5(6) <= regs(4)(6);
    s5(7) <= regs(4)(7);
    s5(8) <= regs(4)(8);
    
    regs5_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(5) <= s5;
        end if;
    end process;
    
    --sesti stepen
    k61: entity work.sort2 port map(in1 => regs(5)(1), in2 => regs(5)(2), out1 => s6(1), out2 => s6(2));
    k62: entity work.sort2 port map(in1 => regs(5)(3), in2 => regs(5)(4), out1 => s6(3), out2 => s6(4));
    k63: entity work.sort2 port map(in1 => regs(5)(5), in2 => regs(5)(6), out1 => s6(5), out2 => s6(6));
    k64: entity work.sort2 port map(in1 => regs(5)(0), in2 => regs(5)(8), out1 => s6(0), out2 => s6(8));
    s6(7) <= regs(5)(7);
    
    regs6_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(6) <= s6;
        end if;
    end process;
    
    --sedmi stepen
    k71: entity work.sort2 port map(in1 => regs(6)(4), in2 => regs(6)(8), out1 => s7(4), out2 => s7(8));
    s7(0) <= regs(6)(0);
    s7(1) <= regs(6)(1);
    s7(2) <= regs(6)(2);
    s7(3) <= regs(6)(3);
    s7(5) <= regs(6)(5);
    s7(6) <= regs(6)(6);
    s7(7) <= regs(6)(7);
    
    regs7_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(7) <= s7;
        end if;
    end process;
    
    --osmi stepen
    k81: entity work.sort2 port map(in1 => regs(7)(2), in2 => regs(7)(4), out1 => s8(2), out2 => s8(4));
    k82: entity work.sort2 port map(in1 => regs(7)(6), in2 => regs(7)(8), out1 => s8(6), out2 => s8(8));
    k83: entity work.sort2 port map(in1 => regs(7)(3), in2 => regs(7)(5), out1 => s8(3), out2 => s8(5));
    s8(0) <= regs(7)(0);
    s8(1) <= regs(7)(1);
    s8(7) <= regs(7)(7);
    
    regs8_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(8) <= s8;
        end if;
    end process;
    
    --deveti stepen
    k91: entity work.sort2 port map(in1 => regs(8)(1), in2 => regs(8)(2), out1 => s9(1), out2 => s9(2));
    k92: entity work.sort2 port map(in1 => regs(8)(3), in2 => regs(8)(4), out1 => s9(3), out2 => s9(4));
    k93: entity work.sort2 port map(in1 => regs(8)(5), in2 => regs(8)(6), out1 => s9(5), out2 => s9(6));
    k94: entity work.sort2 port map(in1 => regs(8)(7), in2 => regs(8)(8), out1 => s9(7), out2 => s9(8));
    s9(0) <= regs(8)(0);
    
    regs9_logic : process(clk) is
    begin
        if(rising_edge(clk)) then
            regs(9) <= s9;
        end if;
    end process;
    
    --izlaz
    s <= regs(9)(4);
    

end Behavioral;
