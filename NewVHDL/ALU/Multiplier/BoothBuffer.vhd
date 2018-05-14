library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity BoothBuffer is
port(
    clk_c, enable_in, reset_in : in std_logic;
    A_in, S_in, P_in : in std_logic_vector(16 downto 0);
    A_out, S_out, P_out : out std_logic_vector(16 downto 0)
);
end entity BoothBuffer;

architecture  booth_buffer_arch of BoothBuffer is
signal A_s, S_s, P_s : std_logic_vector(16 downto 0);
begin

    process (clk_c, enable_in, reset_in)
    begin
        if (reset_in = '1') then
            A_s <= (others => '0');
            S_s <= (others => '0');
            P_s <= (others => '0');
        elsif (rising_edge(clk_c)) then
            if (enable_in = '1') then
                A_s <= A_in;
                S_s <= S_in;
                P_s <= P_in;
            end if;
        end if;
    end process;

    A_out <= A_s;
    S_out <= S_s;
    P_out <= P_s;

end architecture booth_buffer_arch;