library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReadAddressCounter is
    port (
        enable_in, reset_in, clk_c, increment_select_in : in std_logic;

        address_out  : out unsigned(17 downto 0)
    );
end entity ReadAddressCounter;
  
architecture arch of ReadAddressCounter is
signal count_s : unsigned(17 downto 0) := (others => '0');
signal increment : unsigned (2 downto 0) := (others => '0');
begin

    increment <= "011" when increment_select_in = '0'
            else "101"; 

    process(enable_in, reset_in, clk_c)
    begin 
        if(reset_in = '1') then
            count_s <= (others => '0');
        elsif(rising_edge(clk_c)) then 
            if(enable_in = '1') then 
                count_s <= count_s+increment;
            end if;
        end if;
    end process;

    address_out <= count_s;
    
end architecture arch;