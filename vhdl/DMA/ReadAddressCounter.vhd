library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReadAddressCounter is
    port (
        enable_in, reset_in, clk_c, increment_select_in, stride_in, init_done_in : in std_logic;

        address_out  : out unsigned(17 downto 0)
    );
end entity ReadAddressCounter;
  
architecture arch of ReadAddressCounter is
signal count_s, shadow_count_s : unsigned(17 downto 0);
signal increment : unsigned (8 downto 0);
signal step_counter_s : unsigned (7 downto 0);
signal count_select_s : std_logic;
signal other_count_select_s : std_logic;
begin

    --TODO what out to this son of a biatch condition
    increment <= '1' & x"00" when stride_in = '1' and init_done_in = '1' and step_counter_s = x"FF"  
            else '0' & x"03" when increment_select_in = '0'
            else '0' & x"05"; 

    shadow_count_s <= x"100" + count_s;
    other_count_select_s <= not count_select_s when init_done_in = '1' and stride_in ='1' else '0';

    process(enable_in, reset_in, clk_c)
    begin 
        if(reset_in = '1') then
            count_s <= (others => '0');
            count_select_s <= '0';
            step_counter_s <= (others => '0');
        elsif(rising_edge(clk_c)) then 
            if(enable_in = '1') then 
                count_s <= count_s + increment;
                step_counter_s <= step_counter_s + 1;
                count_select_s <= other_count_select_s;
            end if;
        end if;
    end process;

    address_out <= count_s when count_select_s = '0' else shadow_count_s;
    
end architecture arch;