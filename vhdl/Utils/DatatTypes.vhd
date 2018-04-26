library ieee;
use ieee.std_logic_1164.all;

package DataTypes is

    type byte_t is array (7 downto 0) of std_logic;
    type window_row_t is array(4 downto 0) of byte_t; 
    type window_t is array(4 downto 0) of window_row_t; 
    
    constant NULL_BYTE : byte_t := (others => '0');
    constant NULL_WINDOW_ROW : window_row_t := (others => NULL_BYTE);
    constant NULL_WINDOW : window_t := (others => NULL_WINDOW_ROW);
end package DataTypes;