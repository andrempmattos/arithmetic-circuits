library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ShiftAdd_nBitMultiplier_Wrapper is
	port (
		SW: in std_logic_vector(16 downto 0);
		LEDR: out std_logic_vector(16 downto 0)
		LEDG: out std_logic_vector(3 downto 0)	
	);
end entity;

architecture Behavioral of ShiftAdd_nBitMultiplier_Wrapper is
	
	component Versatile_Adder is
		port (

		);
	end component;

begin	
	
	
end architecture;