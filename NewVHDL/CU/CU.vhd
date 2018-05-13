library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity CU is
    port (
        enable_in, reset_in, clk_c, filter_size_in, stride_in : in std_logic;
        data_cache_output_window_index_out, data_cache_input_window_row_index_out : out integer range 0 to 255;
        data_cache_enable_out, data_cache_read_write_out : out std_logic;
        --dma_read_write out = ram_read_write_out, dma_enable_out = ram_enable_out
        dma_enable_out, dma_read_write_out : out std_logic;
        filter_cache_enable_out : out std_logic;
        filter_cache_index_out : out integer range 0 to 4;
        dma_increment_out : out integer range 0 to 5;
        alu_enable_out, done_out : out std_logic
    );
  end entity CU;
  
architecture cu_arch of CU is

component OutputWindowIndexCounter is
    port (
        clk_c, enable_in, reset_in : in std_logic;
        stride_in : in std_logic;

        window_index_out : out integer range 0 to 255;
        done_out : out std_logic
  ) ;
end component;
component InputWindowRowIndexCounter is
    port (
        clk_c, enable_in, reset_in : in std_logic;

        window_row_index_out : out integer range 0 to 255;
        done_out : out std_logic
  ) ;
end component;
component FilterCounter is
    port (
        enable_in, reset_in, clk_c, filter_size_in : in std_logic;
        filter_index_out : out integer range 0 to 4;
        done_out : out  std_logic
    );
end component;
    signal output_counter_enable_s, input_counter_enable_s, filter_counter_enable_s : std_logic;
    signal filter_counter_done_s, input_counter_done_s, output_counter_done_s : std_logic;
    signal initilization_state_input_counter_enable_s, general_state_input_counter_enable_s  : std_logic;
    signal output_window_index_s,input_window_row_index_s :  integer range 0 to 255;
    signal filter_index_s : integer range 0 to 4;
    signal filter_offset_s : integer range 0 to 1;
    signal init_s : integer range 0 to 5;
    signal state_s, new_state_s : integer range 0 to 4;
    signal num_lines_read_s : integer range 0 to 256;

begin

    OutputCounter : OutputWindowIndexCounter port map ( clk_c => clk_c, enable_in => output_counter_enable_s, reset_in => reset_in,
                                                        stride_in => stride_in, 
                                                        window_index_out => output_window_index_s, done_out => output_counter_done_s);

    InputCounter : InputWindowRowIndexCounter port map ( clk_c => clk_c, enable_in => input_counter_enable_s, reset_in => reset_in, 
                                                        window_row_index_out => input_window_row_index_s, done_out => input_counter_done_s );

    Filter_Counter  : FilterCounter port map (enable_in => filter_counter_enable_s, reset_in => reset_in, clk_c => clk_c, filter_size_in => filter_size_in,
                                              filter_index_out => filter_index_s, done_out => filter_counter_done_s  );

    filter_offset_s <= 0 when filter_size_in = FILTER_SIZE_FIVE else 1;
    
    dma_increment_out <= 3 when filter_counter_enable_s = '1' and filter_size_in = FILTER_SIZE_THREE
                    else 1 when input_window_row_index_s = 255
                    else 5;
    
    filter_cache_index_out <= filter_index_s + filter_offset_s;

     filter_counter_enable_s <= '0' when enable_in = '0' or filter_counter_done_s = '1' else '1';

     input_counter_enable_s <= initilization_state_input_counter_enable_s or general_state_input_counter_enable_s;

     initilization_state_input_counter_enable_s <= '0' when enable_in = '0' or filter_counter_enable_s = '1' or init_s = 5 else '1';
     Init_Signal_Logic : process(clk_c, reset_in, input_window_row_index_s, initilization_state_input_counter_enable_s)
     begin
        if(reset_in = '1') then
            init_s <= 0;
        elsif(rising_edge(clk_c)) then
            if(initilization_state_input_counter_enable_s = '1' and input_counter_done_s = '1') then
                init_s <= init_s + 1;
            end if;
        end if;
     end process ; -- Init_Signal_Logic

     general_state_input_counter_enable_s <= '1' when state_s = STATE_READ or state_s = STATE_READ_AGAIN else '0';
     output_counter_enable_s <= '1' when state_s = STATE_WRITE else '0';

    new_state_s <= STATE_NONE       when init_s /= 5
              else STATE_DONE       when (state_s = STATE_WRITE and output_counter_done_s = '1' and ((stride_in = STRIDE_ONE and num_lines_read_s = 256) or (stride_in = STRIDE_TWO and num_lines_read_s = 255)))
              else STATE_WRITE      when (state_s = STATE_NONE and init_s = 5)
                                      or (state_s = STATE_READ and stride_in = STRIDE_ONE and input_counter_done_s = '1')
                                      or (state_s = STATE_READ_AGAIN and stride_in = STRIDE_TWO and input_counter_done_s = '1')
              else STATE_READ       when (state_s = STATE_WRITE and output_counter_done_s = '1')
              else STATE_READ_AGAIN when (state_s = STATE_READ and input_counter_done_s = '1' and stride_in = STRIDE_TWO);

    State_Singal_Logic : process( clk_c, reset_in)
    begin
        if(reset_in = '1') then
            state_s <= STATE_NONE;
        elsif(rising_edge(clk_c)) then
            state_s <= new_state_s;
        end if;
    end process ; -- State_Singal_Logic

    Num_Lines_Read_Logic : process(clk_c, reset_in,input_counter_done_s)
    begin
        if(reset_in = '1') then
            num_lines_read_s <= 0;
        elsif(rising_edge(clk_c)) then
            if(input_counter_done_s = '1') then
                num_lines_read_s <= num_lines_read_s+1;
            end if;
        end if;
    end process;

    data_cache_output_window_index_out <= output_window_index_s;
    data_cache_input_window_row_index_out <= input_window_row_index_s;
    data_cache_enable_out <= output_counter_enable_s or input_counter_enable_s;
    data_cache_read_write_out <= WRITE_OPERATION when input_counter_enable_s = '1' else
                                 READ_OPERATION when output_counter_enable_s = '1' else 'Z';
    dma_enable_out <= output_counter_enable_s or input_counter_enable_s or filter_counter_enable_s;
    dma_read_write_out <= READ_OPERATION when input_counter_enable_s = '1' or filter_counter_enable_s = '1' else
                          WRITE_OPERATION when output_counter_enable_s = '1' else 'Z';
    filter_cache_enable_out <= '1' when filter_counter_enable_s = '1' else '0';
    alu_enable_out <= output_counter_enable_s;
    done_out <= '1' when state_s =  STATE_DONE else '0';
    
end architecture cu_arch; --cu_arch