library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity DCNN is
port(
    clk_c, reset_in, start_in,filter_size_in,stride_in : in std_logic;
    ram_data_in : in window_row_t;
    done_out, ram_enable_out, ram_read_write_out : out std_logic;
    ram_address_out : out integer range 0 to 2**18;
    ram_data_out : out byte_t
);
end entity DCNN;

architecture dcnn_arch of DCNN is 
component DMA is
    port (
        enable_in, reset_in, clk_c, read_write_in : in std_logic;
        increment_in : in integer range 0 to 5;

        address_out : out integer range 0 to 2**18
    );
end component;
component CU is
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
end component;
component DataCache is
  port (
      clk_c, enable_in, reset_in, stride_in, read_write_in : in std_logic;
      window_index_in, window_row_index_in : in integer range 0 to 255;
      data_in : in window_row_t;
      window_out : out window_t
  ) ;
end component;
component FilterCache is
    port (
        enable_in, reset_in, clk_c, filter_size_in : in std_logic;
        index_in : in integer range 0 to 4;
        data_in : in window_row_t;
        filter_out : out window_t
    );
end component FilterCache;
component ALU is
port(
    clk_c, reset_in , enable_in : in std_logic;
    window_in,filter_in : in window_t;
    pixel_out : out byte_t
);
end component;
signal data_cache_output_window_index_s, data_cache_input_window_row_index_s : integer range 0 to 255;
signal data_cache_enable_s, data_cache_read_write_s, dma_enable_s,dma_read_write_s, filter_cache_enable_s, alu_enable_s : std_logic;
signal filter_cache_index_s : integer range 0 to 4;
signal dma_increment_s :  integer range 0 to 5;
signal window_s, filter_s : window_t;
begin

    CU_Instance : CU port map(
        enable_in =>  start_in, reset_in => reset_in, clk_c => clk_c, filter_size_in => filter_size_in, stride_in => stride_in,
        data_cache_output_window_index_out =>  data_cache_output_window_index_s, data_cache_input_window_row_index_out => data_cache_input_window_row_index_s,
        data_cache_enable_out => data_cache_enable_s, data_cache_read_write_out => data_cache_read_write_s,
        --dma_read_write out = ram_read_write_out, dma_enable_out = ram_enable_out
        dma_enable_out => dma_enable_s, dma_read_write_out => dma_read_write_s,
        filter_cache_enable_out => filter_cache_enable_s,
        filter_cache_index_out => filter_cache_index_s,
        dma_increment_out => dma_increment_s,
        alu_enable_out => alu_enable_s, done_out => done_out
        );

    ram_read_write_out <= dma_read_write_s;
    ram_enable_out <= dma_enable_s;

    DMA_Instance : DMA port map(
        enable_in => dma_enable_s, reset_in => reset_in, clk_c => clk_c, increment_in => dma_increment_s, read_write_in => dma_read_write_s,
        address_out => ram_address_out
    );

    Data_Cache_Instance : DataCache port map(
      clk_c => clk_c, enable_in => data_cache_enable_s, reset_in => reset_in, stride_in => stride_in, read_write_in => data_cache_read_write_s,
      window_index_in => data_cache_output_window_index_s, window_row_index_in => data_cache_input_window_row_index_s,
      data_in => ram_data_in,
      window_out => window_s
    );

    Filter_Cache_Instance : FilterCache port map(
        enable_in => filter_cache_enable_s, reset_in => reset_in, clk_c => clk_c, filter_size_in => filter_size_in,
        index_in => filter_cache_index_s,
        data_in => ram_data_in,
        filter_out => filter_s
    );

    ALU_Instance : ALU port map(
        clk_c => clk_c, reset_in => reset_in , enable_in => alu_enable_s,
        window_in => window_s, filter_in => filter_s,
        pixel_out => ram_data_out
    );

end architecture dcnn_arch;
