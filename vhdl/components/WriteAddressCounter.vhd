library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WriteAddressCounter is
    port (
        enable_in, reset_in, clk_c,filter_size_in : in std_logic;
        address_out  : out unsigned(17 downto 0)
    );
  end entity WriteAddressCounter;


architecture write_address_counter_arch of WriteAddressCounter is
signal count_s : unsigned(17 downto 0) := (others => '0');
-- start_address = 256*256 + 25 = (65561)'10 = (10000000000011001)'2
constant start_address : unsigned (17 downto 0) := "010000000000011001";
begin
    process(enable_in, reset_in, clk_c)
    begin 
        if(reset_in = '1') then
            count_s <= start_address;
        elsif(rising_edge(clk_c)) then 
            if(enable_in = '1') then 
                count_s <= count_s + 1;
            end if;
        end if;
    end process;

    address_out <= count_s;


end architecture write_address_counter_arch;

