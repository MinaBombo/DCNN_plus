library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.DataTypes.all;

entity ReadAddressCounter is
    port (
        enable_in, reset_in, clk_c : in std_logic;
        increment_in : in integer range 0 to 5;

        address_out  : out integer range 0 to 2**18
    );
end entity ReadAddressCounter;
  
architecture arch of ReadAddressCounter is
signal count_s : integer range 0 to 2**18;
begin


    process(enable_in, reset_in, clk_c, increment_in)
    begin 
        if(reset_in = '1') then
            count_s <= READ_START_ADDRESS;
        elsif(rising_edge(clk_c)) then 
            if(enable_in = '1') then 
                count_s <= count_s + increment_in;
            end if;
        end if;
    end process;

    address_out <= count_s;
    
end architecture arch;