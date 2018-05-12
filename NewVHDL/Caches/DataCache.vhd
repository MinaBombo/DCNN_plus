library ieee;
use ieee.std_logic_1164.all;

library work;
use work.DataTypes.all;

entity DataCache is
  port (
      clk_c, enable_in, reset_in, stride_in, read_write_in : in std_logic;
      window_index_in, window_row_index_in : in integer range 0 to 255;
      data_in : in window_row_t;
      window_out : out window_t
  ) ;
end DataCache;

architecture data_cache_arch of DataCache is

    component nBitsDecoder is
        port (
            enable_in : in std_logic;
            selection_in : in integer range 0 to 259 ;
    
            data_out : out std_logic_vector(255 downto 0)
        );
    end component;

    signal cache_s, shifted_cache_s : cache_t;
    signal window_index_plus_one, window_index_plus_two, window_index_plus_three, window_index_plus_four : integer range 0 to 259;
    signal first_bit_shift_enable_s, second_bit_shift_enable_s, third_bit_shift_enable_s, fourth_bit_shift_enable_s, fifth_bit_shift_enable_s, all_bit_shit_enable_s : std_logic_vector(255 downto 0);

begin

    Data_Out_S_Row_Generate: for i in 0 to 4 generate
        Data_Out_S_Column_Generate: for j in 0 to 4 generate
            window_out(i)(j) <= cache_s(i)(window_index_in + j);
        end generate Data_Out_S_Column_Generate;
    end generate Data_Out_S_Row_Generate;


    First_Bit_Shift_Decoder : nBitsDecoder port map (
        enable_in => '1', selection_in => window_row_index_in ,
        data_out => first_bit_shift_enable_s
    );
    window_index_plus_one <= window_row_index_in+1;
    Second_Bit_Shift_Decoder : nBitsDecoder port map (
        enable_in => '1', selection_in => window_index_plus_one ,
        data_out => second_bit_shift_enable_s
    );
    window_index_plus_two <= window_row_index_in+2;
    Third_Bit_Shift_Decoder : nBitsDecoder port map (
        enable_in => '1', selection_in => window_index_plus_two ,
        data_out => third_bit_shift_enable_s
    );
    window_index_plus_three <= window_row_index_in+3;
    Fourth_Bit_Shift_Decoder : nBitsDecoder port map (
        enable_in => '1', selection_in => window_index_plus_three ,
        data_out => fourth_bit_shift_enable_s
    );
    window_index_plus_four <= window_row_index_in+4;
    Fifth_Bit_Shift_Decoder : nBitsDecoder port map (
        enable_in => '1', selection_in => window_index_plus_four ,
        data_out => fifth_bit_shift_enable_s
    );

    all_bit_shit_enable_s <= first_bit_shift_enable_s or second_bit_shift_enable_s or third_bit_shift_enable_s or fourth_bit_shift_enable_s or fifth_bit_shift_enable_s;

    Input_Row_Generate: for i in 0 to 3 generate
        Input_Column_Generate: for j in 0 to 255 generate
            shifted_cache_s(i)(j) <= cache_s(i + 1)(j) when all_bit_shit_enable_s(j) = '1' else cache_s(i)(j);
        end generate Input_Column_Generate;
    end generate Input_Row_Generate;


    New_Input_Generate: for i in 0 to 255 generate
        shifted_cache_s(4)(i) <= data_in(i mod 5) when all_bit_shit_enable_s(i) = '1' else cache_s(4)(i);
    end generate New_Input_Generate;
    
    process (clk_c, enable_in, read_write_in)
    begin

        if (enable_in = '1' and read_write_in = WRITE_OPERATION) then
            if (rising_edge(clk_c)) then
                cache_s <= shifted_cache_s;
            end if;
        end if;

    end process;

end data_cache_arch ; -- data_cache_arch