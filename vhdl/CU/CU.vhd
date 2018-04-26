library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
    port (
        enable_in, reset_in, clk_c, filter_size_in, stride_in : in std_logic;
        read_write_ram_out, increment_out, enable_dma_out, enable_ram_out, filter_cache_enable_out, data_cache_enable_out, alu_enable_out : out std_logic
    );
  end entity CU;
  
architecture arch of CU is
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
signal filter_done_s, init_done_s, state_read_write_ram_s : std_logic;
begin

    Filter_Counter  : FilterCounter port map (enable_in => enable_in, reset_in => reset_in, clk_c => clk_c, filter_size_in => filter_size_in,
                                             done_out => filter_done_s);
    Init_Counter    : InitCounter port map   (enable_in => filter_done_s, reset_in => reset_in, clk_c => clk_c,
                                             done_out => init_done_s);
    State_Counter   : StateCounter port map  (enable_in => init_done_s, reset_in => reset_in, clk_c => clk_c, stride_in => stride_in,
                                             read_write_ram_out => state_read_write_ram_s);

    read_write_ram_out <= state_read_write_ram_s when filter_done_s = '1' and init_done_s = '1'
                     else '1';
    increment_out <= '0' when filter_size_in ='0' and filter_done_s = '0'
                else '1';
    enable_dma_out <= enable_in;
    enable_ram_out <= enable_in;
    filter_cache_enable_out <= not filter_done_s;
    data_cache_enable_out <= state_read_write_ram_s when filter_done_s = '1' and init_done_s = '1'
                        else '1'                    when filter_done_s = '1' and init_done_s = '0'
                        else '0';
    alu_enable_out <= '0'; -- TODO Check this after adding the ALU
    
end architecture arch;