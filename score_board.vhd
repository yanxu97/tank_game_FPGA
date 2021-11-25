LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY score_board IS
	PORT(reset, start, clk, hit1, hit2 : IN	STD_LOGIC;
		  score1,score2: OUT STD_LOGIC_VECTOR(3 downto 0);
		  lose1,lose2: OUT STD_LOGIC);
END score_board;


ARCHITECTURE fsm_sb OF score_board IS
	TYPE state IS (idle,s0,w1,w2);
	SIGNAL current,nex : state;
	SIGNAL s1,s1_c,s2,s2_c: std_logic_vector(3 downto 0);
	
	component leddcd is
	port(
		 data_in : in std_logic_vector(3 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
	end component leddcd;
	
begin
statereg : process(reset,clk) is
begin
	if (reset='1')then
		current<=idle;
		s1<="0000";
		s2<="0000";		
		score1<="0000";
		score2<="0000";
	elsif (rising_edge(clk))then
		current<=nex;
		s1<=s1_c;
		s2<=s2_c;
		score1<=s1_c;
		score2<=s2_c;
	end if;
end process statereg;
	
statelogic : process(start,current,s1,s2,hit1,hit2) is
begin
	nex<=current;
	s1_c<=s1;
	s2_c<=s2;
	lose1<='0';
	lose2<='0';
	case(current)is
		when idle=>
			if(start='1')then
				nex<=s0;
			end if;
		
		when s0=>
			if(s1="0011")then
				nex<=w1;
			elsif(s2="0011")then
				nex<=w2;
			elsif(hit1='1')then
				s2_c<=std_logic_vector(unsigned(s2)+to_unsigned(1,4));
			elsif(hit2='1')then
				s1_c<=std_logic_vector(unsigned(s1)+to_unsigned(1,4));
			end if;
			
			
		when w1=>
			lose2<='1';
			if(reset='1')then
				nex<=idle;
			end if;
			
		when w2=>
			lose1<='1';
			if(reset='1')then
				nex<=idle;
			end if;
	end case;
end process;

end fsm_sb;