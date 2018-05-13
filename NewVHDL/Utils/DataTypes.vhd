library ieee;
use ieee.std_logic_1164.all;

package DataTypes is

    subtype byte_t is integer range 0 to 255;
    type window_row_t is array(4 downto 0) of byte_t; 
    type window_t is array(4 downto 0) of window_row_t; 
    type cache_row_t is array(255 downto 0) of byte_t; 
    type cache_t is array(4 downto 0) of cache_row_t;

    
    constant NULL_BYTE : byte_t := 0;
    constant NULL_WINDOW_ROW : window_row_t := (others => NULL_BYTE);
    constant NULL_WINDOW : window_t := (others => NULL_WINDOW_ROW);
    --From the point of view of whatever module it is in
    -- Read means that the module will output data
    -- Write means that the module will input data 
    constant WRITE_OPERATION : std_logic := '0';
    constant READ_OPERATION : std_logic := '1';
    constant STRIDE_ONE : std_logic := '0';
    constant STRIDE_TWO : std_logic := '1';
    constant FILTER_SIZE_FIVE : std_logic := '1';
    constant FILTER_SIZE_THREE : std_logic := '0';
    -- start_address = 256*256 + 25 = (65561)'10 = (10000000000011001)'2
    constant WRITE_START_ADDRESS : integer := 65561;
    constant READ_START_ADDRESS : integer := 0;

    constant SHOULD_INCREMENT : std_logic := '1';
    constant SHOULD_NOT_INCREMENT : std_logic := '0';
    constant SELECT_NORMAL_ADDRESS : std_logic := '1';
    constant SELECT_SHADOW_ADDRESS : std_logic := '0';

    constant INCREMENT_THREE : std_logic := '0';
    constant INCREMENT_FIVE : std_logic := '1';

    constant STATE_NONE : integer := 0;
    constant STATE_WRITE : integer := 1;
    constant STATE_READ : integer := 2;
    constant STATE_READ_AGAIN : integer := 3;
    constant STATE_DONE : integer := 4;

end package DataTypes;