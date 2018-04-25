library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMA is
    port (
        enable_in, reset_in, clk_c, filter_size_in,stride_in : in std_logic;

        address_out  : out unsigned(17 downto 0);
        enable_ram_out, read_write_ram_out, enable_data_cache_out, enable_filter_cache_out : out std_logic
    );
  end entity DMA;

architecture DMA_arch of DMA is
    component ReadAddressCounter is
        port (
            enable_in, reset_in, clk_c, increment_select_in : in std_logic;
            address_out  : out unsigned(17 downto 0)
        );
    end component ReadAddressCounter; 

    component WriteAddressCounter is
        port (
            enable_in, reset_in, clk_c,filter_size_in : in std_logic;
            address_out  : out unsigned(17 downto 0)
        );
    end component WriteAddressCounter;
    component StateCounter is
    port (
        enable_in, reset_in, clk_c,stride_in : in std_logic;
        read_write_ram_out  : out std_logic
    );
  end component StateCounter;

    signal increment_select_s,write_enable_s,read_enable_s,state_counter_enable_s : std_logic;
    signal num_filter_bytes_read_s : unsigned(3 downto 0);
    signal read_address_output_s, write_address_output_s : unsigned(17 downto 0);
begin

    Read_Address_Counter  : ReadAddressCounter port map     (enable_in => read_enable_s, reset_in => reset_in,
                                                            clk_c => clk_c, increment_select_in => increment_select_s, 
                                                            address_out => read_address_output_s );

    Write_Address_Counter : WriteAddressCounter port map    (enable_in => write_enable_s , reset_in => reset_in, 
                                                            clk_c => clk_c,filter_size_in => filter_size_in);

    State_Counter         : StateCounter port map           (enable_in => state_counter_enable_s , reset_in => reset_in, 
                                                            clk_c => clk_c,stride_in => stride_in ,read_write_ram_out => read_write_ram_out);

    enable_ram_out <= read_enable_s or write_enable_s;

    process(clk_c)
    begin
        if(rising_edge(clk_c)) then
            if(enable_in = '1' and num_filter_bytes_read_s < "101") then
                num_filter_bytes_read_s <= num_filter_bytes_read_s+1;
            end if;
        end if;
    end process;

    increment_select_s <= '0' when filter_size_in ='0' and num_filter_bytes_read_s < "011"
                     else '1';

    write_enable_s <= read_write_ram_out;
    

end architecture DMA_arch;