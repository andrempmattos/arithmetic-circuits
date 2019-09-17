---------------------------------------------------------------------------------------------------
--
-- Title       : RNSsystem Compact RNS - extended Traditional
-- Design      : RNS systems
-- Author      : 
-- Company     : SIPS INESC-id
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use work.bin_components.all;
--use work.compuRNS_def.all;
library work;
use work.fuctions.all;
--use work.rns_components.all;

entity traditionalSystem_RNStoBin is
	generic (n : natural := 4);
	 port(SW : in STD_LOGIC_VECTOR(4*n downto 0);
		   LEDR : out STD_LOGIC_VECTOR(4*n-1 downto 0));
end traditionalSystem_RNStoBin;
  
--}} End of automatically maintained section
  
architecture Structural of traditionalSystem_RNStoBin is
 
  component CSA_2n_mp_1 is
	generic (n : natural;
				-- modo = 0 => 2^n-1
				-- modo = 1 => 2^n+1
				modo: NATURAL);
  	port(I0 : in STD_LOGIC_VECTOR((n-1) downto 0);
		  I1 : in STD_LOGIC_VECTOR((n-1) downto 0);
		  I2 : in STD_LOGIC_VECTOR((n-1) downto 0);
		  S  : out STD_LOGIC_VECTOR((n-1) downto 0);
		  C  : out STD_LOGIC_VECTOR((n-1) downto 0));
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


signal zeros : std_logic_vector(n-2 downto 0);
signal A, B, C, D : std_logic_vector(2*n-1 downto 0);
signal sum0_2n_m1 , carry0_2n_m1 : std_logic_vector(2*n-1 downto 0);
signal sum1_2n_m1 , carry1_2n_m1 : std_logic_vector(2*n-1 downto 0);

signal ones : std_logic_vector(2*n-1 downto 0);
  
begin
  	-- enter your statements here --
  
  ones <= (others => '1');
  zeros <= (others => '0');
  	 
  A(2*n-1 downto 0) <= not SW(2*n-1 downto 0);
  B(2*n-1 downto 0) <= SW(2*n) & SW(3*n-1 downto 2*n+1) & SW(2*n) & SW(3*n-1 downto 2*n+1);
  C(2*n-1 downto 0) <= SW(3*n) & "000" & SW(4*n downto 3*n+1); 
  D(2*n-1 downto 0) <= (not SW(4*n downto 3*n)) & "111";
  
  
  converter : block
  
  begin
  comp0_2n_m1: CSA_2n_mp_1	generic map	(  n => 2*n , modo => 0)
  	                       port map ( I0 => A(2*n-1 downto 0), I1 => B(2*n-1 downto 0), I2 => C(2*n-1 downto 0), S =>sum0_2n_m1 , C =>carry0_2n_m1);
  comp1_2n_m1: CSA_2n_mp_1	generic map	(  n => 2*n , modo => 0)
  	                       port map ( I0 => sum0_2n_m1, I1 => carry0_2n_m1, I2 => D(2*n-1 downto 0), S =>sum1_2n_m1 , C =>carry1_2n_m1);

  
  add_2n_m1: adder_2n_mp_1 generic map	(  n => 2*n , modo => 0)
                   port map(a=> sum1_2n_m1, b => carry1_2n_m1, s  => LEDR(4*n-1 downto 2*n), cout => open);
  
  LEDR(2*n-1 downto 0) <= SW(7 downto 0);
  end block;
  
  end Structural;
