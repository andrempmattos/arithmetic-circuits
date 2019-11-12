---------------------------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : DSP
-- Author      : Ricardo Chaves
-- Company     : IST/INESC-ID
--
---------------------------------------------------------------------------------------------------
--
-- File        : mod_adder.vhd
-- Generated   : Dec 2001
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
---------------------------------------------------------------------------------------------------
--
-- Description : n bit's residual adder mod 2^n+1
-- (Architecture implemented with a Slansky structure)
--
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  
use work.fuctions.all;  
use IEEE.std_LOGIC_arith.all;
use IEEE.std_logic_signed.all;

entity mod_adder_pref_2_2n is
    generic(n: positive :=8;
				-- modo = 1 => 2^n+1
				modo: NATURAL := 0);	
    port (a: in STD_LOGIC_VECTOR (n-1 downto 0);
			 b: in STD_LOGIC_VECTOR (n-1 downto 0);
			 s: out STD_LOGIC_VECTOR (n-1 downto 0);
			 Cout: out STD_LOGIC);
end mod_adder_pref_2_2n;

architecture mod_adder_pref_arch of mod_adder_pref_2_2n is
--constant modo_b : STD_LOGIC := '0'; 
-- modo_b = 1 => 2^n+1

signal p, g : STD_LOGIC_VECTOR((n) * (log2(n)+1) downto 0);
signal c  : STD_LOGIC_VECTOR((n+1) downto 0);
signal Cin , modo_b : STD_LOGIC; --, modo_b

begin			  
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

-- modificacao de modo a implementar um somador em RNS modulo 2n+1 e 2n-1
Cout <= p(log2(n)*n + n-1);

-- modificacao de modo a implementar um somador em RNS modulo 2n+1 e 2n-1
Cin <= '0';

end mod_adder_pref_arch;
