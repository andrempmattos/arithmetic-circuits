library IEEE;
use IEEE.Std_Logic_1164.all;

entity Versatile_Adder_Wrapper is
	port (
		SW: in std_logic_vector(17 downto 0);
		LEDR: out std_logic_vector(17 downto 0);
		LEDG: out std_logic_vector(7 downto 0)
	);
end entity;

architecture Behavioral of Versatile_Adder_Wrapper is
	signal Cout: std_logic_vector(8 downto 0);
	
	component Versatile_Adder is
		port (
			Input_Vector: in std_logic_vector(3 downto 0);
			Operation_Control: in std_logic;
			Output_Vector: out std_logic_vector(10 downto 0)
		);
	end component;

	begin
	
	
end architecture;