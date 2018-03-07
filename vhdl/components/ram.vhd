library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    -- TODO: Try to make it generic and optimize it
    port(
        Clk, Rst, En, RW : in std_logic; -- RW : 0 = read, 1 = write
        DataIn  : in std_logic_vector(8-1 downto 0);
        Address : in std_logic_vector(18-1 downto 0); 

        DataOut : out std_logic_vector(40-1 downto 0)
    );
end entity ram;

architecture behaviour of ram is 

type memory is array ((2**18)-1 downto 0) of std_logic_vector(8-1 downto 0);
signal ramMemory : memory;
signal internalDataOut : std_logic_vector(40-1 downto 0);

begin
    patching : for i in 0 to 40/8 generate
        internalDataOut(i*(40/8) to i+(40/8)) <= ramMemory(to_integer(unsigned(Address)+i));
    end generate patching;
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(En = '1') then
                if(RW ='0') then
                    DataOut <= internalDataOut;
                else          
                    ramMemory(to_integer(unsigned(Address))) <= DataIn;
                end if;
            end if;
        end if;
    end process;

end behaviour;
