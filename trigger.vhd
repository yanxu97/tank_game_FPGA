LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use WORK.game_const.all;

ENTITY clk_50hz IS
	PORT(reset, clk : IN	STD_LOGIC;
		  trigger : OUT STD_LOGIC);
END clk_50hz;


ARCHITECTURE update OF clk_50hz IS
signal counter : std_logic_vector(19 downto 0);
signal tg : std_logic;

begin
counting : process(clk,reset) is
begin
	if (reset='1')then
		counter<="00000000000000000000";
		trigger<='0';
	
	elsif (rising_edge(clk)) then
		counter<=std_logic_vector(unsigned(counter)+to_unsigned(1,20));
		trigger<='0';
		if(counter="00000000000000000000")then
			trigger<='1';
		end if;
	end if;
end process;

end update;