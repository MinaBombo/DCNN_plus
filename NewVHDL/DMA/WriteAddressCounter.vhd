library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.DataTypes.all;

entity WriteAddressCounter is
    port (
        enable_in, reset_in, clk_c : in std_logic;
        
        address_out  : out integer range 0 to 2**18
    );
end entity WriteAddressCounter;


architecture write_address_counter_arch of WriteAddressCounter is
signal count_s : integer range 0 to 2**18;
begin
    process(enable_in, reset_in, clk_c)
    begin 
        if(reset_in = '1') then
            count_s <= WRITE_START_ADDRESS;
        elsif(rising_edge(clk_c)) then 
            if(enable_in = '1') then 
                count_s <= count_s + 1;
            end if;
        end if;
    end process;

    address_out <= count_s;


end architecture write_address_counter_arch;

