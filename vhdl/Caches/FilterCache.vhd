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
begin
    corrected_data_in_s <= data_in(0 to 2) & (data_in(3 to 4) and )
    process (enable_in, reset_in, clk_c)
    begin
        if (reset_in = '1') then
            filter_s <= NULL_WINDOW;
        elsif (rising_edge(clk_c)) then
            if (enable_in = '1') then

            end if;
        end if;
    end process;
    filter_out <= filter_s;
end architecture arch;