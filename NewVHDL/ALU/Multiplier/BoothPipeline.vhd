library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.DataTypes.all;

entity BoothPipeline is
port(
    clk_c, enable_in, reset_in : in std_logic;
    first_operand_in, second_operand_in : in byte_t;
    Result_out : out word_t
);
end entity BoothPipeline;

architecture  booth_pipeline_arch of BoothPipeline is
component Booth is
port(
    
    A_in, S_in, P_in : in std_logic_vector(16 downto 0);
    A_out, S_out, P_out : out std_logic_vector(16 downto 0)
);
end component;

component BoothBuffer is
port(
    clk_c, enable_in, reset_in : in std_logic;
    A_in, S_in, P_in : in std_logic_vector(16 downto 0);
    A_out, S_out, P_out : out std_logic_vector(16 downto 0)
);
end component;
signal A1_s, S1_s, P1_s : std_logic_vector(16 downto 0);
signal A2_s, S2_s, P2_s : std_logic_vector(16 downto 0);
signal A3_s, S3_s, P3_s : std_logic_vector(16 downto 0);
signal A4_s, S4_s, P4_s : std_logic_vector(16 downto 0);
signal A5_s, S5_s, P5_s : std_logic_vector(16 downto 0);
signal A6_s, S6_s, P6_s : std_logic_vector(16 downto 0);
signal A7_s, S7_s, P7_s : std_logic_vector(16 downto 0);
signal A8_s, S8_s, P8_s : std_logic_vector(16 downto 0);
signal A9_s, S9_s, P9_s : std_logic_vector(16 downto 0);

signal AB1_s, SB1_s, PB1_s : std_logic_vector(16 downto 0);
signal AB2_s, SB2_s, PB2_s : std_logic_vector(16 downto 0);
signal AB3_s, SB3_s, PB3_s : std_logic_vector(16 downto 0);
signal AB4_s, SB4_s, PB4_s : std_logic_vector(16 downto 0);
signal AB5_s, SB5_s, PB5_s : std_logic_vector(16 downto 0);
signal AB6_s, SB6_s, PB6_s : std_logic_vector(16 downto 0);
signal AB7_s, SB7_s, PB7_s : std_logic_vector(16 downto 0);
signal AB8_s, SB8_s, PB8_s : std_logic_vector(16 downto 0);
begin


    A1_s <= std_logic_vector(to_signed(first_operand_in,8)) & '0' & x"00";
    S1_s <= std_logic_vector(-to_signed(first_operand_in,8)) & '0' & x"00";
    P1_s <= x"00" & std_logic_vector(to_signed(second_operand_in,8)) & '0';

    Booth1 : Booth port map (
        A_in => A1_s, S_in => S1_s, P_in => P1_s,
        A_out => AB1_s, S_out => SB1_s, P_out => PB1_s
    );

    Booth_Buffer1 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB1_s, S_in => SB1_s, P_in => PB1_s,
        A_out => A2_s, S_out => S2_s, P_out => P2_s
    );

    Booth2 : Booth port map (
        A_in => A2_s, S_in => S2_s, P_in => P2_s,
        A_out => AB2_s, S_out => SB2_s, P_out => PB2_s
    );

    Booth_Buffer2 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB2_s, S_in => SB2_s, P_in => PB2_s,
        A_out => A3_s, S_out => S3_s, P_out => P3_s
    );

    Booth3 : Booth port map (
        A_in => A3_s, S_in => S3_s, P_in => P3_s,
        A_out => AB3_s, S_out => SB3_s, P_out => PB3_s
    );

    Booth_Buffer3 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB3_s, S_in => SB3_s, P_in => PB3_s,
        A_out => A4_s, S_out => S4_s, P_out => P4_s
    );

    Booth4 : Booth port map (
        A_in => A4_s, S_in => S4_s, P_in => P4_s,
        A_out => AB4_s, S_out => SB4_s, P_out => PB4_s
    );

    Booth_Buffer4 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB4_s, S_in => SB4_s, P_in => PB4_s,
        A_out => A5_s, S_out => S5_s, P_out => P5_s
    );

    Booth5 : Booth port map (
        A_in => A5_s, S_in => S5_s, P_in => P5_s,
        A_out => AB5_s, S_out => SB5_s, P_out => PB5_s
    );

    Booth_Buffer5 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB5_s, S_in => SB5_s, P_in => PB5_s,
        A_out => A6_s, S_out => S6_s, P_out => P6_s
    );

    Booth6 : Booth port map (
        A_in => A6_s, S_in => S6_s, P_in => P6_s,
        A_out => AB6_s, S_out => SB6_s, P_out => PB6_s
    );

    Booth_Buffer6 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB6_s, S_in => SB6_s, P_in => PB6_s,
        A_out => A7_s, S_out => S7_s, P_out => P7_s
    );

    Booth7 : Booth port map (
        A_in => A7_s, S_in => S7_s, P_in => P7_s,
        A_out => AB7_s, S_out => SB7_s, P_out => PB7_s
    );

    Booth_Buffer7 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB7_s, S_in => SB7_s, P_in => PB7_s,
        A_out => A8_s, S_out => S8_s, P_out => P8_s
    );

    Booth8 : Booth port map (
        A_in => A8_s, S_in => S8_s, P_in => P8_s,
        A_out => AB8_s, S_out => SB8_s, P_out => PB8_s
    );

    Booth_Buffer8 : BoothBuffer port map (
        clk_c => clk_c, enable_in => enable_in, reset_in => reset_in,
        A_in => AB8_s, S_in => SB8_s, P_in => PB8_s,
        A_out => A9_s, S_out => S9_s, P_out => P9_s
    );

    Result_out <= to_integer(signed(P9_s(16 downto 1)));

end architecture booth_pipeline_arch;