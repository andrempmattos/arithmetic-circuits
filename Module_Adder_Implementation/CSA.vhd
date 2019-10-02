library IEEE;
use IEEE.Std_Logic_1164.all;

entity CSA is
generic (n : natural :=4);
port (A: in std_logic_vector(n downto 0);
 B: in std_logic_vector(n downto 0);
 Cin: in std_logic_vector(n downto 0);
 S: out std_logic_vector(n downto 0);
 C: out std_logic_vector(n downto 0));
end CSA;

architecture circuito_logico of CSA is

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

CSA_1 : for j in 0 to n generate
CSA_j: 	fulladder port map( A => A(j), B => B(j), Cin => Cin(j),
			S =>S(j) , Cout => Cout(j+1));
 
end generate CSA_1;

C <= Cout(n downto 0);

end circuito_logico;