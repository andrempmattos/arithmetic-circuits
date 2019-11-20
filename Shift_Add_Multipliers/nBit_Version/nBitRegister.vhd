library IEEE; 
use IEEE.STD_LOGIC_1164.all; 

entity nBitRegister is 
	generic (n : natural := 16);
	port ( 
		Clock :in STD_LOGIC; 
		Reset :in STD_LOGIC;
		Enable : in STD_LOGIC;
		Shift : in STD_LOGIC;
		InputVector : in STD_LOGIC_VECTOR(n-1 downto 0); 
		OutputVector : out STD_LOGIC_VECTOR(n-1 downto 0) 
	); 
end entity; 

architecture Behavioral of nBitRegister is 

signal Zeros : STD_LOGIC_VECTOR(n-1 downto 0);
signal OutputAuxA_s, OutputAuxB_s: STD_LOGIC_VECTOR(n-1 downto 0);

begin 
	
	Zeros <= (others => '0');

	process (Clock, Enable, Reset, InputVector) 
	begin 
		if Reset = '0' then 
			OutputAuxA_s <= Zeros; 

		elsif (Clock'event and Clock = '1') then 
			if Enable = '0' then
				OutputAuxA_s <= InputVector;
			end if;
		end if; 

	end process;

	process (Shift, OutputAuxA_s)
		begin
	 		if Shift = '0' then
	 			OutputAuxB_s <= ('0' & OutputAuxA_s(n-1 downto 1)); 
	 		end if;

	end process;

	process (OutputAuxA_s, OutputAuxB_s, Shift)
	begin
		if Shift = '0' then
 			OutputVector <= OutputAuxB_s;
		else
			OutputVector <= OutputAuxA_s;

 		end if;
		
	end process;

end architecture; 