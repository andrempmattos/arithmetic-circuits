library IEEE;
use IEEE.Std_Logic_1164.all;

entity Full_Adder is
	port (
		Input_A: in std_logic;
		Input_B: in std_logic;
		Carry_In: in std_logic;
		Carry_Out: out std_logic;
		Output: out std_logic
	);
end entity;

architecture Logical_Implementation of Full_Adder is
	signal Signal_1, Signal_2, Signal_3: std_logic;
	
	begin
		Signal_1 <= Input_A xor Input_B;
		Signal_2 <= Input_A and Input_B;
		Output <= Signal_1 xor Carry_In;
		Signal_3 <= Signal_1 and Carry_In;
		Carry_Out <= Signal_3 or Signal_2;

end architecture;