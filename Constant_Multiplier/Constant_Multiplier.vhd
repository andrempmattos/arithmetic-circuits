library IEEE;
use IEEE.STD_LOGIC_1164.all;   

entity Constant_Multiplier is
	generic (n : natural := 16);
	port (
		SW   : in STD_LOGIC_VECTOR(17 downto 0);
		KEY : in STD_LOGIC_VECTOR(1 downto 0);
		CLOCK_50: in STD_LOGIC;
		LEDR : out STD_LOGIC_VECTOR(15 downto 0)
	);
end entity;


architecture Structural of Constant_Multiplier is


  component Multimodo is
	generic (n : natural := 16);
	port (
		A : in STD_LOGIC_VECTOR(n-1 downto 0);
		S0,S1,RESET,ENABLE,CLOCK : in STD_LOGIC;
		S :	out STD_LOGIC_VECTOR(n-1 downto 0)
	);
	end component;
	
	component ButtonSync is
	port (
		-- Input ports
		key0	: in  std_logic;
		key1	: in  std_logic;
		key2	: in  std_logic;
		key3	: in  std_logic;	
		clk : in std_logic;
		-- Output ports
		btn0	: out std_logic;
		btn1	: out std_logic;
		btn2	: out std_logic;
		btn3	: out std_logic
	);
	end component;
	
  
signal Btn: std_logic_vector(1 downto 0);

begin

converter : block

begin


sync_btn: ButtonSync port map ( key0 => KEY(0), key1 => KEY(1), key2 => '1', key3 => '1', clk => CLOCK_50,
										btn0 => btn(0), btn1 => btn(1), btn2 => open, btn3 => open);
										
multi: Multimodo generic map	(  n => n)
									port map(A => SW(15 downto 0), S0 => SW(16), S1 => SW(17), RESET => Btn(0), ENABLE => Btn(1), CLOCK => CLOCK_50, S => LEDR(15 downto 0));
	
								  
end block;

end architecture;


