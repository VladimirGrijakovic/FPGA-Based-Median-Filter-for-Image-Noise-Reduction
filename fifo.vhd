library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
use work.RAM_definitions_PK.all;

entity fifo is
    generic (
        G_RAM_WIDTH : integer := 8;            		    -- Specify RAM data width
        G_RAM_DEPTH : integer := 252; 				        -- Specify RAM depth (number of entries)
        G_RAM_PERFORMANCE : string := "HIGH_PERFORMANCE"   -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    );
    port (
        din  : in std_logic_vector(G_RAM_WIDTH-1 downto 0);		  -- RAM input data
        reset : in std_logic;
        clk  : in std_logic;                       			  -- Clock
        read_en  : in std_logic; 
        write_en : in std_logic;                      			  -- RAM Enable, for additional power savings, disable port when not in use
        dout : out std_logic_vector(G_RAM_WIDTH-1 downto 0) 		  -- RAM output data
    );
end fifo;

architecture Behavioral of fifo is
    signal dout_reg : std_logic_vector(G_RAM_WIDTH-1 downto 0);
    type ram_type is array (0 to G_RAM_DEPTH-1) of std_logic_vector (G_RAM_WIDTH-1 downto 0);          -- 2D Array Declaration for RAM signal
    signal ram_data : std_logic_vector(G_RAM_WIDTH-1 downto 0);
    -- Define RAM
    signal ram_name : ram_type;
    
    signal addr_first : std_logic_vector((clogb2(G_RAM_DEPTH)) downto 0);
    signal addr_last : std_logic_vector((clogb2(G_RAM_DEPTH)) downto 0);
begin
    
    --upis u memoriju
    addr_logic : process(clk) is
    begin
        if(reset = '1') then
            addr_first <= (others => '0');
            addr_last <= (others => '0');
        elsif(rising_edge(clk)) then
            --upis
            if(write_en = '1') then
                if(unsigned(addr_last) = 251) then
                    addr_last <= (others => '0');
                else
                    addr_last <= std_logic_vector(unsigned(addr_last) + 1);
                end if;
                ram_name(to_integer(unsigned(addr_last))) <= din;
            end if;
            
            --citanje
            if(read_en = '1') then
                if(unsigned(addr_first) = 251) then
                    addr_first <= (others => '0');
                else
                    addr_first <= std_logic_vector(unsigned(addr_first) + 1);
                end if;
                ram_data <= ram_name(to_integer(unsigned(addr_first)));
            end if;
        end if;
    end process;
    
    
    
    
    no_output_register : if G_RAM_PERFORMANCE = "LOW_LATENCY" generate
        dout <= ram_data;
    end generate;
    
      
    output_register : if G_RAM_PERFORMANCE = "HIGH_PERFORMANCE"  generate
    process(clk)
    begin
        if(rising_edge(clk)) then
            dout_reg <= ram_data;
        end if;
    end process;
    dout <= dout_reg;
    end generate;

end Behavioral;
