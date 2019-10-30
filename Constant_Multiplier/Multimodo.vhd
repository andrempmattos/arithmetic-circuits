library IEEE;
use IEEE.STD_LOGIC_1164.all;   

entity Multimodo is
	generic (n : natural := 16);
	port(
	 	A   : in STD_LOGIC_VECTOR(n-1 downto 0);
		S0,S1,RESET,ENABLE,CLOCK : in STD_LOGIC;
		S	:	out STD_LOGIC_VECTOR(n-1 downto 0)
	);
end entity;


architecture Structural of Multimodo is


  component Mux4_1 is
	generic(n :natural:=16);
	 port(
		  A,B,C,D: in STD_LOGIC_VECTOR(n-1 downto 0);
		  Z : out STD_LOGIC_VECTOR(n-1 downto 0);
		  S0,S1: in STD_LOGIC
	  );
	end component;
	
	component D_16FF is port ( 
		CLK, RST, EN: in std_logic; 
		D: in std_logic_vector(15 downto 0); 
		Q: out std_logic_vector(15 downto 0) 
	); 
	end component; 
	
	component Adder_16bits is
	port (
		Input_Vector_A: in std_logic_vector(15 downto 0);
		Input_Vector_B: in std_logic_vector(15 downto 0);
		Carry_In: in std_logic;
		Output_Vector: out std_logic_vector(15 downto 0)
	);
	end component;
	
signal Mux_Out: std_logic_vector(n-1 downto 0);
signal Mux_In1, Mux_In2, Mux_In3, Mux_In4: std_logic_vector(n-1 downto 0);
signal Register_Out: std_logic_vector(n-1 downto 0);

begin

converter : block

begin

Mux: Mux4_1 generic map (n => n)
			port map ( 
				A => Mux_In1(n-1 downto 0), 
				B => Mux_In2(n-1 downto 0), 
				C => Mux_In3(n-1 downto 0), 
				D => Mux_In4(n-1 downto 0), 
				Z => Mux_Out(n-1 downto 0), 
				S0 => S0, S1 => S1
			);

Register_8Bits: D_16FF 
			port map (
				CLK => CLOCK, 
				RST => RESET, 
				EN => ENABLE, 
				D => Mux_Out(n-1 downto 0), 
				Q => Register_Out(n-1 downto 0)
			); 

adder: Adder_16bits 
			port map (
				Input_Vector_A => A(n-1 downto 0),
				Input_Vector_B => Register_Out(n-1 downto 0),
				Carry_In => '0',
				Output_Vector => Mux_In1(n-1 downto 0)
			);

Mux_In2(n-1 downto 0) <= A(n-1 downto 0);
Mux_In3(n-1 downto 0) <= '0' & A(n-2 downto 0);
Mux_In4(n-1 downto 0) <= A(n-1 downto 1) & '0';

S(n-1 downto 0) <= Register_Out(n-1 downto 0);
								  
end block;

end Structural;


