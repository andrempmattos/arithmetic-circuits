library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_LOGIC_arith.all;
use IEEE.std_logic_signed.all;
use work.fuctions.all;
  
entity adder_2n_mp_1 is 
	generic (n : natural :=4;
				-- modo = 0 => 2^n-1
				-- modo = 1 => 2^n+1
				modo: NATURAL := 0);
  	 port(A : in STD_LOGIC_VECTOR((n-1) downto 0);
			B : in STD_LOGIC_VECTOR((n-1) downto 0);
			S : out STD_LOGIC_VECTOR((n-1) downto 0);
			Cout: out STD_LOGIC);
end adder_2n_mp_1;
  
--}} End of automatically maintained section
  
architecture Structural of adder_2n_mp_1 is

signal p, g : STD_LOGIC_VECTOR((n) * (log2(n)+1) downto 0);
signal c  : STD_LOGIC_VECTOR((n+1) downto 0);
signal Cin, modo_b : STD_LOGIC;
  
begin
 
	 -- enter your statements here --
modo_b <= '0' when modo = 0 else '1';
  	
-- preprocessing:
f1 :for i in 0 to n-1 generate 
  p(i) <= a(i) xor b(i);
  g(i) <= a(i) and b(i);
end generate f1;

-- prefix computation:
f2: for i in 1 to log2(n) generate
   f3: for j in 0 to n-1 generate
		-- celulas cheias (executam calculo)
		i1: if (impar (j / pot2(i-1)) = 1)generate 
			p((i)*n + j) <= p((i-1)*n + j) and p((i-1)*n + pos((pot2(i-1)*(j / (pot2(i-1))))-1));
			g((i)*n + j) <= g((i-1)*n + j) or (p((i-1)*n + j) and g((i-1)*n + pos((pot2(i-1)*(j / (pot2(i-1))))-1)));
		end generate i1;

		-- celulas vazias (nao executam calculo)
		i2: if not (impar (j / pot2(i-1)) = 1) generate
			p((i)*n + j) <= p((i-1)*n + j);
			g((i)*n + j) <= g((i-1)*n + j);
		end generate i2;
	end generate f3;
end generate f2;
  
-- ultima linha (linha de incremento)
c(0) <= Cin;
  
f4: for i in 0 to n-1 generate 
   c(i+1) <= g(log2(n)*n +i) or (p(log2(n)*n +i) and Cin);
end generate f4;
  
-- postprocessing (soma)
f5: for i in 0 to n-1 generate 
   s(i) <= p(i) xor c(i);
end generate f5;
  
Cout <= p(log2(n)*n + n-1) and (modo_b);

-- modificacao de modo a implementar um somador em RNS modulo 2n+1 e 2n-1
Cin <= (p(log2(n)*n + n-1)) or (g(log2(n)*n +n-1) xor (modo_b));

end Structural;