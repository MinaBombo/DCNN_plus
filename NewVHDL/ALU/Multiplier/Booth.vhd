library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity Booth is
port(
    
    A_in, S_in, P_in : in std_logic_vector(16 downto 0);
    A_out, S_out, P_out : out std_logic_vector(16 downto 0)
);
end entity Booth;

architecture  booth_arch of Booth is
signal P_s : std_logic_vector(16 downto 0);
begin

    P_s <=  std_logic_vector((signed(P_in)) + (signed(A_in))) when P_in(1 downto 0) = "01" else
            std_logic_vector((signed(P_in)) + (signed(S_in))) when P_in(1 downto 0) = "10" else
            P_in when P_in(1 downto 0) = "00" or P_in(1 downto 0) = "11";

    A_out <= A_in;
    S_out <= S_in;

    P_out <= P_s(16) & P_s(16 downto 1);
end architecture booth_arch;