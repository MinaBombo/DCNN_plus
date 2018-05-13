library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity FilterCounter is
    port (
        enable_in, reset_in, clk_c, filter_size_in : in std_logic;
        filter_index_out : out integer range 0 to 4;
        done_out : out std_logic
    );
end entity FilterCounter;
  
architecture arch of FilterCounter is
signal count_s :  integer range 0 to 4;
signal limit_s : integer range 0 to 4;
signal done_s : std_logic;
begin
    limit_s <= 2 when  filter_size_in = FILTER_SIZE_THREE else 4 when filter_size_in = FILTER_SIZE_FIVE;

    process(enable_in, reset_in, clk_c)
    begin
        if(reset_in = '1') then
            count_s <= 0;
            done_s <= '0';
        elsif(rising_edge(clk_c)) then
            if(enable_in = '1') then 
                if(count_s = limit_s) then
                    count_s <= 0;
                    done_s <= '1';
                else
                    count_s <= count_s + 1;
                    done_s <= '0';
                end if;
            end if;
        end if;
    end process;
    filter_index_out <= count_s;
    done_out <= done_s;
end architecture arch;