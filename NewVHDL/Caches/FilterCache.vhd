library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity FilterCache is
    port (
        enable_in, reset_in, clk_c, filter_size_in : in std_logic;
        data_in : in window_row_t;
        filter_out : out window_t
    );
end entity FilterCache;
  
architecture arch of FilterCache is
signal corrected_data_in_s : window_row_t;
signal filter_s : window_t;
signal index_s : integer range 0 to 4;
signal offset_s : integer range 0 to 1;
begin
    corrected_data_in_s(0) <= data_in(0) when filter_size_in = FILTER_SIZE_FIVE else (others => '0');
    corrected_data_in_s(1) <= data_in(1) when filter_size_in = FILTER_SIZE_FIVE else data_in(0);
    corrected_data_in_s(2) <= data_in(2) when filter_size_in = FILTER_SIZE_FIVE else data_in(1);
    corrected_data_in_s(3) <= data_in(3) when filter_size_in = FILTER_SIZE_FIVE else data_in(2);
    corrected_data_in_s(4) <= data_in(4) when filter_size_in = FILTER_SIZE_FIVE else (others => '0');
    offset_s <= 0 when filter_size_in = FILTER_SIZE_FIVE else 1;
    process (enable_in, reset_in, clk_c)
    begin
        if (reset_in = '1') then
            filter_s <= NULL_WINDOW;
            index_s <= 0;
        elsif (rising_edge(clk_c)) then
            if (enable_in = '1') then
                filter_s(index_s+offset_s) <= corrected_data_in_s;
                index_s <= index_s + 1;
            end if;
        end if;
    end process;
    filter_out <= filter_s;
end architecture arch;