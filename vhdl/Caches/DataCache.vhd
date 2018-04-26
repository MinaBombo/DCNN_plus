library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity DataCache is
    port (
        enable_in, reset_in, clk_c, read_write_in, stride_in : in std_logic;
        data_in : in window_row_t;
        data_out : out window_t
    );
end entity DataCache;
  
architecture arch of DataCache is
type cache_row_t is array(255 downto 0) of byte_t; 
type cache_t is array(4 downto 0) of cache_row_t;
signal cache_s : cache_t;
signal window_index_s, read_index_s : unsigned(7 downto 0);
begin
    
    process (enable_in, reset_in, clk_c)
    begin
        if (reset_in = '1') then
            cache_s <= (others => (others => NULL_BYTE));
            window_index_s <= (others => '0');
            read_index_s <= (others => '0');
        elsif (rising_edge(clk_c)) then
            if (enable_in = '1') then
                if (read_write_in = '1') then
                    
                end if;
            end if;
        end if;
    end process;
    --data_out <= data_s;
end architecture arch;