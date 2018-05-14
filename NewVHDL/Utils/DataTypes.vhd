library ieee;
use ieee.std_logic_1164.all;

package DataTypes is

    subtype byte_t is integer range -128 to 127;
    type window_row_t is array(4 downto 0) of byte_t; 
    type window_t is array(4 downto 0) of window_row_t; 
    type cache_row_t is array(255 downto 0) of byte_t; 
    type cache_t is array(4 downto 0) of cache_row_t;
    subtype word_t is integer range -32768 to 32767;
    type multiplication_row_t is array(4 downto 0) of word_t; 
    type multiplication_window_t is array(4 downto 0) of multiplication_row_t; 

    
    constant NULL_BYTE : byte_t := 0;
    constant NULL_WINDOW_ROW : window_row_t := (others => NULL_BYTE);
    constant NULL_WINDOW : window_t := (others => NULL_WINDOW_ROW);

    constant NULL_WORD : word_t := 0;
    constant NULL_MULTIPLIED_WINDOW_ROW : multiplication_row_t := (others => NULL_WORD);
    constant NULL_MULTIPLIED_WINDOW : multiplication_window_t := (others => NULL_MULTIPLIED_WINDOW_ROW);

    constant ONE_BYTE : byte_t := 1;
    constant ONE_WINDOW_ROW : window_row_t := (others => ONE_BYTE);
    constant ONE_WINDOW : window_t := (others => ONE_WINDOW_ROW);
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

    constant STATE_NONE : integer := 0;
    constant STATE_POPULATE_ALU : integer := 1;
    constant STATE_WRITE : integer := 2;
    constant STATE_READ : integer := 3;
    constant STATE_READ_AGAIN : integer := 4;
    constant STATE_FLUSH_ALU : integer := 5;
    constant STATE_DONE : integer := 6;
    
    constant INSTRUCTION_CONVOLVE : std_logic := '0';
    constant INSTRUCTION_POLL : std_logic := '1';
    constant NUM_PIPELINE_STAGES : integer := 8;

end package DataTypes;