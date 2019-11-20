library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ShiftAdd_nBitMultiplier is
	generic (n : natural := 16);
	port (
		InputVector_A : in STD_LOGIC_VECTOR(n-1 downto 0);
		InputVector_B : in STD_LOGIC_VECTOR(n-1 downto 0);
		OutputVector : out STD_LOGIC_VECTOR(2*n-1 downto 0);
		Clock, Reset, Enable_A, Enable_B, Enable_C, Shift : in STD_LOGIC  
	);
end entity;

architecture Structural of ShiftAdd_nBitMultiplier is
	
	component nBitAdder is
		generic (n : natural := 16);
		port (
			InputVector_A : in STD_LOGIC_VECTOR(n-1 downto 0);
			InputVector_B : in STD_LOGIC_VECTOR(n-1 downto 0);
			CarryIn : in STD_LOGIC;
			OutputVector : out STD_LOGIC_VECTOR(n downto 0)
		);
	end component;
	
	component nBitMux is
		generic (n : natural := 16);
	    port (
	        InputVector_A : in STD_LOGIC_VECTOR(n-1 downto 0);
	        InputVector_B : in STD_LOGIC_VECTOR(n-1 downto 0);
	        OutputVector : out STD_LOGIC_VECTOR(n-1 downto 0);
	        Selector: in STD_LOGIC
	  	);
	end component;

	component nBitRegister is 
		generic (n : natural := 16);
		port ( 
			Clock :in STD_LOGIC; 
			Reset :in STD_LOGIC;
			Enable : in STD_LOGIC; 
			Shift : in STD_LOGIC;
			InputVector : in STD_LOGIC_VECTOR(n-1 downto 0); 
			OutputVector : out STD_LOGIC_VECTOR(n-1 downto 0) 
		); 
	end component; 
	
	component Double_nBitRegister is
		generic (n : natural := 16);
		port ( 
			Clock :in STD_LOGIC; 
			Reset :in STD_LOGIC;
			Enable : in STD_LOGIC;
			Shift : in STD_LOGIC; 
			InputVectorHigh : in STD_LOGIC_VECTOR(n-1 downto 0);
			OutputVectorHigh : out STD_LOGIC_VECTOR(n-1 downto 0);
			OutputVectorLow : out STD_LOGIC_VECTOR(n-1 downto 0)
		); 
	end component;

	signal PartialProductInHigh_s : STD_LOGIC_VECTOR(n-1 downto 0);
	signal PartialProductOutHigh_s, PartialProductOutLow_s : STD_LOGIC_VECTOR(n-1 downto 0);
	signal PartialProductOutDouble_s : STD_LOGIC_VECTOR(2*n-1 downto 0); 
	signal AdderOut_s : STD_LOGIC_VECTOR(n downto 0);
	signal MuxInA_s, MuxInB_s, MuxOut_s : STD_LOGIC_VECTOR(n-1 downto 0);
	signal RegisterOutX_s : STD_LOGIC_VECTOR(n-1 downto 0);

	
begin
	
	Multiplier_Register_X: nBitRegister 
		generic map	( n => n )
		port map( 		
			Clock => Clock,
			Reset => Reset,
			Enable => Enable_B,
			Shift => Shift,  
			InputVector => InputVector_B, 
			OutputVector => RegisterOutX_s 
		);

	Multiplier_Register_A: nBitRegister 
		generic map	( n => n )
		port map( 		
			Clock => Clock,
			Reset => Reset,
			Enable => Enable_A,
			Shift => '0',  
			InputVector => InputVector_A, 
			OutputVector => MuxInB_s
		);

	DobleWidth_Partial_Product: Double_nBitRegister 
		generic map	( n => n )
		port map( 		
			Clock => Clock,
			Reset => Reset,
			Enable => Enable_C,
			Shift => Shift,  
			InputVectorHigh => PartialProductInHigh_s, 
			OutputVectorHigh => PartialProductOutHigh_s,
			OutputVectorLow => PartialProductOutLow_s
		);

	PartialProductOutDouble_s <= PartialProductOutHigh_s(n-1 downto 0) &
								 PartialProductOutLow_s(n-1 downto 0);

	MuxInA_s <= (others => '0');
	
	Mux_2Inputs: nBitMux
		generic map	( n => n )
		port map( 		
			InputVector_A => MuxInA_s,
			InputVector_B => MuxInB_s,
			OutputVector => MuxOut_s,  
			Selector => RegisterOutX_s(0)
		); 	

	Adder: nBitAdder
		generic map	( n => n )
		port map( 		
			InputVector_A => MuxOut_s,
			InputVector_B => PartialProductOutHigh_s,
			CarryIn => '0',
			OutputVector => AdderOut_s
		); 	

	PartialProductInHigh_s <= AdderOut_s(n-1 downto 0);

	OutputVector <= PartialProductOutDouble_s;

end architecture;