library ieee;
use ieee.std_logic_1164.all;

library work;
use work.DataTypes.all;

entity WindowIndexCounter is
    port (
        clk_c, enable_in, reset_in : in std_logic;
        stride_in : in std_logic;

        window_index_out : out integer range 0 to 255
  ) ;

    

end WindowIndexCounter;

architecture window_index_counter_arch of WindowIndexCounter is

    signal window_index_s : integer range 0 to 255;
    signal increment_s : integer range 0 to 2;

begin
    increment_s <= 1 when stride_in = STRIDE_ONE else 2 when stride_in = STRIDE_TWO else 0;
    Counting_Logic : process( clk_c, reset_in )
    begin
        if(reset_in = '1') then
            window_index_s <= 0;
        elsif (rising_edge(clk_c)) then
            if(enable_in = '1') then 
                if(window_index_s = 251 or window_index_s = 252) then
                    window_index_s <= 0;
                else
                    window_index_s <= window_index_s + increment_s;
                end if;
            end if;
        end if;
    end process ; -- Counting_Logic

    window_index_out <= window_index_s;

end window_index_counter_arch ; -- window_index_counter_arch