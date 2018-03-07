library ieee;
use ieee.std_logic_1164.all;

entity system is
    port( 
        Clk, Rst, Start, Inst, Size, Stride : in std_logic;  
        RAM_DataIn : in std_logic_vector(40-1 downto 0);
        
        Done, RAM_En, RAM_RW : out std_logic;
        RAM_DataOut : out std_logic_vector(8-1 downto 0);
        -- ram width = 8
        -- therefore ram length = 256*256*2 + 5*5/8 = 131072 + 4 = 131076
        -- hecnce address width = log2(131076) = 18 
        RAM_Address : out std_logic_vector(18-1 downto 0)
    );
end entity system;