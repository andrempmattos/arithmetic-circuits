library IEEE;
use IEEE.Std_Logic_1164.all;

entity Versatile_Adder_Wrapper is
	port (
		SW: in std_logic_vector(4 downto 0);
		LEDR: out std_logic_vector(10 downto 0)
	);
end entity;

architecture Behavioral of Versatile_Adder_Wrapper is
	
	component Versatile_Adder is
		port (
			Input_Vector: in std_logic_vector(3 downto 0);
			Operation_Control: in std_logic;
			Output_Vector: out std_logic_vector(10 downto 0)
		);
	end component;

	begin
	
	Adder: Versatile_Adder 
        port map (
			SW(3 downto 0), SW(4), LEDR(10 downto 0)
        );
	
	
end architecture;