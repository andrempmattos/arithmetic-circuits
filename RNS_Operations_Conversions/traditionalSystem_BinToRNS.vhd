---------------------------------------------------------------------------------------------------
--
-- Title       : RNSsystem Compact RNS - extended Traditional
-- Design      : RNS systems
-- Author      : 
-- Company     : SIPS INESC-id
--
---------------------------------------------------------------------------------------------------
--
-- File        : bin_adderTree.vhd
-- Generated   : Wed Oct  8 13:57:33 2012
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {CSA_2n_mp_1} architecture {Structural}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;   
--use work.bin_components.all;
--use work.compuRNS_def.all;
library work;
use work.fuctions.all;
--use work.rns_components.all;

entity traditionalSystem_BinToRNS is
	generic (n : natural := 4);
	 port(SW   : in STD_LOGIC_VECTOR(4*n-1 downto 0);
			LEDR : out STD_LOGIC_VECTOR(4*n downto 0));
end traditionalSystem_BinToRNS;

--}} End of automatically maintained section

architecture Structural of traditionalSystem_BinToRNS is
  component CSA_2n_mp_1 is
  	generic (n : natural;
				-- modo = 0 => 2^n-1
				-- modo = 1 => 2^n+1
				modo: NATURAL);
  	 port(I0 : in STD_LOGIC_VECTOR((n-1) downto 0);
			I1 : in STD_LOGIC_VECTOR((n-1) downto 0);
			I2 : in STD_LOGIC_VECTOR((n-1) downto 0);
			S : out STD_LOGIC_VECTOR((n-1) downto 0);
			C : out STD_LOGIC_VECTOR((n-1) downto 0));
  end component;
  
  component adder_2n_mp_1 is 
  	generic (n : natural :=4;
				-- modo = 0 => 2^n-1
				-- modo = 1 => 2^n+1
				modo: NATURAL := 0);
  	 port(A : in STD_LOGIC_VECTOR((n-1) downto 0);
			B : in STD_LOGIC_VECTOR((n-1) downto 0);
			S : out STD_LOGIC_VECTOR((n-1) downto 0);
			Cout: out STD_LOGIC);
  end component;
  
signal zeros : std_logic_vector(n-1 downto 0);
signal sum0_2n_m1 , carry0_2n_m1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_m1 , carry1_2n_m1 : std_logic_vector(n-1 downto 0);

signal sum0_2n_p1 , carry0_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_p1 , carry1_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum2_2n_p1 , carry2_2n_p1 : std_logic_vector(n-1 downto 0);

signal notSW : std_logic_vector(4*n-1 downto 0);

begin
	-- enter your statements here -- 
zeros <= (others =>'0');	
notSW(4*n-1 downto 0) <= not(SW(4*n-1 downto 0));

converter : block

begin
LEDR(2*n-1 downto 0) <= SW(2*n-1 downto 0);

comp0_2n_m1: CSA_2n_mp_1	generic map	(  n => n , modo => 0)
	                       port map ( I0 => SW(n-1 downto 0), I1 => SW(2*n-1 downto n), I2 => SW(3*n-1 downto 2*n), S =>sum0_2n_m1 , C =>carry0_2n_m1); 
comp1_2n_m1: CSA_2n_mp_1	generic map	(  n => n , modo => 0)
	                       port map ( I0 => sum0_2n_m1, I1 => carry0_2n_m1, I2 => SW(4*n-1 downto 3*n), S =>sum1_2n_m1 , C =>carry1_2n_m1); 
add_2n_m1: adder_2n_mp_1	generic map	(  n => n , modo => 0)
	                       port map ( A => sum1_2n_m1, B => carry1_2n_m1, S =>LEDR(3*n-1 downto 2*n) , C => open); 


comp0_2n_p1: CSA_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( I0 => SW(n-1 downto 0), I1 => notSW(2*n-1 downto n), I2 => SW(3*n-1 downto 2*n), S =>sum0_2n_p1 , C =>carry0_2n_p1); 
comp1_2n_p1: CSA_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( I0 => sum0_2n_p1, I1 => carry0_2n_p1, I2 => notSW(4*n-1 downto 3*n), S =>sum1_2n_p1 , C =>carry1_2n_p1); 
comp2_2n_p1: CSA_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( I0 => sum1_2n_p1, I1 => carry1_2n_p1, I2 => zeros, S =>sum2_2n_p1 , C =>carry2_2n_p1); 
add_2n_p1: adder_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( A => sum2_2n_m1, B => carry2_2n_m1, S =>LEDR(4*n-1 downto 3*n) , C => LEDR(16));  

end block;

end Structural;


