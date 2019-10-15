---------------------------------------------------------------------------------------------------
--
-- Description : Makes the sum Y = 36A + 44B + 164C + 548D + 36 with s
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;   
--use work.bin_components.all;
--use work.compuRNS_def.all;
library work;
use work.fuctions.all;
--use work.rns_components.all;

entity MultiOperand_Adder is
	generic (n : natural := 12);
	 port(SW   : in STD_LOGIC_VECTOR(15 downto 0);
			LEDR : out STD_LOGIC_VECTOR(16 downto 0));
end entity;


--}} End of automatically maintained section

architecture Structural of MultiOperand_Adder is


  component CSA is
	generic (n : natural :=4);
		port (
			A: in std_logic_vector(n downto 0);
			B: in std_logic_vector(n downto 0);
			Cin: in std_logic_vector(n downto 0);
			S: out std_logic_vector(n+1 downto 0);
			C: out std_logic_vector(n+1 downto 0)
		);
	end component;
	
  component CPA is
	generic (n : natural :=4);
		port (
			A: in std_logic_vector(n downto 0);
			B: in std_logic_vector(n downto 0);
			S: out std_logic_vector(n+1 downto 0)
		);
	end component;
	
signal A1, A2, A3, A4, A5, A6, A7: std_logic_vector(n downto 0);

signal out_sig: std_logic_vector(n+5 downto 0);

signal csa1_s, csa1_c: std_logic_vector(n+1 downto 0);
signal csa2_s, csa2_c: std_logic_vector(n+1 downto 0);
signal csa3_s, csa3_c: std_logic_vector(n+2 downto 0);
signal csa4_s, csa4_c: std_logic_vector(n+3 downto 0);
signal csa5_s, csa5_c: std_logic_vector(n+4 downto 0);

signal A_in, B_in, C_in, D_in: std_logic_vector(3 downto 0);

begin

converter : block

begin

A_in <= SW(3 downto 0);
B_in <= SW(7 downto 4);
C_in <= SW(11 downto 8);
D_in <= SW(15 downto 12);

A1 <= D_in(3 downto 2) & C_in(3 downto 2) & A_in(3 downto 1) & A_in(3 downto 0) & D_in(0) & '0';
A2 <= "00" & D_in(1 downto 0) & B_in(3 downto 2) & B_in(3) & A_in(0) & B_in(2 downto 0) & D_in(0) & '0';
A3 <= "0000" & C_in(3 downto 2) & B_in(1) & B_in(3) & B_in(1 downto 0) & C_in(0) & "00";
A4 <= "0000" & C_in(1 downto 0) & C_in(1) & B_in(2) & C_in(2 downto 1) & "100";
A5 <= "0000" & D_in(3 downto 1) & B_in(0) & D_in(2 downto 0) & "00";
A6 <= "0000000" & C_in(0) & '1' & D_in(0) & D_in(0) & "00";
A7 <= "0000000" & D_in(3) & '1' & D_in(0) & D_in(0) & "00";

csa1: CSA	generic map	(  n => n)
	                       port map ( A => A1, B => A2, Cin => A3,
								  S => csa1_s, C => csa1_c);
				
csa2: CSA	generic map	(  n => n)
	                       port map ( A => A4, B => A5, Cin => A6,
								  S => csa2_s, C => csa2_c);
			
csa3: CSA	generic map	(  n => n+1)
	                       port map ( A => csa1_s, B => csa1_c, Cin => csa2_s,
								  S => csa3_s, C => csa3_c);

csa4: CSA	generic map	(  n => n+2)
	                       port map ( A => csa3_s, B => csa3_c, Cin => '0' & csa2_c,
								  S => csa4_s, C => csa4_c);

csa5: CSA	generic map	(  n => n+3)
	                       port map ( A => csa4_s, B => csa4_c, Cin => "000" & A7,
								  S => csa5_s, C => csa5_c);

cpa1: CPA	generic map (n => n+4)
								port map ( A => csa5_s, B => csa5_c,
								  S => out_sig);

LEDR <= out_sig(16 downto 0);
								  
end block;

end architecture;


