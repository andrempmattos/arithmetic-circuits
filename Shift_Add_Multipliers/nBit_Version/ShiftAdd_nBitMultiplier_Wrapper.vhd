library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ShiftAdd_nBitMultiplier_Wrapper is
	generic (n : natural := 8);
	port (
		SW: in std_logic_vector(16 downto 0);
		LEDR: out std_logic_vector(16 downto 0);
		LEDG: out std_logic_vector(3 downto 0);
		KEY : in STD_LOGIC_VECTOR(3 downto 0);
		CLOCK_50: in STD_LOGIC
	);
end entity;

architecture Behavioral of ShiftAdd_nBitMultiplier_Wrapper is
	
	component ShiftAdd_nBitMultiplier is
		generic (n : natural := 8);
		port (
			InputVector_A : in STD_LOGIC_VECTOR(n-1 downto 0);
			InputVector_B : in STD_LOGIC_VECTOR(n-1 downto 0);
			OutputVector : out STD_LOGIC_VECTOR(2*n-1 downto 0);
			Clock, Reset, Enable_A, Enable_B, Enable_C, Shift : in STD_LOGIC  
		);
	end component;

	component ButtonSync is
		port (
			key0 : in  std_logic;
			key1 : in  std_logic;
			key2 : in  std_logic;
			key3 : in  std_logic;	
			clk : in std_logic;
			btn0 : out std_logic;
			btn1 : out std_logic;
			btn2 : out std_logic;
			btn3 : out std_logic
		);
	end component;

	signal Button: std_logic_vector(3 downto 0);

begin	

	SyncButton: ButtonSync 
		port map ( 
			key0 => KEY(0), 
			key1 => KEY(1), 
			key2 => KEY(2), 
			key3 => KEY(3), 
			clk => CLOCK_50,
			btn0 => Button(0), 
			btn1 => Button(1), 
			btn2 => Button(2), 
			btn3 => Button(3)
		);

	Multiplier_Implementation: ShiftAdd_nBitMultiplier 
		generic map	( n => n )
		port map( 		
			InputVector_A => SW(n-1 downto 0),
			InputVector_B => SW(n-1 downto 0),
			OutputVector => LEDR(2*n-1 downto 0),
			Clock => CLOCK_50,
			Reset => Button(0),
			Enable_A => Button(1),
			Enable_B => Button(2),
			Enable_C => Button(3),
			Shift => SW(16)
		);

	LEDG(3 downto 0) <= Button(3 downto 0);
	
	
end architecture;