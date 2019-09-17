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

library IEEE;
use IEEE.STD_LOGIC_1164.all;   
--use work.bin_components.all;
--use work.compuRNS_def.all;
library work;
use work.fuctions.all;
--use work.rns_components.all;

entity traditionalSystem_BinToRNStoBin is
	generic (n : natural := 4);
	 port(SW   : in STD_LOGIC_VECTOR(4*n-1 downto 0);
			LEDR : out STD_LOGIC_VECTOR(4*n downto 0);
	 		HEX0: out STD_LOGIC_VECTOR(6 downto 0);
	 		HEX1: out STD_LOGIC_VECTOR(6 downto 0);
	 		HEX2: out STD_LOGIC_VECTOR(6 downto 0);
	 		HEX3: out STD_LOGIC_VECTOR(6 downto 0)
	 );
end entity;

--}} End of automatically maintained section

architecture Structural of traditionalSystem_BinToRNStoBin is
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


  component Decod7seg is
	port (C: in std_logic_vector(3 downto 0);
 		  F: out std_logic_vector(6 downto 0)
 	);
  end component;
  
signal zeros : std_logic_vector(n-1 downto 0);
signal sum0_2n_m1 , carry0_2n_m1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_m1 , carry1_2n_m1 : std_logic_vector(n-1 downto 0);

signal sum0_2n_p1 , carry0_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_p1 , carry1_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum2_2n_p1 , carry2_2n_p1 : std_logic_vector(n-1 downto 0);

signal sum0_2n_n1 , carry0_2n_n1 : std_logic_vector(2*n-1 downto 0);
signal sum1_2n_n1 , carry1_2n_n1 : std_logic_vector(2*n-1 downto 0);

signal notSW : std_logic_vector(4*n-1 downto 0);
signal Interface_Vector: std_logic_vector(4*n downto 0);
signal Output_Vector: std_logic_vector(4*n-1 downto 0);

signal A: std_logic_vector(2*n-1 downto 0);
signal B: std_logic_vector(2*n-1 downto 0);
signal C: std_logic_vector(2*n-1 downto 0);
signal D: std_logic_vector(2*n-1 downto 0);

begin
	-- enter your statements here -- 
zeros <= (others =>'0');	
notSW(4*n-1 downto 0) <= not(SW(4*n-1 downto 0));


converter : block

begin
Interface_Vector(2*n-1 downto 0) <= SW(2*n-1 downto 0);

comp0_2n_m1: CSA_2n_mp_1	generic map	(  n => n , modo => 0)
	                       port map ( I0 => SW(n-1 downto 0), I1 => SW(2*n-1 downto n), I2 => SW(3*n-1 downto 2*n), S =>sum0_2n_m1 , C =>carry0_2n_m1); 
comp1_2n_m1: CSA_2n_mp_1	generic map	(  n => n , modo => 0)
	                       port map ( I0 => sum0_2n_m1, I1 => carry0_2n_m1, I2 => SW(4*n-1 downto 3*n), S =>sum1_2n_m1 , C =>carry1_2n_m1); 
add_2n_m1: adder_2n_mp_1	generic map	(  n => n , modo => 0)
	                       port map ( A => sum1_2n_m1, B => carry1_2n_m1, S =>Interface_Vector(3*n-1 downto 2*n) , Cout => open); 


comp0_2n_p1: CSA_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( I0 => SW(n-1 downto 0), I1 => notSW(2*n-1 downto n), I2 => SW(3*n-1 downto 2*n), S =>sum0_2n_p1 , C =>carry0_2n_p1); 
comp1_2n_p1: CSA_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( I0 => sum0_2n_p1, I1 => carry0_2n_p1, I2 => notSW(4*n-1 downto 3*n), S =>sum1_2n_p1 , C =>carry1_2n_p1); 
comp2_2n_p1: CSA_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( I0 => sum1_2n_p1, I1 => carry1_2n_p1, I2 => zeros, S =>sum2_2n_p1 , C =>carry2_2n_p1); 
add_2n_p1: adder_2n_mp_1	generic map	(  n => n , modo => 1)
	                       port map ( A => sum2_2n_p1, B => carry2_2n_p1, S =>Interface_Vector(4*n-1 downto 3*n) , Cout => Interface_Vector(16));  

  A(2*n-1 downto 0) <= not Interface_Vector(2*n-1 downto 0);
  B(2*n-1 downto 0) <= Interface_Vector(2*n) & Interface_Vector(3*n-1 downto 2*n+1) & Interface_Vector(2*n) & Interface_Vector(3*n-1 downto 2*n+1);
  C(2*n-1 downto 0) <= Interface_Vector(3*n) & "000" & Interface_Vector(4*n downto 3*n+1); 
  D(2*n-1 downto 0) <= (not Interface_Vector(4*n downto 3*n)) & "111";

  
  comp0_2n_n1: CSA_2n_mp_1	generic map	(  n => 2*n , modo => 0)
  	                       port map ( I0 => A(2*n-1 downto 0), I1 => B(2*n-1 downto 0), I2 => C(2*n-1 downto 0), S =>sum0_2n_n1 , C =>carry0_2n_n1);
  comp1_2n_n1: CSA_2n_mp_1	generic map	(  n => 2*n , modo => 0)
  	                       port map ( I0 => sum0_2n_n1, I1 => carry0_2n_n1, I2 => D(2*n-1 downto 0), S =>sum1_2n_n1 , C =>carry1_2n_n1);

  
  add_2n_n1: adder_2n_mp_1 generic map	(  n => 2*n , modo => 0)
                   port map(a=> sum1_2n_n1, b => carry1_2n_n1, s  => Output_Vector(4*n-1 downto 2*n), cout => open);
  
  Output_Vector(2*n-1 downto 0) <= SW(7 downto 0);
  end block;

  Display7SegA:
	Decod7seg port map ( C => Output_Vector(n-1 downto 0), F => HEX0(n-1 downto 0)); 
  Display7SegB:
	Decod7seg port map ( C => Output_Vector(2*n-1 downto n), F => HEX1(2*n-1 downto n));  
  Display7SegC:	
	Decod7seg port map ( C => Output_Vector(3*n-1 downto 2*n), F => HEX2(3*n-1 downto 2*n));  
  Display7SegD:	
	Decod7seg port map ( C => Output_Vector(4*n-1 downto 3*n), F => HEX3(4*n-1 downto 3*n));   

end Structural;
