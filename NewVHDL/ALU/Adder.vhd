library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity Adder is
port(
    
    multiplied_window_in : in window_t;
    pixel_out : out byte_t
);
end entity Adder;

architecture adder_arch of Adder is
signal pixel_s : integer;
begin

    pixel_s <= multiplied_window_in(0)(0) +
               multiplied_window_in(0)(1) +
               multiplied_window_in(0)(2) +
               multiplied_window_in(0)(3) +
               multiplied_window_in(0)(4) +
               multiplied_window_in(1)(0) +
               multiplied_window_in(1)(1) +
               multiplied_window_in(1)(2) +
               multiplied_window_in(1)(3) +
               multiplied_window_in(1)(4) +
               multiplied_window_in(2)(0) +
               multiplied_window_in(2)(1) +
               multiplied_window_in(2)(2) +
               multiplied_window_in(2)(3) +
               multiplied_window_in(2)(4) +
               multiplied_window_in(3)(0) +
               multiplied_window_in(3)(1) +
               multiplied_window_in(3)(2) +
               multiplied_window_in(3)(3) +
               multiplied_window_in(3)(4) +
               multiplied_window_in(4)(0) +
               multiplied_window_in(4)(1) +
               multiplied_window_in(4)(2) +
               multiplied_window_in(4)(3) +
               multiplied_window_in(4)(4);

    pixel_out <= pixel_s rem 256;


end architecture adder_arch;