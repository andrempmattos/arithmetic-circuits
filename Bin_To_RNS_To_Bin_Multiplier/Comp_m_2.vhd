---------------------------------------------------------------------
-- n bit compressor 
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Comp_m_2 is
	generic(n:positive:=4);
	port (a: in STD_LOGIC_VECTOR (n-1 downto 0);
			CI: in STD_LOGIC_VECTOR (n-4 downto 0);
			CO: out STD_LOGIC_VECTOR (n-3 downto 0);
			--	cout: out STD_LOGIC;
			s: out STD_LOGIC);
end Comp_m_2;

architecture Comp_m_2_arch of Comp_m_2 is

signal f :STD_LOGIC_VECTOR (n+2*(n-2)-1 downto 0);
signal CCI,CCO:STD_LOGIC_VECTOR (n-3 downto 0);

begin

b1:block

constant j:natural:=0;

begin

f(n-1 downto 0) <= a;
CCI <= '0' & CI;

f1:for i in 0 to n-3 generate 
	-- full-adder
	f(n + i*2) <= f(i*3) xor f(i*3+1) xor f(i*3+2);

	CCO(i) <= (f(i*3) and f(i*3+1)) or (f(i*3) and f(i*3+2)) or (f(i*3+1) and f(i*3+2));
	---
	f(n+I*2+1) <= CCI(i);
end generate f1;

s <= f(n+(n-3)*2);

CO <= CCO(n-3 downto 0);
--cout <= CCO(n-3);

end block b1;

end Comp_m_2_arch;

