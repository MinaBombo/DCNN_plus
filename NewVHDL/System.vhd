library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity System is
port(
    clk_c, reset_in, start_in, filter_size_in, stride_in, instruction_in : in std_logic;
    done_out : out std_logic
);
end entity System;


architecture system_arch of System is
component DCNN is
    port(
        clk_c, reset_in, start_in,filter_size_in,stride_in, instruction_in : in std_logic;
        ram_data_in : in window_row_t;
        done_out, ram_enable_out, ram_read_write_out : out std_logic;
        ram_address_out : out integer range 0 to 2**18;
        ram_data_out : out byte_t
    );
end component;

component RAM is
    port (
        enable_in, clk_c, read_write_in : in std_logic;
        address_in  : in integer range 0 to 2**18;
        data_in : in byte_t;
        data_out : out window_row_t
    );
end component;
signal ram_output_s : window_row_t;
signal ram_enable_s , ram_read_write_s : std_logic;
signal ram_address_s : integer range 0 to 2**18;
signal ram_input_s : byte_t;
begin
    
    DCNN_Instance : DCNN port map(
        clk_c => clk_c, reset_in => reset_in, start_in => start_in ,filter_size_in => filter_size_in, stride_in => stride_in,instruction_in => instruction_in,
        ram_data_in => ram_output_s,
        done_out => done_out, ram_enable_out => ram_enable_s, ram_read_write_out => ram_read_write_s,
        ram_address_out => ram_address_s, ram_data_out => ram_input_s
    );

    Ram_Instance : RAM port map(
        enable_in => ram_enable_s, clk_c => clk_c, read_write_in => ram_read_write_s,
        address_in => ram_address_s,data_in => ram_input_s,data_out => ram_output_s
    );

end system_arch ; -- system_arch
