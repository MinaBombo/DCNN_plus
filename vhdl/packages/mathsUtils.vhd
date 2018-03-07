library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mathsUtils is
-------------------------------------------------------------------------------------------------------
function boothMultip(x, y : std_logic_vector)return std_logic_vector;
-- Result subtype: std_logic_vector(2*x'length downto 0)
-- Result: multi-cycle approache to compute the multiplication of 2 N-bit numbers
-------------------------------------------------------------------------------------------------------
end package mathsUtils;

package body mathsUtils is
-------------------------------------------------------------------------------------------------------
function boothMultip(x, y : std_logic_vector)return std_logic_vector is
    -- TODO: optimize
    signal a, p, s : std_logic_vector(2*x'length downto 0);
    begin
        return "0"; 
end function boothMultip;
-------------------------------------------------------------------------------------------------------
end package body mathsUtils;