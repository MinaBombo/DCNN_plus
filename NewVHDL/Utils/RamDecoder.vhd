library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RamDecoder is
    port (
        enable_in : in std_logic;
        selection_in : in integer range 0 to 262143 ;

        data_out : out std_logic_vector(262143 downto 0)
    );
end RamDecoder;

architecture ram_decoder_unit_arch of RamDecoder is
begin
    Generate_Output : for i in 0 to 262143 generate
        data_out( i ) <= '1' when (enable_in = '1' and i = selection_in)
        else '0';
    end generate;
end ram_decoder_unit_arch ; -- n_bits_decoder_unit_arch



