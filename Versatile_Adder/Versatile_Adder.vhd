library IEEE;
use IEEE.Std_Logic_1164.all;

entity Versatile_Adder is
	port (
		Input_Vector: in std_logic_vector(3 downto 0);
		Operation_Control: in std_logic;
		Output_Vector: out std_logic_vector(10 downto 0)
	);
end entity;

architecture Behavioral of Versatile_Adder is
	
	component Adder_8bits is
		port (
			Input_Vector_A: in std_logic_vector(7 downto 0);
			Input_Vector_B: in std_logic_vector(7 downto 0);
			Carry_In: in std_logic;
			Output_Vector: out std_logic_vector(8 downto 0)
		);
	end component;
	
	component Multiplexer_2_1 is
		port (
			Input_A: in std_logic;
			Input_B: in std_logic;
			Selector: in std_logic;
			Output: out std_logic
		);
	end component;
	
	signal Output_MuxA_s, Output_MuxB_s, Output_MuxC_s: std_logic;
	signal InputA_Adder_s, InputB_Adder_s: std_logic_vector(7 downto 0);
	
	begin
	
	MuxA: Multiplexer_2_1 
        port map (
			Input_Vector(3), Input_Vector(0), Operation_Control, Output_MuxA_s
        );
		
	MuxB: Multiplexer_2_1 
        port map (
			Input_Vector(0), Input_Vector(1), Operation_Control, Output_MuxB_s
        );
		
	MuxC: Multiplexer_2_1 
        port map (
			Input_Vector(1), not Input_Vector(2), Operation_Control, Output_MuxC_s
        );
		
	Adder: Adder_8bits 
        port map (
			InputA_Adder_s(7 downto 0), InputB_Adder_s(7 downto 0), '0', Output_Vector(10 downto 2)
        );
		
	
	Output_Vector(0) <= Input_Vector(0);
	Output_Vector(1) <= Input_Vector(1);
	
	InputA_Adder_s(0) <= Input_Vector(2);
	InputB_Adder_s(0) <= Input_Vector(0) or Operation_Control;
	
	InputA_Adder_s(1) <= Input_Vector(3);
	InputB_Adder_s(1) <= Input_Vector(1) or Operation_Control;
	
	InputA_Adder_s(2) <= Input_Vector(0);
	InputB_Adder_s(2) <= Input_Vector(2) and (not Operation_Control);
	
	InputA_Adder_s(3) <= Input_Vector(1);
	InputB_Adder_s(3) <= Output_MuxA_s;
	
	InputA_Adder_s(4) <= Input_Vector(2);
	InputB_Adder_s(4) <= Output_MuxB_s;
	
	InputA_Adder_s(5) <= Input_Vector(3);
	InputB_Adder_s(5) <= Output_MuxC_s;
	
	InputA_Adder_s(6) <= Input_Vector(2);
	InputB_Adder_s(6) <= Input_Vector(3) and Operation_Control;
	
	InputA_Adder_s(7) <= Input_Vector(3) or Operation_Control;
	InputB_Adder_s(7) <= Operation_Control;
	
	

end architecture;