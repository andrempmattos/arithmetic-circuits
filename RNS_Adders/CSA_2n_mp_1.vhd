library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use work.bin_components.all;

entity CSA_2n_mp_1 is
	generic (n : natural;
				-- modo = 0 => 2^n-1
				-- modo = 1 => 2^n+1
				modo: NATURAL);
  	 port(I0 : in STD_LOGIC_VECTOR((n-1) downto 0);
			I1 : in STD_LOGIC_VECTOR((n-1) downto 0);
			I2 : in STD_LOGIC_VECTOR((n-1) downto 0);
			S : out STD_LOGIC_VECTOR((n-1) downto 0);
			C : out STD_LOGIC_VECTOR((n-1) downto 0));
end CSA_2n_mp_1;
  
--}} End of automatically maintained section
  
architecture Structural of CSA_2n_mp_1 is
 component fulladder is
 	 port(A : in STD_LOGIC;
			B : in STD_LOGIC;
			Cin : in STD_LOGIC;
			S : out STD_LOGIC;
			Cout : out STD_LOGIC);
 end component;
 
signal c_intermed : STD_LOGIC_VECTOR(n downto 0);
signal modo_b 	: STD_LOGIC;

begin

-- enter your statements here -- 
modo_b <= '0' when modo = 0 else '1';
  		
ciclo : for i in 0 to (n-1) generate
	add : fulladder port map( 
		A => I0(i), 
  		B => I1(i), 
  		Cin => I2(i), 
  		S => S(i), 
  		Cout => c_intermed(i+1));
end generate;
C((n-1) downto 1) <= c_intermed((n-1) downto 1);
--C(0) <= c_intermed(n) xor modo_b;
C(0) <= c_intermed(n) when modo = 0 else not(c_intermed(n));
  		
end Structural;