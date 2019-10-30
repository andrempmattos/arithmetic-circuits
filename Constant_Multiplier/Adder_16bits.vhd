library IEEE;
use IEEE.Std_Logic_1164.all;

entity Adder_16bits is
	port (
		Input_Vector_A: in std_logic_vector(15 downto 0);
		Input_Vector_B: in std_logic_vector(15 downto 0);
		Carry_In: in std_logic;
		Output_Vector: out std_logic_vector(15 downto 0)
	);
end entity;

architecture Behavioral of Adder_16bits is
	
	component fulladder is
		port(
			A : in STD_LOGIC;
			B : in STD_LOGIC;
			Cin : in STD_LOGIC;
			S : out STD_LOGIC;
			Cout : out STD_LOGIC
		);
	end component;
	
	signal Cout: std_logic_vector(16 downto 0);
	
	begin
	
	Cout(0) <= Carry_In;
	Loop_16bits: 
		for j in 0 to 15 generate
			jbit: fulladder port map( 	
				A => Input_Vector_A(j), 
				B => Input_Vector_B(j), 
				Cin => Cout(j), 
				S => Output_Vector(j), 
				Cout => Cout(j+1)
			);
		end generate Loop_16bits;
	

end architecture;