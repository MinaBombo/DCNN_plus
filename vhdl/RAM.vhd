library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity RAM is
    port (
        enable_in, clk_c, read_write_in : in std_logic;
        address_in  : in unsigned(17 downto 0);
        data_in : in byte_t;
        data_out : out window_row_t
    );
end entity RAM;

architecture arch of RAM is
-- Ram size = 256*256*2 + 5*5
type ram_t is array(262143 downto 0) of byte_t;
signal ram_memory_s : ram_t;
begin
    process (enable_in, clk_c, read_write_in)
    begin
        if (rising_edge(clk_c)) then
            if (enable_in = '1') then
                if (read_write_in = '1') then
                    data_out(0) <= ram_memory_s(to_integer(address_in));
                    data_out(1) <= ram_memory_s(to_integer(address_in+1));
                    data_out(2) <= ram_memory_s(to_integer(address_in+2));
                    data_out(3) <= ram_memory_s(to_integer(address_in+3));
                    data_out(4) <= ram_memory_s(to_integer(address_in+4));
                else 
                    ram_memory_s(to_integer(address_in)) <= data_in;
                end if;
            end if;
        end if;
    end process;
end architecture arch;