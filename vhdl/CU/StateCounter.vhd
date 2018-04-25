library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateCounter is
    port (
        enable_in, reset_in, clk_c, stride_in : in std_logic;
        read_write_ram_out  : out std_logic
    );
  end entity StateCounter;

architecture StateCounter_arch of StateCounter is
signal count_s : unsigned (2 downto 0) := (others => '0');
signal limit_s : unsigned (2 downto 0);
begin
    limit_s <= "101" when stride_in  = '0' else "110";
    process(enable_in,reset_in,clk_c)
    begin
        if(reset_in = '1') then
            count_s <= (others => '0');
        elsif (rising_edge(clk_c)) then
            if(enable_in = '1') then
                if(count_s = limit_s) then 
                    count_s <= (others => '0');
                else count_s <= count_s+1;
                end if;
            end if;
        end if;
    end process;
    -- R/!W --> r = 1, w = 0
    read_write_ram_out <= '0' when count_s < "101" else '1'; 
    
end architecture StateCounter_arch;

