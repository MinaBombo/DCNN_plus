library ieee;
use ieee.std_logic_1164.all;

library work;
use work.DataTypes.all;

entity DataCache is
  port (
      clk_c, enable_in, reset_in, stride_in, read_write_in, should_increment_in : in std_logic;
      data_in : in window_row_t;
      window_out : out window_t
  ) ;
end DataCache;

architecture data_cache_arch of DataCache is

    component WindowIndexCounter is
        port (
            clk_c, enable_in, reset_in : in std_logic;
            stride_in : in std_logic;
    
            window_index_out : out integer range 0 to 255
      ) ;    
    end component;

    component WindowRowIndexCounter is
        port (
            clk_c, enable_in, reset_in : in std_logic;
            stride_in : in std_logic;
    
            window_row_index_out : out integer range 0 to 255
      ) ;    
    end component;


    signal cache_s : cache_t;
    signal window_index_s, window_row_index_s : integer range 0 to 255;
    signal input_counter_enable_s, output_counter_enable_s : std_logic;

begin
    --Makes no sense belnsbaly, m4 el mfrod da fe le input counter, wla 2ee?
    input_counter_enable_s <= should_increment_in;
    output_counter_enable_s <= '1' when enable_in = '1' and read_write_in = READ_OPERATION else '0';

    OutputCounter : WindowIndexCounter port map ( clk_c => clk_c, enable_in => output_counter_enable_s, reset_in => reset_in,
                                                  stride_in => stride_in, 
                                                  window_index_out => window_index_s );

    InputCounter : WindowRowIndexCounter port map ( clk_c => clk_c, enable_in => input_counter_enable_s, reset_in => reset_in,
                                                    stride_in => stride_in, 
                                                    window_row_index_out => window_row_index_s );

    Data_Out_S_Row_Generate: for i in 0 to 4 generate
        Data_Out_S_Column_Generate: for j in 0 to 4 generate
            window_out(i)(j) <= cache_s(i)(window_index_s + j);
        end generate Data_Out_S_Column_Generate;
    end generate Data_Out_S_Row_Generate;

    process (clk_c, enable_in, read_write_in)

    begin

        if (enable_in = '1' and read_write_in = WRITE_OPERATION) then
            if (rising_edge(clk_c)) then
                if(window_row_index_s = 255) then
                    Single_Byte_Input_Shift_Loop: for i in 0 to 3 loop
                        cache_s(i)(window_row_index_s) <= cache_s(i + 1)(window_row_index_s);
                    end loop Single_Byte_Input_Shift_Loop;
                    cache_s(4)(window_row_index_s) <= data_in(0);
                else
                    Input_Row_Loop: for i in 0 to 3 loop
                        Input_Column_Loop: for j in 0 to 4 loop
                            cache_s(i)(window_row_index_s + j) <= cache_s(i + 1)(window_row_index_s + j);
                        end loop Input_Column_Loop;
                    end loop Input_Row_Loop;
                    New_Input_Loop: for i in 0 to 4 loop
                        cache_s(4)(window_row_index_s + i) <= data_in(i);
                    end loop New_Input_Loop;
                end if;
            end if;
        end if;

    end process;

end data_cache_arch ; -- data_cache_arch