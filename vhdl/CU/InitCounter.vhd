library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InitCounter is
    port (
        enable_in, reset_in, clk_c, filter_size_in : in std_logic;
        done_out : out std_logic
    );
end entity InitCounter;
  
architecture arch of InitCounter is
signal count_s : unsigned(7 downto 0);
signal done_s : std_logic;
begin

    process(enable_in, reset_in, clk_c, done_s)
    begin
        if(reset_in = '1') then
            count_s <= (others => '0');
        elsif(rising_edge(clk_c)) then
            if(enable_in = '1' and done_s = '0') then
                count_s <= count_s + 1;
            end if;
        end if;
    end process;

    done_s <= '1' when count_s = 255
         else '0';

    done_out <= done_s;
    
end architecture arch;