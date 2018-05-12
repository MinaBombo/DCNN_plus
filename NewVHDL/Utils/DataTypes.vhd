library ieee;
use ieee.std_logic_1164.all;

package DataTypes is

    subtype byte_t is std_logic_vector(7 downto 0);
    type window_row_t is array(4 downto 0) of byte_t; 
    type window_t is array(4 downto 0) of window_row_t; 
    type cache_row_t is array(255 downto 0) of byte_t; 
    type cache_t is array(4 downto 0) of cache_row_t;

    
    constant NULL_BYTE : byte_t := (others => '0');
    constant NULL_WINDOW_ROW : window_row_t := (others => NULL_BYTE);
    constant NULL_WINDOW : window_t := (others => NULL_WINDOW_ROW);
    --From the point of view of whatever module it is in
    -- Read means that the module will output data
    -- Write means that the module will input data 
    constant WRITE_OPERATION : std_logic := '0';
    constant READ_OPERATION : std_logic := '1';
    constant STRIDE_ONE : std_logic := '0';
    constant STRIDE_TWO : std_logic := '1';

end package DataTypes;