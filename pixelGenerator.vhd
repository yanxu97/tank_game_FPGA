library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.game_const.all;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 		   : in std_logic;
			pixel_row, pixel_column						   : in std_logic_vector(9 downto 0);
			t1x,t1y,t2x,t2y									: in std_logic_vector(15 downto 0);
			b1x,b1y,b2x,b2y									: in std_logic_vector(15 downto 0);
			dis1,dis2,lose1,lose2                     : in std_logic;
			red_out, green_out, blue_out					: out std_logic_vector(9 downto 0)
		);
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
constant color_green	 : std_logic_vector(2 downto 0) := "001";
constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
constant color_black 	 : std_logic_vector(2 downto 0) := "110";
constant color_white	 : std_logic_vector(2 downto 0) := "111";
	
component colorROM is
	port
	(
		address		: in std_logic_vector (2 downto 0);
		clock		: in std_logic  := '1';
		q			: out std_logic_vector (29 downto 0)
	);
end component colorROM;

signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (29 downto 0);

signal pixel_row_int, pixel_column_int : natural;

begin

--------------------------------------------------------------------------------------------
	
	red_out <= color(29 downto 20);
	green_out <= color(19 downto 10);
	blue_out <= color(9 downto 0);

	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
--------------------------------------------------------------------------------------------	
	
	colors : colorROM
		port map(colorAddress, ROM_clk, color);

--------------------------------------------------------------------------------------------	

	pixelDraw : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
		
			if (pixel_column_int >= to_integer(signed(t1x))-TANK_WIDTH/2  and pixel_row_int >= to_integer(signed(t1y))-TANK_HEIGHT/2
				and pixel_column_int <to_integer(signed(t1x)+TANK_WIDTH/2)  and pixel_row_int < to_integer(signed(t1y))+TANK_HEIGHT/2) and (lose2='0') then
				colorAddress <= color_red;
				
			elsif (pixel_column_int >= to_integer(signed(t2x))-TANK_WIDTH/2  and pixel_row_int >= to_integer(signed(t2y))-TANK_HEIGHT/2
				and pixel_column_int <to_integer(signed(t2x)+TANK_WIDTH/2)  and pixel_row_int < to_integer(signed(t2y))+TANK_HEIGHT/2) and (lose1='0') then
				colorAddress <= color_blue;
			
			elsif (pixel_column_int >= to_integer(signed(b1x))-BULLET_WIDTH/2  and pixel_row_int >= to_integer(signed(b1y))-BULLET_HEIGHT/2
				and pixel_column_int <to_integer(signed(b1x)+BULLET_WIDTH/2)  and pixel_row_int < to_integer(signed(b1y))+BULLET_HEIGHT/2) and (dis1='1') then
				colorAddress <= color_cyan;
			
			elsif (pixel_column_int >= to_integer(signed(b2x))-BULLET_WIDTH/2  and pixel_row_int >= to_integer(signed(b2y))-BULLET_HEIGHT/2
				and pixel_column_int <to_integer(signed(b2x)+BULLET_WIDTH/2)  and pixel_row_int < to_integer(signed(b2y))+BULLET_HEIGHT/2) and (dis2='1') then
				colorAddress <= color_magenta;
			
			else
				colorAddress <= color_white;
			end if;
			
		end if;
		
	end process pixelDraw;	

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		