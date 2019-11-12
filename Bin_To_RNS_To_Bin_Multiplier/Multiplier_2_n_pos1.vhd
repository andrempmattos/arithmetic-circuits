library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.numeric_std.all;

entity Multiplier_2_n_pos1 is
	generic(n : natural := 4 );
	 port(a : in STD_LOGIC_VECTOR(n downto 0);
			b : in STD_LOGIC_VECTOR(n downto 0);
			s : out STD_LOGIC_VECTOR(n downto 0));
end Multiplier_2_n_pos1;

architecture structural of Multiplier_2_n_pos1 is 

component MatrixModAdd_2_n_pos1 is
   generic (etapas : integer := 8;
				n : integer := 8);
    port (GT: in STD_LOGIC_VECTOR (etapas*n-1 downto 0);
			 x_rns0a: out STD_LOGIC_VECTOR ((n) downto 0));	  
end component;

component rotate_l_2_n_pos1
	generic (N : natural := 8;
				j : natural := 2);
	port (sr_in : in std_logic_vector((N) downto 0);
			sr_in1 : in std_logic_vector((N) downto 0);
			sr_out : out std_logic_vector((N - 1) downto 0));
end component;

signal PP : STD_LOGIC_VECTOR(n*n+2*n downto 0);
signal P, PPP : STD_LOGIC_VECTOR(n*n+3*n-1 downto 0);
signal PPPP : STD_LOGIC_VECTOR(n-1 downto 0);

signal x,y, f_rns : STD_LOGIC_VECTOR(n downto 0);
signal matrixcor : STD_LOGIC_VECTOR(n-1 downto 0);

begin
 
 
generate_products_0 : for i in 0 to n generate
	generate_products_1 : for j in 0 to n generate
		PP(j*(n+1)+i)<= (a(i) and b(j));
   end generate generate_products_1;  
end generate generate_products_0;
 
P(n-1 downto 0) <= PP(n-1 downto 0);
 
generate_products_2 : for i in 1 to (n) generate 
	h: rotate_l_2_n_pos1 generic map( N => 4, j => (i) ) port map( sr_in => PP((i)*(n) + (i-1) downto (i-1)*(n) + (i-1)), sr_in1 => PP((i+1)*(n)+ i downto (i)*(n)+ i), sr_out => P((i+1)*(n)-1 downto (i)*(n)));
end generate generate_products_2;
 
P((n+2)*(n)-1 downto (n+1)*(n)) <= not(PP((n+2)*(n)-1 downto (n+1)*(n)));
 
 -- CORRECTION FACTOR --
  
matrixcor <= '0' & '1' & '0' & PP(n*n+2*n);
  
P(n*n+2*n+n-1 downto n*n+2*n) <= matrixcor;
  
F19: for i in 0 to n-1 generate
	F20: for j in 0 to n+2 generate
		PPP((n+3)*(i)+j)<= P(i+j*n);
	end generate F20;
end generate F19;
 
SUM: MatrixModAdd_2_n_pos1 generic map(etapas => n+3, n => 4)
		port map( GT => PPP(n*n+3*n-1 downto 0), x_rns0a => f_rns((n) downto 0));

s((n) downto 0) <= f_rns((n) downto 0);

end structural;
