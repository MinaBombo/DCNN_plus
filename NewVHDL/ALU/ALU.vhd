library ieee;
use ieee.std_logic_1164.all;
library work;
use work.DataTypes.all;

entity ALU is
port(
    clk_c, reset_in , enable_in, instruction_in, filter_size_in : in std_logic;
    window_in,filter_in : in window_t;
    pixel_out : out byte_t
);
end entity ALU;

architecture alu_arch of ALU is
component Multiplier is
port(
    
    window_in : in window_t;
    filter_in : in window_t;
    multiplied_window_out : out window_t
);
end component;
component WindowBuffer is
port(
    clk_c, reset_in , enable_in : in std_logic;
    window_in : in window_t;
    window_out : out window_t
);
end component;
component Adder is
port(
    
    multiplied_window_in : in window_t;
    instruction_in, filter_size_in : in std_logic;
    pixel_out : out byte_t
);
end component;
signal multiplied_window_s, latched_multiplied_window_s : window_t;
begin

    Multiplier_Instance : Multiplier port map (window_in => window_in, filter_in => filter_in, multiplied_window_out => multiplied_window_s);
    Buffer_Instance : WindowBuffer port map (clk_c => clk_c, reset_in => reset_in, enable_in => enable_in, window_in => multiplied_window_s, window_out => latched_multiplied_window_s);
    Adder_Instance : Adder port map (multiplied_window_in => latched_multiplied_window_s,instruction_in => instruction_in, filter_size_in => filter_size_in, pixel_out => pixel_out);

end architecture alu_arch;