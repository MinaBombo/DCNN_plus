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
component RamDecoder is
    port (
        enable_in : in std_logic;
        selection_in : in integer range 0 to 262143 ;

        data_out : out std_logic_vector(262143 downto 0)
    );
end component;
-- Ram size = 256*256*2 + 5*5
type ram_t is array(262143 downto 0) of byte_t;
signal ram_memory_s : ram_t;
signal new_ram_memory_s : ram_t;
signal ram_write_selection_s : std_logic_vector(262143 downto 0);
begin
    Data_Out_Generate: for i in 0  to 4 generate
        data_out(i) <= ram_memory_s(address_in+i);
    end generate Data_Out_Generate;

    Ram_Decoder: RamDecoder port map(enable_in => '1', selection_in => address_in, data_out => ram_write_selection_s);


    Data_In_Generate: for i in 0 to 262143 generate
        new_ram_memory_s(i) <= data_in when ram_write_selection_s(i) = '1' else ram_memory_s(i);
    end generate Data_In_Generate;

    process (enable_in, clk_c, read_write_in, data_in)
    begin
        if (falling_edge(clk_c)) then
            if (enable_in = '1') then
                if (read_write_in = WRITE_OPERATION) then
                        ram_memory_s <= new_ram_memory_s;
                end if;
            end if;
        end if;
    end process;
end architecture ram_arch;