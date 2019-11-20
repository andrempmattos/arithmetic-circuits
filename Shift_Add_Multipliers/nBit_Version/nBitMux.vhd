library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity nBitMux is
    generic (n : natural := 16);
    port (
        InputVector_A : in STD_LOGIC_VECTOR(n-1 downto 0);
        InputVector_B : in STD_LOGIC_VECTOR(n-1 downto 0);
        OutputVector : out STD_LOGIC_VECTOR(n-1 downto 0);
        Selector: in STD_LOGIC
  );
end entity;
 
architecture Behavioral of nBitMux is

begin

    process (InputVector_A, InputVector_B, Selector) is
    begin
        
        if (Selector = '0') then
            OutputVector <= InputVector_A;
        else
            OutputVector <= InputVector_B;
        end if;
 
    end process;

end architecture;
