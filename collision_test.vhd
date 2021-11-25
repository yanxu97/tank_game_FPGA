LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY collision_test IS
	PORT(
		  T_reset, T_start, T_clk, T_fire : out	STD_LOGIC;
		  T_xb, T_yb, T_xt, T_yt : out STD_LOGIC_VECTOR(15 downto 0);
		  T_collision: OUT STD_LOGIC);
END collision_test;

ARCHITECTURE collision_t OF collision_test IS
component collision IS
	PORT(reset, start, clk, fire : IN	STD_LOGIC;
		  xb,yb,xt,yt : IN STD_LOGIC_VECTOR(15 downto 0);
		  collision : OUT STD_LOGIC);
END component;

signal hold_clock:std_logic;
constant CLOCK_PERIOD : time := 10 ns;
begin
	dut : collision port map(T_reset,T_start,T_clk,T_fire,T_xb, T_yb, T_xt, T_yt, T_collision);
process is
	begin
		hold_clock<='0';
		T_fire<='0';
		T_xb<=std_logic_vector(to_signed(0,16));
		T_yb<=std_logic_vector(to_signed(0,16));
		T_xt<=std_logic_vector(to_signed(0,16));
		T_yt<=std_logic_vector(to_signed(0,16));
		T_start<='1';
		wait for 20 ns;
		
		T_fire<='1';
		wait for 50 ns;
		
		T_xb<=std_logic_vector(to_signed(300,16));
		T_yb<=std_logic_vector(to_signed(300,16));
		T_xt<=std_logic_vector(to_signed(320,16));
		T_yt<=std_logic_vector(to_signed(285,16));
		wait for 30 ns;
		--Collision
		
		T_xb<=std_logic_vector(to_signed(300,16));
		T_yb<=std_logic_vector(to_signed(300,16));
		T_xt<=std_logic_vector(to_signed(320,16));
		T_yt<=std_logic_vector(to_signed(310,16));
		wait for 30 ns;
		--Collision
		
		T_xb<=std_logic_vector(to_signed(300,16));
		T_yb<=std_logic_vector(to_signed(300,16));
		T_xt<=std_logic_vector(to_signed(338,16));
		T_yt<=std_logic_vector(to_signed(290,16));
		wait for 30 ns;
		--Collision
		
		T_xb<=std_logic_vector(to_signed(300,16));
		T_yb<=std_logic_vector(to_signed(300,16));
		T_xt<=std_logic_vector(to_signed(320,16));
		T_yt<=std_logic_vector(to_signed(265,16));
		wait for 30 ns;
		--Collision
		
		T_xb<=std_logic_vector(to_signed(260,16));
		T_yb<=std_logic_vector(to_signed(300,16));
		T_xt<=std_logic_vector(to_signed(320,16));
		T_yt<=std_logic_vector(to_signed(290,16));
		wait for 30 ns;
		--No Collision
		
		T_xb<=std_logic_vector(to_signed(300,16));
		T_yb<=std_logic_vector(to_signed(260,16));
		T_xt<=std_logic_vector(to_signed(320,16));
		T_yt<=std_logic_vector(to_signed(290,16));
		wait for 30 ns;
		--No Collision
		
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

END collision_t;