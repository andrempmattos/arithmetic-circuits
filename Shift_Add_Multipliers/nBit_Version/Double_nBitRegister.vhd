library IEEE; 
use IEEE.STD_LOGIC_1164.all; 

entity Double_nBitRegister is 
	generic (n : natural := 16);
	port ( 
		Clock :in STD_LOGIC; 
		Reset :in STD_LOGIC;
		Enable : in STD_LOGIC; 
		Shift : in STD_LOGIC;
		InputVectorHigh : in STD_LOGIC_VECTOR(n-1 downto 0);
		OutputVectorHigh : out STD_LOGIC_VECTOR(n-1 downto 0);
		OutputVectorLow : out STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0')
	); 
end entity; 

architecture Behavioral of Double_nBitRegister is 

signal Zeros : STD_LOGIC_VECTOR(n-1 downto 0);
signal OutputAuxAHigh_s, OutputAuxALow_s: STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');
signal OutputAuxBHigh_s, OutputAuxBLow_s: STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');

begin 
	
	Zeros <= (others => '0'); 	

	process(Clock, Enable, Reset, InputVectorHigh, OutputAuxBLow_s) 
	begin 

		if Reset = '0' then 
			OutputAuxAHigh_s <= Zeros;
			OutputAuxALow_s <= Zeros; 

		elsif (Clock'event and Clock = '1') then 
			if Enable = '0' then
				OutputAuxAHigh_s <= InputVectorHigh;
				OutputAuxAHigh_s <= OutputAuxBLow_s;
			end if;
		end if; 

	end process; 

	process (Shift, OutputAuxAHigh_s)
		begin
	 		if Shift = '0' then
				OutputAuxBHigh_s <= ('0' & OutputAuxAHigh_s(n-1 downto 1));
	 			OutputAuxBLow_s <= ((n-1 => OutputAuxAHigh_s(0)) & (n-2 downto 0 => '0')); 
	 		end if;

	end process;

	process (OutputAuxAHigh_s, OutputAuxALow_s, OutputAuxBHigh_s, OutputAuxBLow_s, Shift)
	begin
		if Shift = '0' then
 			OutputVectorHigh <= OutputAuxBHigh_s;
 			OutputVectorLow <= OutputAuxBLow_s;
		else
			OutputVectorHigh <= OutputAuxAHigh_s;
			OutputVectorLow <= OutputAuxALow_s;
 		end if;

	end process;



end architecture; 
