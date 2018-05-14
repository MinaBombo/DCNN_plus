library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity Multiplier is
port(
    clk_c, enable_in, reset_in : in std_logic;
    window_in : in window_t;
    filter_in : in window_t;
    multiplied_window_out : out multiplication_window_t
);
end entity Multiplier;

architecture  multiplier_arch of Multiplier is
component BoothPipeline is
    port(
        clk_c, enable_in, reset_in : in std_logic;
        first_operand_in, second_operand_in : in byte_t;
        Result_out : out word_t
    );
end component;
begin

    Outer_Mulyipliers_Generator : for i in 0 to 4 generate
        Inner_Mulyipliers_Generator : for j in 0 to 4 generate
            pipeline : BoothPipeline port map (
                clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
                first_operand_in => window_in(i)(j), 
                second_operand_in => filter_in(i)(j),
                Result_out => multiplied_window_out(i)(j)
            );
        end generate Inner_Mulyipliers_Generator;
    end generate Outer_Mulyipliers_Generator;

end architecture multiplier_arch;