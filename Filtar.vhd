library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.RAM_definitions_PK.all;

entity Filtar is
    port(
        reset : in std_logic;
        clk : in std_logic;
        data_out : out std_logic_vector(7 downto 0)
    );
end Filtar;

architecture Behavioral of Filtar is
    --registri koji cuvaju 9 bita koje trenutno treba obraditi (poslati u Odd-Even Merge)
    type data_regs is array(0 to 8) of std_logic_vector(7 downto 0);
    signal a : data_regs;
    
    --adrese za upis i citanje iz rama
    signal addr_write : std_logic_vector((clogb2(256*256)-1) downto 0);
    signal addr_read : std_logic_vector((clogb2(256*256)-1) downto 0);
    
    --podatak iz rama pre obrade
    signal data_before : std_logic_vector(7 downto 0);
    --podatak koji ide u ram posle obrade
    signal data_after : std_logic_vector(7 downto 0);
    
    --enable signal za upis u ram memoriju
    signal ram_wen : std_logic;
    
    --masina stanja
    --load - punjenje fifo bafera i registara a(0-8) i cakenja da OddEvenMerge obradi prvi ulaz, nema upisa u memoriju
    --processing - nastavlja se citanje bajtova a istovremeno se nazad u memorijuvrsi upis novih bajtova dobijenih in OddEvenMerge
    --wait_state - nastavlja se citanje bajtova ali se na kratko zaustavlja upis jer se ceka validan ulaz na OddEvenMerge
    --end_state - obrada slike zavrsena, nema vise promena
    type state_type is (load, processing, wait_state, end_state);
    signal fsm_state, next_state : state_type;
    
    --brojac
    signal cnt : integer;
    
    --brojac za stanje processing
    signal cnt_proc : integer;
    
    --brojac za stanje wait_state
    signal cnt_wait : integer;
    
    
    --signali za aktiviranje citanja i pisanja fifo bafera
    signal fifo1_ren, fifo2_ren : std_logic;
    signal fifo1_wen, fifo2_wen : std_logic;
    
begin

    --ram memorija u kojoj se nalazi slika
    ram : entity work.im_ram generic map(
        G_RAM_WIDTH => 8,
        G_RAM_DEPTH => 256*256,
        --G_RAM_PERFORMANCE => "LOW_LATENCY"
        G_RAM_PERFORMANCE => "HIGH_PERFORMANCE"
    )
    port map(
        addra => addr_write,    
        addrb => addr_read,    
        dina  => data_after,		 
        clka => clk,                       			 
        wea => ram_wen,                       			  
        enb => '1',                      			  
        rstb => reset,                       			  
        regceb => '1',                       			 
        doutb => data_before
    );
    
    --na izlazu data_out je obradjen piksel (izlaz OddEvenMerge filtera) samo u processing stanju, inace je 0
    data_out_logic : process(fsm_state, data_after) is
    begin
        if(fsm_state = processing) then
            data_out <= data_after;
        else
            data_out <= (others => '0');
        end if;
    end process;
    
    

    process(clk) is
    begin
        if(rising_edge(clk)) then
            a(0) <= data_before;
            a(1) <= a(0);
            a(2) <= a(1);
        end if;
    end process;
    
    fifo1 : entity work.fifo port map(din => a(2),reset => reset,clk => clk,read_en => fifo1_ren ,write_en => fifo1_wen,dout => a(3));
    
    process(clk) is
    begin
        if(rising_edge(clk)) then
            a(4) <= a(3);
            a(5) <= a(4);
        end if;
    end process;
    
    fifo2 : entity work.fifo port map(din => a(5),reset => reset,clk => clk,read_en => fifo2_ren,write_en => fifo2_wen,dout => a(6));
    
    process(clk) is
    begin
        if(rising_edge(clk)) then
            a(7) <= a(6);
            a(8) <= a(7);
        end if;
    end process;
    
    Odd_Even_Merge_sort : entity work.OddEvenMerge port map(clk => clk, a0 => a(0), a1 => a(1), a2 => a(2),
                                              a3 => a(3), a4 => a(4), a5 => a(5), a6 => a(6), a7 => a(7),
                                              a8 => a(8), s => data_after);
                                              
                                   
    --counter odbrojava na svaki takt dokle god traje obrada slike           
    counter_logic : process(clk, reset) is
    begin
        if(reset = '1') then
            cnt <= 0;
        elsif(rising_edge(clk)) then
            if(fsm_state = end_state) then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    
    --cnt_proc odbrojava samo u stanju wait_state, inace je 0
    cnt_proc_logic : process(clk, reset) is
    begin
        if(reset = '1') then
            cnt_proc <= 0; 
        elsif(rising_edge(clk)) then
            if(fsm_state = processing) then
                cnt_proc <= cnt_proc + 1;
            else
                cnt_proc <= 0;
            end if;
        end if;
    end process;
    
    --cnt_wait odbrojava samo u stanju wait_state, inace je 0
    cnt_wait_logic : process(clk, reset) is
    begin
        if(reset = '1') then
            cnt_wait <= 0; 
        elsif(rising_edge(clk)) then
            if(fsm_state = wait_state) then
                cnt_wait <= cnt_wait + 1;
            else
                cnt_wait <= 0;
            end if;
        end if;
    end process;
                                              
    
    fsm_logic : process(clk, reset) is
    begin
        if(reset = '1') then
            fsm_state <= load;
        elsif(rising_edge(clk)) then
            fsm_state <= next_state;
        end if;
    end process;
    
    
    next_state_logic : process(fsm_state, cnt, addr_write, cnt_wait, cnt_proc) is
    begin
        case fsm_state is
        when load =>
            --Broj taktova koje je potrebno sacekati:
            --Da se napune fifo baferi: 2*253
            --Da se napune a(0-8) registri: 9
            --Da se obradi prvi ulaz u OddEvenMerge: 9
            -- (-1) jer prodje jos jedan takt da fsm_state predje u next_state 
            if(cnt = 2*253 + 9 + 9 - 1 + 1 + 1) then
                next_state <= processing;
            else
                next_state <= load;
            end if;
        when processing =>
            --upis novih bajtova staje kada se dodje do pretposlednjeg u pretposlednjoj vrsti(jer su onda svi preostali bajtovi ivicni)
            if(cnt = 255*256 - 2 - 1 + 1 + 267 + 1) then
                next_state <= end_state;
            --u wait_state se prelazi kada se dodje do pretposlednjeg bajta u vrsti,  tada je adresa + 2 deljiva sa 256, a ovo +1 je jer je potreban takta sa fsm_state predje u next_state
            --elsif((unsigned(addr_write) + 2) mod 256 = 0) then
            elsif(cnt_proc = 256 - 3) then
                next_state <= wait_state;
            else
                next_state <= processing;
            end if;
        when wait_state =>
            --potrebno je sacekati 3 takta
            -- (-1) jer je takt potreban da fsm_state predje u next_state
            if(cnt_wait = 1) then
                next_state <= processing;
            else
                next_state <= wait_state;
            end if;
        when end_state =>
            next_state <= end_state;
        end case;
    end process;
    
    
    fifo_enable : process(fsm_state, cnt) is
    begin
        if(fsm_state = load) then
        
            if(cnt >= 4) then
                fifo1_wen <= '1';
            else
                fifo1_wen <= '0';
            end if;
            
            if(cnt >= 4 + 253 - 1) then
                fifo1_ren <= '1';
            else
                fifo1_ren <= '0';
            end if;
            
            if(cnt >= 7 + 253) then
                fifo2_wen <= '1';
            else
                fifo2_wen <= '0';
            end if;
            
            if(cnt >= 2*(3 + 253) + 1 - 1) then
                fifo2_ren <= '1';
            else
                fifo2_ren <= '0';
            end if;
            
        end if;
    end process;
    
    addr_write_logic : process(clk, reset) is
    begin
        if(reset = '1') then
            --upis novih bajtova(piksela) krece od drugog u drugoj vrsti(jer se ne obradjuju ivicni pikseli)
            addr_write <= std_logic_vector(to_unsigned(255 + 2, addr_write'length));
        elsif(rising_edge(clk)) then
            if(fsm_state = processing or fsm_state = wait_state) then
                addr_write <= std_logic_vector(unsigned(addr_write) + 1);
            else
                addr_write <= std_logic_vector(to_unsigned(255 + 2, addr_write'length));
            end if;
        end if;
    end process;
    
    -- addr_read = cnt
    addr_read <= std_logic_vector(to_unsigned(cnt, addr_read'length));
    
    
    ram_write_enable_logic : process(fsm_state) is
    begin
        case fsm_state is
            when load =>
                ram_wen <= '0';
            when processing =>              
                ram_wen <= '1';
            when wait_state =>
                ram_wen <= '0';
            when end_state =>
                ram_wen <= '0';
        end case;
    end process; 
    
    

end Behavioral;
