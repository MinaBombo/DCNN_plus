library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity WindowBuffer is
port(
    clk_c, reset_in , enable_in : in std_logic;
    window_in : in window_t;
    window_out : out window_t
);
end entity WindowBuffer;

architecture window_buffer_arch of WindowBuffer is
signal window_s : window_t;
begin
    Latching_Logic : process (clk_c , reset_in)
    begin
        if(reset_in = '1') then
            window_s <= NULL_WINDOW;
        elsif(rising_edge(clk_c)) then
            if(enable_in = '1') then
                window_s <= window_in;
            end if;
        end if;
    end process;
    window_out <= window_s;
end architecture window_buffer_arch;