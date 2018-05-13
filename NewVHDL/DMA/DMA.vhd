library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.DataTypes.all;

entity DMA is
    port (
        enable_in, reset_in, clk_c, read_write_in : in std_logic;
        increment_in : in integer range 0 to 5;

        address_out : out integer range 0 to 2**18
    );
end entity DMA;

architecture DMA_arch of DMA is
    component ReadAddressCounter is
        port (
            enable_in, reset_in, clk_c : in std_logic;
            increment_in : in integer range 0 to 5;
    
            address_out  : out integer range 0 to 2**18
        );
    end component ReadAddressCounter; 

    component WriteAddressCounter is
        port (
            enable_in, reset_in, clk_c : in std_logic;

            address_out  : out integer range 0 to 2**18
        );
    end component WriteAddressCounter;

    signal write_enable_s, read_enable_s : std_logic;
    signal read_address_output_s, write_address_output_s : integer range 0 to 2**18;
begin

    Read_Address_Counter  : ReadAddressCounter port map     (enable_in => read_enable_s, reset_in => reset_in,
                                                            clk_c => clk_c, increment_in => increment_in, 
                                                            address_out => read_address_output_s);

    Write_Address_Counter : WriteAddressCounter port map    (enable_in => write_enable_s , reset_in => reset_in, clk_c => clk_c,
                                                            address_out => write_address_output_s);

    write_enable_s <= '1' when enable_in = '1' and read_write_in = WRITE_OPERATION else '0';
    read_enable_s <= '1' when enable_in = '1' and read_write_in = READ_OPERATION else '0';

    address_out <= read_address_output_s when read_write_in = READ_OPERATION
              else write_address_output_s;

end architecture DMA_arch;
