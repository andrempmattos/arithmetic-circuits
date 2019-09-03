library IEEE;
use IEEE.Std_Logic_1164.all;

entity Versatile_Adder is
	port (
		Input_Vector: in std_logic_vector(3 downto 0);
		Carry_In: in std_logic;
		Carry_Out: out std_logic;
		Output_Vector: out std_logic_vector(10 downto 0)
	);
end entity;

architecture Behavioral of Versatile_Adder is
	
	component Full_Adder is
		port (
		Input_Vector_A: in std_logic_vector(7 downto 0);
		Input_Vector_B: in std_logic_vector(7 downto 0);
		Carry_In: in std_logic;
		Carry_Out: out std_logic;
		Output_Vector: out std_logic_vector(8 downto 0)
	);
	end component;
	
	
	begin
	
	
end architecture;