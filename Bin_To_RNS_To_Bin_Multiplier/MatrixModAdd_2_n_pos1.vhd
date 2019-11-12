library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;
--use work.componentD.all;

entity MatrixModAdd_2_n_pos1 is
    generic (etapas : integer := 8;
				 n : integer := 8);
    port (GT: in STD_LOGIC_VECTOR (etapas*n-1 downto 0);
			 x_rns0a: out STD_LOGIC_VECTOR ((n) downto 0));	     
end MatrixModAdd_2_n_pos1;
 
architecture MatrixModAdd of MatrixModAdd_2_n_pos1 is

component Comp_m_2 is
    generic(n:positive:=4);
    port (a: in STD_LOGIC_VECTOR (n-1 downto 0);
			 CI: in STD_LOGIC_VECTOR (n-4 downto 0);
			 CO: out STD_LOGIC_VECTOR (n-3 downto 0);
			 s: out STD_LOGIC);
end component;

component mod_adder_pref is
    generic(n: positive :=8;
				-- modo = 1 => 2^n+1
				modo: NATURAL := 1);	
    port (a: in STD_LOGIC_VECTOR (n-1 downto 0);
			 b: in STD_LOGIC_VECTOR (n-1 downto 0);
			 s: out STD_LOGIC_VECTOR (n-1 downto 0);
			 Cout: out STD_LOGIC);
end component;


signal So, Cco	   : STD_LOGIC_VECTOR ( n-1  downto 0);
signal s, c,c_tmp  : STD_LOGIC_VECTOR(n-1 downto 0);
signal P_tmp: STD_LOGIC_VECTOR(n downto 0);
signal not_carry  : STD_LOGIC_VECTOR(etapas-4 downto 0);
signal cc   : STD_LOGIC_VECTOR((etapas)*(n-1)+etapas-3 downto 0);

begin											  
	
-- primeiro compressor n:2 : entradas de carryin = not cout do ultimo compressor
not_carry <= not(cc((etapas)*(n-1)+ etapas-4 downto (etapas)*(n-1)));	 
		 
cp0: Comp_m_2 generic map(n=>etapas)
	port map(a=>    GT((etapas)-1 downto 0),
				CI=>   not_carry,
				CO=>   cc( (etapas)-3 downto 0),  
				s=> s(0));

	   c_tmp(0) <= cc(0 + etapas-3);

-- compressores n:2 seguintes

f1: for i in 1 to n-1 generate
	cp1: Comp_m_2 generic map(n=>etapas)
				  port map(a=>    GT((etapas)*(i)+ etapas-1 downto (etapas)*(i)),
							  CI=>   cc((etapas)*(i-1)+ etapas-4 downto (etapas)*(i-1)),
							  CO=>   cc((etapas)*(i)+ etapas-3 downto (etapas)*(i)),
							  s=> s(i));
	c_tmp(i) <= cc((etapas)*(i) + etapas-3);  
end generate f1;

--------------------------------	
------------ CSA ---------------
-- Module 2n+1 3:2 compressor --
-- output S_b, S_a            --
--------------------------------
 
 
c <= c_tmp(n-2 downto 0) & (not(c_tmp(n-1)));
So <= s;
Cco <= c;

-- Eduardo deve apagar este somador final e coloca-lo no final da serie de MACs

MAdder: mod_adder_pref
	generic map(n => n ,
					modo => 1 ) -- mod 2^n+1
   port map(a => So,
				b => Cco,
				s => P_tmp(n-1 downto 0),
				Cout => P_tmp(n));
	
x_rns0a <= P_tmp(n downto 0);
	
end MatrixModAdd;
