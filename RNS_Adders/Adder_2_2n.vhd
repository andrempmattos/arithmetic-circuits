 library IEEE;
 use IEEE.STD_LOGIC_1164.all;
 use IEEE.std_LOGIC_arith.all;
 use IEEE.std_logic_signed.all;
 
entity Adder_2_2n is
	generic(n : natural :=4);
	 port(a : in STD_LOGIC_VECTOR((2*n-1) downto 0);
			b : in STD_LOGIC_VECTOR((2*n-1) downto 0);
			s : out STD_LOGIC_VECTOR((2*n-1) downto 0));
end Adder_2_2n;

architecture structural of Adder_2_2n is 

component fulladder is
	 port(A : in STD_LOGIC;
		   B : in STD_LOGIC;
		   Cin : in STD_LOGIC; --carry de entrada
		   S : out STD_LOGIC;
		   Cout : out STD_LOGIC);	--carry de saida
end component;

signal cpa_cout : STD_LOGIC_VECTOR(2*n downto 0);
signal zeros : STD_LOGIC_VECTOR(2*n downto 0);
signal ones : STD_LOGIC_VECTOR(2*n downto 0);

begin 
	 -- enter your statements here --

zeros <= (others=>'0');
ones <= (others=>'1');

cpa_cout(0) <= '0';

cpa_1 : for j in 0 to 2*n-1 generate
	cpa_1:	fulladder port map( A => a(j), B => b(j), Cin =>cpa_cout(j) , S =>s(j) , Cout =>cpa_cout(j+1) );
end generate cpa_1;

end structural;
