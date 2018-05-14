library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity RAM is
    port (
        enable_in, clk_c, read_write_in : in std_logic;
        address_in  : in integer range 0 to 2**18;
        data_in : in byte_t;
        data_out : out window_row_t
    );
end entity RAM;

architecture ram_arch of RAM is
-- Ram size = 256*256*2 + 5*5
type ram_t is array(129069 downto 0) of byte_t;
signal ram_memory_s : ram_t;
begin
    Data_Out_Generate: for i in 0  to 4 generate
        data_out(i) <= ram_memory_s(address_in+i);
    end generate Data_Out_Generate;

    process (enable_in, clk_c, read_write_in, data_in)
    begin
        if (falling_edge(clk_c)) then
            if (enable_in = '1') then
                if (read_write_in = WRITE_OPERATION) then
                        ram_memory_s(address_in) <= data_in;
                end if;
            end if;
        end if;
    end process;
end architecture ram_arch;