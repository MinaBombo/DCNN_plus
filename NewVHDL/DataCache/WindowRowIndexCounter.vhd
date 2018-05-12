library ieee;
use ieee.std_logic_1164.all;

library work;
use work.DataTypes.all;

entity WindowRowIndexCounter is
    port (
        clk_c, enable_in, reset_in : in std_logic;
        --Why Stride in???
        stride_in : in std_logic;

        window_row_index_out : out integer range 0 to 255
  ) ;

    

end WindowRowIndexCounter;


architecture window_row_index_counter_arch of WindowRowIndexCounter is
    
    signal window_row_index_s : integer range 0 to 255;

begin
  
    Counting_Logic : process( clk_c, reset_in )
    begin
        if(reset_in = '1') then
            window_row_index_s <= 0;
        elsif (rising_edge(clk_c)) then
            if(enable_in = '1') then 
                if(window_row_index_s = 255) then
                    window_row_index_s <= 0;
                else
                    window_row_index_s <= window_row_index_s + 5;
                end if;
            end if;
        end if;
    end process ; -- Counting_Logic

    window_row_index_out <= window_row_index_s;

end window_row_index_counter_arch ; -- window_row_index_counter_arch