library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.numeric_std.all;
--use IEEE.MATH_REAL.all;
--use IEEE.numeric_bit.all;
--use IEEE.STD_LOGIC_unsigned.all;

entity Multiplier_2_2n is
	generic(n : natural := 5 );
	 port(a : in STD_LOGIC_VECTOR((2*n-1) downto 0);
			b : in STD_LOGIC_VECTOR((2*n-1) downto 0);
		   s : out STD_LOGIC_VECTOR(2*n-1 downto 0));
end Multiplier_2_2n;

architecture structural of Multiplier_2_2n is 

component MatrixModAdd_2_2n is
   generic (etapas : integer := 8;
				n : integer := 8);
   port (GT: in STD_LOGIC_VECTOR (etapas*n-1 downto 0);
         x_rns0a: out STD_LOGIC_VECTOR ((n)-1 downto 0));	  
end component;

component rotate_l_2_2n is
	generic ( N : natural := 8;
				 j : natural := 2);
	port (sr_in : in std_logic_vector((N - 1) downto 0);
			sr_out : out std_logic_vector((N - 1) downto 0));
end component;

signal P,PP,PPP : STD_LOGIC_VECTOR(4*n*n-1 downto 0);
signal x,y, f_rns : STD_LOGIC_VECTOR(2*n-1 downto 0);

begin
 
 
 
 
generate_products_0 : for i in 0 to (2*n-1) generate	--NOT WORKING
	generate_products_1 : for j in 0 to (2*n-1) generate
		PP(j*(2*n)+i)<= (a(i) and b(j));
	end generate generate_products_1;  
end generate generate_products_0;
 
generate_products_2 : for i in 1 to (2*n) generate 
	h: rotate_l_2_2n generic map( N => 2*n, j => (i-1) ) port map( sr_in => PP((i)*2*n-1 downto (i-1)*2*n), sr_out => P((i)*2*n-1 downto (i-1)*2*n));
end generate generate_products_2;
 
F19: for i in 0 to 2*n-1 generate
	F20: for j in 0 to 2*n-1 generate
		PPP(2*n*(i)+j)<= P(i+j*2*n);
	end generate F20;
end generate F19;
 
SUM: MatrixModAdd_2_2n generic map(etapas => 2*n, n => 2*n)
						port map( GT => PPP(4*n*(n)-1 downto 0), x_rns0a => f_rns(2*n-1 downto 0));

s(2*n-1 downto 0) <= f_rns(2*n-1 downto 0);

end structural;
