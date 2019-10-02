-- Multiplexador 2.1

library IEEE;
use IEEE.Std_Logic_1164.all;

entity mux21 is
generic (n : natural :=4);
port (A: in std_logic_vector(n downto 0);
B: in std_logic_vector(n downto 0);
s: in std_logic;
F: out std_logic_vector(n+1 downto 0)
);
end mux21;
  
 -- ARQUITETURA ESTRUTURAL 
architecture mux_estr of mux21 is
begin
F <= '0' & A when s = '0' else
'0' & B;
end mux_estr;