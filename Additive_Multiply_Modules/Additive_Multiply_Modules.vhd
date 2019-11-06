library IEEE;
use IEEE.STD_LOGIC_1164.all;   
--use work.bin_components.all;
--use work.compuRNS_def.all;
library work;
use work.fuctions.all;
--use work.rns_components.all;

entity Additive_Multiply_Modules is
	generic (n : natural := 15);
	port(
		SW   : in STD_LOGIC_VECTOR(n downto 0);
		LEDR : out STD_LOGIC_VECTOR(n downto 0)
	);
end entity;

architecture Structural of Additive_Multiply_Modules is

  	component fulladder is
		port(
			A : in STD_LOGIC;
			B : in STD_LOGIC;
			Cin : in STD_LOGIC;
			S : out STD_LOGIC;
			Cout : out STD_LOGIC
		);
	end component;
	
	
signal S_out: std_logic_vector(5 downto 0);

signal A_sig, C_sig, E_sig: std_logic_vector(2 downto 0);
signal B_sig, D_sig, F_sig: std_logic_vector(1 downto 0);
signal G_sig: std_logic;

signal vect1_1, vect1_2, vect1_3: std_logic_vector(3 downto 0);
signal vect1_4, vect1_5, vect1_6: std_logic_vector(1 downto 0);

signal FA1_S, FA1_C, FA2_S, FA2_C, FA3_S, FA3_C, FA4_S, FA4_C, FA5_S, FA5_C, FA6_S, FA6_C: std_logic;
signal FA7_S, FA7_C, FA8_S, FA8_C, FA9_S, FA9_C, FA10_S, FA10_C, FA11_S, FA11_C, FA12_S, FA12_C: std_logic;

begin

converter : block

begin

A_sig <= SW(15 downto 13);
B_sig <= SW(12 downto 11);
C_sig <= SW(10 downto 8);
D_sig <= SW(7 downto 6);
E_sig <= SW(5 downto 3);
F_sig <= SW(2 downto 1);
G_sig <= SW(0);

vect1_1 <= (A_sig(2) AND B_sig(1)) & (A_sig(2) AND B_sig(0)) & (A_sig(1) AND B_sig(0)) & (A_sig(0) AND B_sig(0));
vect1_2 <= (C_sig(2) AND D_sig(1)) & (A_sig(1) AND B_sig(1)) & (A_sig(0) AND B_sig(1)) & (C_sig(0) AND D_sig(0));
vect1_3 <= E_sig(2) & (C_sig(2) AND D_sig(0)) & (C_sig(1) AND D_sig(0)) & G_sig;
vect1_4 <= (C_sig(1) AND D_sig(1)) & (C_sig(0) AND D_sig(1));
vect1_5 <= E_sig(1) & E_sig(0);
vect1_6 <= F_sig(1) & F_sig(0);


FA1: fulladder port map(A=> vect1_1(0), B=> vect1_2(0), Cin=> vect1_3(0), S=> FA1_S, Cout=> FA1_C);
FA2: fulladder port map(A=> vect1_1(1), B=> vect1_2(1), Cin=> vect1_3(1), S=> FA2_S, Cout=> FA2_C);
FA3: fulladder port map(A=> vect1_1(2), B=> vect1_2(2), Cin=> vect1_3(2), S=> FA3_S, Cout=> FA3_C);
FA4: fulladder port map(A=> vect1_1(3), B=> vect1_2(3), Cin=> vect1_3(3), S=> FA4_S, Cout=> FA4_C);
FA5: fulladder port map(A=> vect1_4(0), B=> vect1_5(0), Cin=> vect1_6(0), S=> FA5_S, Cout=> FA5_C);
FA6: fulladder port map(A=> vect1_4(1), B=> vect1_5(1), Cin=> vect1_6(1), S=> FA6_S, Cout=> FA6_C);

LEDR(0) <= FA4_S;

FA7: fulladder port map(A=> FA1_S, B=> FA2_C, Cin=> FA5_C, S=> FA7_S, Cout=> FA7_C);
FA8: fulladder port map(A=> FA2_S, B=> FA3_C, Cin=> FA6_C, S=> FA8_S, Cout=> FA8_C);
FA9: fulladder port map(A=> FA3_S, B=> FA6_S, Cin=> FA4_C, S=> FA9_S, Cout=> FA9_C);

LEDR(1) <= FA9_S;

FA10: fulladder port map(A=> FA5_S, B=> FA8_S, Cin=> FA9_C, S=> FA10_S, Cout=> FA10_C);

LEDR(2) <= FA10_S;

FA11: fulladder port map(A=> FA7_S, B=> FA8_C, Cin=> FA10_C, S=> FA11_S, Cout=> FA11_C);

LEDR(3) <= FA11_S;

FA12: fulladder port map(A=> FA1_C, B=> FA7_C, Cin=> FA11_C, S=> FA12_S, Cout=> FA12_C);

LEDR(4) <= FA12_S;
LEDR(5) <= FA12_C;
								  
end block;

end architecture;


