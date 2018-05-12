library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
    port (
        enable_in, reset_in, clk_c, filter_size_in, stride_in : in std_logic;
        increment_out, dma_enable_out, ram_enable_out, ram_read_write_out, data_cache_enable_out, data_cache_read_write_out, filter_cache_enable_out, alu_enable_out : out std_logic
    );
  end entity CU;
  
architecture arch of CU is

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
component FilterCounter is
    port (
        enable_in, reset_in, clk_c, filter_size_in : in std_logic;
        done_out  : out std_logic
    );
end component FilterCounter;
component InitCounter is
    port (
        enable_in, reset_in, clk_c : in std_logic;
        done_out : out std_logic
    );
end component InitCounter;
component StateCounter is
    port (
        enable_in, reset_in, clk_c, stride_in : in std_logic;
        read_write_ram_out  : out std_logic
    );
end component StateCounter;
signal filter_done_s, init_done_s, state_ram_read_write_s, state_data_cache_read_write_s : std_logic;
begin


    -- This logic needs checking
    --Makes no sense belnsbaly, m4 el mfrod da fe le input counter, wla 2ee?
    input_counter_enable_s <= should_increment_in;
    output_counter_enable_s <= '1' when enable_in = '1' and read_write_in = READ_OPERATION else '0';

    OutputCounter : WindowIndexCounter port map ( clk_c => clk_c, enable_in => output_counter_enable_s, reset_in => reset_in,
                                                  stride_in => stride_in, 
                                                  window_index_out => window_index_s );

    InputCounter : WindowRowIndexCounter port map ( clk_c => clk_c, enable_in => input_counter_enable_s, reset_in => reset_in,
                                                    stride_in => stride_in, 
                                                    window_row_index_out => window_row_index_s );

    -- End of logic

    Filter_Counter  : FilterCounter port map (enable_in => enable_in, reset_in => reset_in, clk_c => clk_c, filter_size_in => filter_size_in,
                                             done_out => filter_done_s);
    Init_Counter    : InitCounter port map   (enable_in => filter_done_s, reset_in => reset_in, clk_c => clk_c,
                                             done_out => init_done_s);
    State_Counter   : StateCounter port map  (enable_in => init_done_s, reset_in => reset_in, clk_c => clk_c, stride_in => stride_in,
                                             read_write_ram_out => state_ram_read_write_s);

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