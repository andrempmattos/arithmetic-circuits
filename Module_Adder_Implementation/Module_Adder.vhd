library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.fuctions.all;

entity Module_Adder is
	generic (n : natural := 4);
	port(
		SW   : in STD_LOGIC_VECTOR(4*n+1 downto 0);
		HEX1 : out STD_LOGIC_VECTOR(6 downto 0);
		HEX0 : out STD_LOGIC_VECTOR(6 downto 0)
	);
end entity;

architecture Structural of Module_Adder is

	component CPA is
		generic (n : natural :=4);
		port (
			A: in std_logic_vector(n downto 0);
			B: in std_logic_vector(n downto 0);
			S: out std_logic_vector(n downto 0)
		);
	end component;

	component CSA is
		generic (n : natural :=4);
		port (
			A: in std_logic_vector(n downto 0);
			B: in std_logic_vector(n downto 0);
			Cin: in std_logic_vector(n downto 0);
			S: out std_logic_vector(n downto 0);
			C: out std_logic_vector(n downto 0)
		);
	end component;
	
	component mux21 is
		generic (n : natural :=4);
		port (
			A: in std_logic_vector(n downto 0);
			B: in std_logic_vector(n downto 0);
			s: in std_logic;
			F: out std_logic_vector(n+1 downto 0)
		);
	end component;

  
	component Decod7seg is
		port (
			C: in std_logic_vector(3 downto 0);
			F: out std_logic_vector(6 downto 0)
		);
	end component;
  
signal zeros : std_logic_vector(n-1 downto 0);

signal cpa1_out: std_logic_vector(n downto 0);

signal cpa2_in1: std_logic_vector(n+1 downto 0);
signal cpa2_in2: std_logic_vector(n+1 downto 0);
signal cpa2_out: std_logic_vector(n+1 downto 0);

signal mux_out: std_logic_vector(n+1 downto 0);
signal disp1_sig: std_logic_vector(n-1 downto 0);

begin

converter : block

begin

cpa1: CPA	generic map	(  n => n)
	                       port map ( A => SW(10 downto 6), B => SW(4 downto 0), S => cpa1_out);
							
csa1: CSA	generic map	(  n => n+1)
	                       port map ( A => SW(11 downto 6), B => SW(5 downto 0), Cin => SW(17 downto 12),
								  S => cpa2_in2, C => cpa2_in1);

cpa2: CPA	generic map	(  n => n+1)
	                       port map ( A => cpa2_in1, B => cpa2_in2, S => cpa2_out);
								  
mux1: mux21	generic map	(  n => n)
	                       port map ( A => cpa2_out(4 downto 0), B => cpa1_out, s => cpa2_out(5), F => mux_out);

disp1_sig <= "00" & mux_out(5 downto 4);
								  
disp1: Decod7seg port map ( C => disp1_sig, F => HEX1);
disp2: Decod7seg port map ( C => mux_out(3 downto 0), F => HEX0);

end block;

end architecture;


