library IEEE;
use IEEE.Std_Logic_1164.all;

entity CPA is
generic (n : natural :=4);
port (A: in std_logic_vector(n downto 0);
 B: in std_logic_vector(n downto 0);
 S: out std_logic_vector(n+1 downto 0));
end CPA;

architecture circuito_logico of CPA is

signal Cout: std_logic_vector(n+1 downto 0);

component fulladder is
port (A: in std_logic;
	 B: in std_logic;
	 Cin: in std_logic;
	 S: out std_logic;
	 Cout: out std_logic);
end component;

begin

Cout(0) <= '0';

cpa_1 : for j in 0 to n generate
cpa_j: 	fulladder port map( A => A(j), B => B(j), Cin => Cout(j),
			S =>S(j) , Cout => Cout(j+1));
 
end generate cpa_1;

S(n+1) <= Cout(n+1);

end circuito_logico;