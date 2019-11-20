library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FullAdder is
	port (
		InputVector_A : in std_logic;
		InputVector_B : in std_logic;
		CarryIn : in std_logic;
		CarryOut : out std_logic;
		OutputVector : out std_logic
	);
end entity;

architecture LogicalImplementation of FullAdder is
	
signal Signal_1, Signal_2, Signal_3: std_logic;
	
begin
	Signal_1 <= InputVector_A xor InputVector_B;
	Signal_2 <= InputVector_A and InputVector_B;
	OutputVector <= Signal_1 xor CarryIn;
	Signal_3 <= Signal_1 and CarryIn;
	CarryOut <= Signal_3 or Signal_2;

end architecture;