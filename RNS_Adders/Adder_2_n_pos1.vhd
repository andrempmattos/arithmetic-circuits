 ---------------------------------------------------------------------------------------------------
 --
 -- Title       : Adder Optimized in area
 -- Design      : BinRNS
 -- Author      : Hector Pettenghi
 -- Company     : INESC-ID
 --
 ---------------------------------------------------------------------------------------------------

 library IEEE;
 use IEEE.STD_LOGIC_1164.all;
 
 entity Adder_2_n_pos1 is
 	generic(n : natural :=4);
 	 port(--entradas--
			a : in STD_LOGIC_VECTOR(n downto 0);
			b : in STD_LOGIC_VECTOR(n downto 0);
			s : out STD_LOGIC_VECTOR(n downto 0));
 end Adder_2_n_pos1;
 
 --}} End of automatically maintained section
 
 architecture structural of Adder_2_n_pos1 is 
 
 component fulladder is
 	 port(A : in STD_LOGIC;
 		   B : in STD_LOGIC;
 		   Cin : in STD_LOGIC;
 		   S : out STD_LOGIC;
 		   Cout : out STD_LOGIC);
 end component;
 
 component Mux2_1 is
     generic(ep :positive:=4);
     port (A: in STD_LOGIC_VECTOR (ep-1 downto 0);
           B: in STD_LOGIC_VECTOR (ep-1 downto 0);
           SEL: in STD_LOGIC;
           S: out STD_LOGIC_VECTOR (ep-1 downto 0));
 end component;
     		
 signal zeros : STD_LOGIC_VECTOR(5*n downto 0);
 signal ones : STD_LOGIC_VECTOR(n-1 downto 0);
 signal matrix3 : STD_LOGIC_VECTOR(n+2 downto 0);
 signal x_rns : STD_LOGIC_VECTOR(n+1 downto 0);
 signal cpa_cout : STD_LOGIC_VECTOR(n+1 downto 0);
 signal r_cout : STD_LOGIC_VECTOR(n+1 downto 0);
 signal r_sout : STD_LOGIC_VECTOR(n+1 downto 0);
 signal controlmux : STD_LOGIC;
 
 begin
 -- enter your statements here --
 zeros <= (others=> '0');
 ones <= (others=> '1');
 
 matrix3(n+2 downto n+1) <= ones(1 downto 0);
 matrix3(n) <= '0';
 matrix3(n-1 downto 0) <= ones(n-1 downto 0);

 cpa_cout(0) <= '0';

 add_cpa_cycle1 : for j in 0 to n generate
 	cpa1:	fulladder port map( A => a(j),B => b(j), Cin =>cpa_cout(j) , S =>x_rns(j) , Cout =>cpa_cout(j+1) );
 end generate add_cpa_cycle1;
   
 x_rns(n+1) <= cpa_cout(n+1);
      
 sum0: fulladder port map( A => matrix3(0), B => x_rns(0), Cin => '0' , S =>r_sout(0), Cout => r_cout(0));

 f4: for j in 1 to n+1 generate
	sum1: fulladder port map( A => matrix3(j), B => x_rns(j), Cin => r_cout((j-1)), S =>r_sout(j) , Cout => r_cout(j) );
 end generate f4;
     
 controlmux <= (matrix3(n+2) xor r_cout(n+1)); --NOT r_count(n+1)
     
 MUX2_5: Mux2_1 generic map(ep=>n+1)
					 port map( A => r_sout(n downto 0),  B => x_rns(n downto 0), SEL => controlmux , S =>s(n downto 0));
     
 end structural;
