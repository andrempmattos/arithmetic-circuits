library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2_1 is
generic(ep :positive:=4);

port (
 A: in STD_LOGIC_VECTOR (ep-1 downto 0);
 B: in STD_LOGIC_VECTOR (ep-1 downto 0);
 Sel: in STD_LOGIC;
 S: out STD_LOGIC_VECTOR (ep-1 downto 0)
);
end Mux2_1;

architecture mux2 of Mux2_1 is

begin

s <= A when SEL='0' else B;

end mux2;