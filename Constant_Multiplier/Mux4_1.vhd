library IEEE;
use IEEE.std_logic_1164.all;

entity Mux4_1 is

generic(n :natural:=16);

 port(
 
     A,B,C,D : in STD_LOGIC_VECTOR(n-1 downto 0);
	 Z : out STD_LOGIC_VECTOR(n-1 downto 0);
     S0,S1: in STD_LOGIC
  );
end Mux4_1;
 
architecture bhv of Mux4_1 is
begin
process (A,B,C,D,S0,S1) is
begin
  if (S0 ='0' and S1 = '0') then
      Z <= A;
  elsif (S0 ='1' and S1 = '0') then
      Z <= B;
  elsif (S0 ='0' and S1 = '1') then
      Z <= C;
  else
      Z <= D;
  end if;
 
end process;
end bhv;
