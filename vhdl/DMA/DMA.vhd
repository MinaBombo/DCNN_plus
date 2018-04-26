library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMA is
    port (
        enable_in, reset_in, clk_c, increment_select_in, read_write_in : in std_logic;

        address_out : out unsigned(17 downto 0)
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
            enable_in, reset_in, clk_c : in std_logic;
            address_out  : out unsigned(17 downto 0)
        );
    end component WriteAddressCounter;

    signal write_enable_s, read_enable_s : std_logic;
    signal read_address_output_s, write_address_output_s : unsigned(17 downto 0);
begin

    Read_Address_Counter  : ReadAddressCounter port map     (enable_in => read_enable_s, reset_in => reset_in,
                                                            clk_c => clk_c, increment_select_in => increment_select_in, 
                                                            address_out => read_address_output_s);

    Write_Address_Counter : WriteAddressCounter port map    (enable_in => write_enable_s , reset_in => reset_in, clk_c => clk_c,
                                                            address_out => write_address_output_s);

    write_enable_s <= enable_in and not read_write_in;
    read_enable_s <= enable_in and read_write_in;

    address_out <= read_address_output_s when read_write_in = '1'
              else write_address_output_s;

end architecture DMA_arch;
