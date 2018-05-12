library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nBitsDecoder is
    generic (
        n : integer;
        selection_range : integer
    );
    port (
        enable_in : in std_logic;
        selection_in : in integer range 0 to selection_range ;

        data_out : out std_logic_vector((2**n)-1 downto 0)
    );
end nBitsDecoder;

architecture n_bits_decoder_unit_arch of nBitsDecoder is
begin
    Generate_Output : for i in 0 to (2**n)-1 generate
        data_out( i ) <= '1' when (enable_in = '1' and i =selection_in)
        else '0';
    end generate;
end n_bits_decoder_unit_arch ; -- n_bits_decoder_unit_arch



