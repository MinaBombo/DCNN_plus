library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity Multiplier is
port(
    
    window_in : in window_t;
    filter_in : in window_t;
    multiplied_window_out : out multiplication_window_t
);
end entity Multiplier;

architecture  multiplier_arch of Multiplier is
begin

    Outer_Multiplication_Loop : for i in 0 to 4 generate
        Inner_Multiplication_Loop : for j in 0 to 4 generate
            multiplied_window_out(i)(j) <= window_in(i)(j)* filter_in(i)(j);
        end generate Inner_Multiplication_Loop;
    end generate Outer_Multiplication_Loop;
end architecture multiplier_arch;