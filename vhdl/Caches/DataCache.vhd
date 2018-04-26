library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity DataCache is
    port (
        enable_in, reset_in, clk_c, read_write_in, stride_in, filter_size_in : in std_logic;
        data_in : in window_row_t;
        data_out : out window_t
    );
end entity DataCache;
  
architecture arch of DataCache is
type cache_row_t is array(255 downto 0) of byte_t; 
type cache_t is array(4 downto 0) of cache_row_t;
signal cache_s : cache_t;
signal window_index_s, write_index_s, window_index_limit_s, window_index_increment_s : unsigned(7 downto 0);
signal data_out_s : window_t;
signal data_in_s : window_row_t;
begin

    Data_Out_S_Row_Generate: for i in 0 to 4 generate
        Data_Out_S_Column_Generate: for j in 0 to 4 generate
            data_out_s(i)(j) <= cache_s(i)(to_integer(window_index_s)+j);
        end generate Data_Out_S_Column_Generate;
    end generate Data_Out_S_Row_Generate;

    window_index_limit_s <= x"FB" when filter_size_in = '1' else x"FD";
    window_index_increment_s <= x"01" when stride_in = '0' else x"02";

    process (enable_in, reset_in, clk_c)
    begin
        if (reset_in = '1') then
            cache_s <= (others => (others => NULL_BYTE));
            window_index_s <= (others => '0');
            write_index_s <= (others => '0');
        elsif (rising_edge(clk_c)) then
            if (enable_in = '1') then
                if (read_write_in = '1') then
                    data_out <= data_out_s;
                    if (window_index_s < window_index_limit_s) then
                        window_index_s <= window_index_s + window_index_increment_s;
                    else
                        window_index_s <= (others => '0');
                    end if;
                else
                    data_in_s <= data_in;
                    write_index_s <= write_index_s + 5;
                end if;
            end if;
        end if;
    end process;
end architecture arch;