LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY tank_test IS
	PORT(
	T_reset, T_start, T_clk, T_direction, T_update : out	STD_LOGIC;
		  T_speed : out STD_LOGIC_VECTOR(1 downto 0);
		  T_pos_x,T_pos_y: OUT STD_LOGIC_VECTOR(15 downto 0));
END tank_test;

ARCHITECTURE tank_t OF tank_test IS
component tank IS
	PORT(reset, start, clk,direction,update : IN	STD_LOGIC;
		  speed : IN STD_LOGIC_VECTOR(1 downto 0);
		  pos_x,pos_y: OUT STD_LOGIC_VECTOR(15 downto 0));
END component;
signal hold_clock:std_logic;
constant CLOCK_PERIOD : time := 10 ps;
signal counter : std_logic_vector(19 downto 0);
begin
	dut : tank port map(T_reset,T_start,T_clk,T_direction,T_update,T_speed,T_pos_x,T_pos_y);
process is
	begin
		hold_clock<='0';
		T_direction<='1';
		T_speed<="00";
		T_start<='1';
		wait for 300 us;
		T_speed<="01";
		wait for 300 us;
		T_speed<="10";
		wait for 500 us;
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

counting : process is
begin
	if (T_reset='1')then
		counter<="00000000000000000000";
		T_update<='0';
		wait until(T_reset='0');
	end if;
	wait until rising_edge(T_clk);
		T_update<='0';
		counter<=std_logic_vector(unsigned(counter)+to_unsigned(1,20));
		if(counter="00000000000000000000")then
			T_update<='1';
		end if;
	if (hold_clock='1')then
	wait;
	end if;
end process counting;


END tank_t;