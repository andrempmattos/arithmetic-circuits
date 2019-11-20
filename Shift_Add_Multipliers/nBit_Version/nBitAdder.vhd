library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity nBitAdder is
	generic (n : natural := 16);
	port (
		InputVector_A : in STD_LOGIC_VECTOR(n-1 downto 0);
		InputVector_B : in STD_LOGIC_VECTOR(n-1 downto 0);
		CarryIn : in STD_LOGIC;
		OutputVector : out STD_LOGIC_VECTOR(n downto 0)
	);
end entity;

architecture Behavioral of nBitAdder is
	
	component FullAdder is
		port (
			InputVector_A : in STD_LOGIC;
			InputVector_B : in STD_LOGIC;
			CarryIn : in STD_LOGIC;
			CarryOut : out STD_LOGIC;
			OutputVector : out STD_LOGIC
		);
	end component;
	
	signal CarryVectorOut: STD_LOGIC_VECTOR(n downto 0);
	
begin
	
	CarryVectorOut(0) <= CarryIn;
	nBitLoop: 
		for j in 0 to (n-1) generate
			jbit: FullAdder port map( 	
				InputVector_A => InputVector_A(j), 
				InputVector_B => InputVector_B(j), 
				CarryIn => CarryVectorOut(j), 
				OutputVector => OutputVector(j), 
				CarryOut => CarryVectorOut(j+1)
			);
		end generate nBitLoop;
	OutputVector(n) <= CarryVectorOut(n);

end architecture;