library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
    port (
        enable_in, reset_in, clk_c, filter_size_in, stride_in : in std_logic;
        data_cache_output_window_index_out, data_cache_input_window_row_index_out : out integer range 0 to 255;
        data_cache_enable_out, data_cache_read_write_out : out std_logic;
        --dma_read_write out = ram_read_write_out, dma_enable_out = ram_enable_out
        dma_enable_out, dma_read_write_out : out std_logic;
        filter_cache_enable_out : out std_logic;
        filter_cache_index_out : out integer range 0 to 4;
        alu_enable_out : out std_logic
    );
  end entity CU;
  
architecture arch of CU is

component OutputWindowIndexCounter is
    port (
        clk_c, enable_in, reset_in : in std_logic;
        stride_in : in std_logic;

        window_index_out : out integer range 0 to 255
    ) ;
end component;
component InputWindowRowIndexCounter is
    port (
        clk_c, enable_in, reset_in : in std_logic;

        window_row_index_out : out integer range 0 to 255
  ) ;
end component;
component FilterCounter is
    port (
        enable_in, reset_in, clk_c, filter_size_in : in std_logic;
        filter_index_out : out integer range 0 to 4;
        done_out : std_logic
    );
end component;
    signal output_counter_enable_s, input_counter_enable_s, filter_counter_enable_s : std_logic;
    signal filter_counter_done_s : std_logic;
    signal initilization_state_input_counter_enable_s, general_state_input_counter_enable_s  : std_logic;
    signal output_window_index_s,input_window_row_index_s :  integer range 0 to 255;
    signal filter_index_s : integer range 0 to 4;
    signal filter_offset_s : integer range 0 to 1;
    signal init_s : integer range 0 to 4;
    signal state_s : integer range 0 to 2;

begin

    OutputCounter : OutputWindowIndexCounter port map ( clk_c => clk_c, enable_in => output_counter_enable_s, reset_in => reset_in,
                                                        stride_in => stride_in, 
                                                        window_index_out => output_window_index_s );

    InputCounter : InputWindowRowIndexCounter port map ( clk_c => clk_c, enable_in => input_counter_enable_s, reset_in => reset_in, 
                                                        window_row_index_out => input_window_row_index_s );

    Filter_Counter  : FilterCounter port map (enable_in => filter_counter_enable_s, reset_in => reset_in, clk_c => clk_c, filter_size_in => filter_size_in,
                                              filter_index_out => filter_index_s, done_out => filter_counter_done_s  );

    filter_offset_s <= 0 when filter_size_in = FILTER_SIZE_FIVE else 1;
    filter_cache_index_out <= filter_index_s + filter_offset_s;

     filter_counter_enable_s <= '0' when enable_in = '0' or filter_counter_done_s = '1' else '1';

     input_counter_enable_s <= initilization_state_input_counter_enable_s or general_state_input_counter_enable_s;

     initilization_state_input_counter_enable_s <= '0' when enable_in = '0' or filter_counter_enable_s = '1' or init_s = 4 else '1';
     Init_Signal_Logic : process(clk_c, input_window_row_index_s, initilization_state_input_counter_enable_s)
     begin
         if(rising_edge(clk_c)) then
            if(initilization_state_input_counter_enable_s = '1' and input_window_row_index_s = 255)
                init_s <= init_s + 1;
            end if;
        end if;
     end process ; -- Init_Signal_Logic

     general_state_input_counter_enable_s <= '0' when enable_in = '0' or initilization_state_input_counter_enable_s = '1'


     State_Singal_Logic : process( clk_c, general_state_input_counter_enable_s, output_counter_enable_s, output_window_index_s, input_window_row_index_s )
     begin
        if(rising_edge(clk_c)) then
            if((general_state_input_counter_enable_s = '1' and input_window_row_index_s = 255) or (output_counter_enable_s and output_window_index_s  )
        end if;
    end if;
     end process ; -- State_Singal_Logic


















    
    increment_out <= '0' when filter_size_in ='0' and filter_done_s = '0'
                else '1';
    dma_enable_out <= enable_in;
    ram_enable_out <= enable_in;
    ram_read_write_out <= state_ram_read_write_s when filter_done_s = '1' and init_done_s = '1'
                     else '1';
    data_cache_enable_out <= filter_done_s;
    data_cache_read_write_out <= state_data_cache_read_write_s when filter_done_s = '1' and init_done_s = '1'
                            else '1'                           when filter_done_s = '1' and init_done_s = '0'
                            else '0';
    filter_cache_enable_out <= not filter_done_s;
    alu_enable_out <= '0'; -- TODO Check this after adding the ALU
    
end architecture arch;