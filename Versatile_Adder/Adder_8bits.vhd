library IEEE;
use IEEE.Std_Logic_1164.all;

entity Adder_8bits is
	port (
		Input_Vector_A: in std_logic_vector(7 downto 0);
		Input_Vector_B: in std_logic_vector(7 downto 0);
		Carry_In: in std_logic;
		Output_Vector: out std_logic_vector(8 downto 0)
	);
end entity;

architecture Behavioral of Adder_8bits is
	
	component Full_Adder is
		port (
			Input_A: in std_logic;
			Input_B: in std_logic;
			Carry_In: in std_logic;
			Carry_Out: out std_logic;
			Output: out std_logic
		);
	end component;
	
	signal Carry_Vector_Out: std_logic_vector(8 downto 0);
	
	begin
	
	Carry_Vector_Out(0) <= Carry_In;
	Loop_8bits: 
		for j in 0 to 7 generate
			jbit: Full_Adder port map( 	
				Input_A => Input_Vector_A(j), 
				Input_B => Input_Vector_B(j), 
				Carry_In => Carry_Vector_Out(j), 
				Output => Output_Vector(j), 
				Carry_Out => Carry_Vector_Out(j+1)
			);
		end generate Loop_8bits;
	Output_Vector(8) <= Carry_Vector_Out(8);

end architecture;