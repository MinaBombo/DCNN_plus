library ieee;
use ieee.std_logic_1164.all;

library work;
use work.DataTypes.all;

entity OutputWindowIndexCounter is
    port (
        clk_c, enable_in, reset_in : in std_logic;
        stride_in : in std_logic;

        window_index_out : out integer range 0 to 255;
        done_out : out std_logic
  ) ;
end OutputWindowIndexCounter;

architecture output_window_index_counter_arch of OutputWindowIndexCounter is

    signal window_index_s : integer range 0 to 255;
    signal increment_s : integer range 0 to 2;
    signal limit_s : integer range 0 to 255;
    signal done_s : std_logic;

begin
    increment_s <= 1 when stride_in = STRIDE_ONE else 2 when stride_in = STRIDE_TWO else 0;
    limit_s <= 250 when stride_in = STRIDE_TWO else 251;
    Counting_Logic : process( clk_c, reset_in )
    begin
        if(reset_in = '1') then
            window_index_s <= 0;
            done_s <= '0';
        elsif (rising_edge(clk_c)) then
            if(enable_in = '1') then 
                if(window_index_s = limit_s) then
                    window_index_s <= 0;
                    done_s <= '1';
                else
                    window_index_s <= window_index_s + increment_s;
                    done_s <= '0';
                end if;
            end if;
        end if;
    end process ; -- Counting_Logic

    window_index_out <= window_index_s;
    done_out <= done_s;

end output_window_index_counter_arch ; -- output_window_index_counter_arch