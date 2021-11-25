LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY score_board_test IS
	PORT(T_reset, T_start, T_clk, T_hit1, T_hit2 : out	STD_LOGIC;
		  T_score1,T_score2: OUT STD_LOGIC_VECTOR(3 downto 0);
		  T_lose1,T_lose2: OUT STD_LOGIC);
END score_board_test;


ARCHITECTURE sb_t OF score_board_test IS
component score_board IS
	PORT(reset, start, clk, hit1, hit2 : in	STD_LOGIC;
		  score1,score2: OUT STD_LOGIC_VECTOR(3 downto 0);
		  lose1,lose2: OUT STD_LOGIC);
END component;


signal hold_clock:std_logic;
constant CLOCK_PERIOD : time := 10 ns;
begin
	dut : score_board port map(T_reset,T_start,T_clk,T_hit1,T_hit2,T_score1,T_score2,T_lose1,T_lose2);
process is
	begin
		hold_clock<='0';
		T_hit1<='0';
		T_hit2<='0';
		T_start<='0';
		wait for 20 ns;
		
		T_start<='1';
		wait for 20 ns;
		
		T_hit1<='0';
		T_hit2<='1';
		wait for 10 ns;
		
		T_hit1<='0';
		T_hit2<='0';
		wait for 10 ns;
		
		T_hit1<='1';
		T_hit2<='0';
		wait for 10 ns;
		
		T_hit1<='0';
		T_hit2<='1';
		wait for 10 ns;
		
		T_hit1<='0';
		T_hit2<='0';
		wait for 10 ns;
		
		T_hit1<='0';
		T_hit2<='1';
		wait for 10 ns;
		
		T_hit1<='0';
		T_hit2<='0';
		wait for 50 ns;
		hold_clock<='1';
		wait;
end process;
	
clock_process: process is
begin
	T_clk <= '1';
	wait for (CLOCK_PERIOD / 2);
	T_clk<='0';
	wait for (CLOCK_PERIOD / 2);
	if ( hold_clock = '1' ) then
	wait;
	end if;
end process clock_process;

reset_process : process
	begin
		T_reset<='0';
		wait until (T_clk='0');
		wait until (T_clk='1');
		T_reset<='1';
		wait until (T_clk='0');
		wait until (T_clk='1');
		T_reset<='0';
		wait;
end process reset_process;

END sb_t;