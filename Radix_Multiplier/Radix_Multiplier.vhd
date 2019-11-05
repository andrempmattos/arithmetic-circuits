library IEEE;
use IEEE.STD_LOGIC_1164.all;   
library work;
use work.fuctions.all;

entity Radix_Multiplier is
	generic (n : natural := 15);
	 port(
	 	SW   : in STD_LOGIC_VECTOR(n downto 0);
		LEDR : out STD_LOGIC_VECTOR(n downto 0)
	);
end entity;


architecture Structural of Radix_Multiplier is


  	component Mux4_1 is
		generic(n :natural:=15);
		port(
			A,B,C,D: in STD_LOGIC_VECTOR(n downto 0);
			Z: out STD_LOGIC_VECTOR(n downto 0);
			S0,S1: in STD_LOGIC
		);
	end component;
	

	component CPA_trunc is
		generic (n : natural :=4);
		port (
			A: in std_logic_vector(n downto 0);
			B: in std_logic_vector(n downto 0);
			S: out std_logic_vector(n downto 0)
		);
	end component;

	
	component CSA_trunc is
		generic (n : natural :=4);
		port (
			A: in std_logic_vector(n downto 0);
			B: in std_logic_vector(n downto 0);
			Cin: in std_logic_vector(n downto 0);
		 	S: out std_logic_vector(n downto 0);
		 	C: out std_logic_vector(n downto 0)
		);
	end component;


signal A_sig0, B_sig: std_logic_vector(7 downto 0);

signal zeros, mux1_sig, mux2_sig, mux2_sig2, mux3_sig, mux3_sig2, mux4_sig, mux4_sig2, A_sig, A_2, A_3, CSA2_s, CSA2_c, CSA3_s, CSA3_c, CSA4_s, CSA4_c: std_logic_vector(15 downto 0);

begin

converter : block

begin

zeros <= "0000000000000000";

A_sig0 <= SW(7 downto 0);
B_sig <= SW(15 downto 8);

A_sig <= "00000000" & A_sig0;

A_2 <= "0000000" & A_sig(7 downto 0) & '0';

CPA1: CPA_trunc generic map(n => n) port map(A=> A_sig, B=> A_2, S=> A_3);

mux1:	Mux4_1 generic map(n => n) port map(A => zeros, B=> A_sig, C=> A_2, D=> A_3, Z=> mux1_sig, S0=> B_sig(0), S1=> B_sig(1));

mux2:	Mux4_1 generic map(n => n) port map(A => zeros, B=> A_sig, C=> A_2, D=> A_3, Z=> mux2_sig, S0=> B_sig(2), S1=> B_sig(3));
mux2_sig2 <= mux2_sig(13 downto 0) & "00";

mux3:	Mux4_1 generic map(n => n) port map(A => zeros, B=> A_sig, C=> A_2, D=> A_3, Z=> mux3_sig, S0=> B_sig(4), S1=> B_sig(5));
mux3_sig2 <= mux3_sig(11 downto 0) & "0000";

mux4:	Mux4_1 generic map(n => n) port map(A => zeros, B=> A_sig, C=> A_2, D=> A_3, Z=> mux4_sig, S0=> B_sig(6), S1=> B_sig(7));
mux4_sig2 <= mux4_sig(9 downto 0) & "000000";

CSA2: CSA_trunc generic map(n => n) port map(A=> mux1_sig, B=> mux2_sig, Cin=> mux3_sig, S=> CSA2_s, C=> CSA2_c);
CSA3: CSA_trunc generic map(n => n) port map(A=> CSA2_s, B=> CSA2_c, Cin=> mux4_sig, S=> CSA3_s, C=> CSA3_c);

CPA2: CPA_trunc generic map(n => n) port map(A=> CSA3_s, B=> CSA3_c, S=> LEDR);
								  
end block;

end architecture;


