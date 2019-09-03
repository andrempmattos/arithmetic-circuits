library IEEE;
use IEEE.Std_Logic_1164.all;

entity Multiplexer_2_1 is
	port (
		Input_A: in std_logic;
		Input_B: in std_logic;
		Selector: in std_logic;
		Output: out std_logic
	);
end entity;
  
architecture Behavioral of Multiplexer_2_1 is
	begin
	
	Output <= Input_A when Selector = '0' else Input_B;

end architecture;