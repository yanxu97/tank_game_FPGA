LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY tank_game IS
	PORT(CLOCK_50 										: in std_logic;
			RESET_N										: in std_logic;
			RESET                               : in std_logic;
			--VGA 
			k_clk                               : in std_logic;
			k_data                              : in std_logic;
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic;
			LCD_BUS: inout std_logic_vector(7 downto 0);
			LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED : out std_logic;
			score_dis : out std_logic_vector(13 downto 0);
			LCD_RW : BUFFER STD_LOGIC);
END tank_game;

ARCHITECTURE update1 OF tank_game IS

component tank IS
	PORT(reset, start, clk, direction, update : IN	STD_LOGIC;
		  speed : IN STD_LOGIC_VECTOR(1 downto 0);
		  pos_x,pos_y: OUT STD_LOGIC_VECTOR(15 downto 0));
END component;

component VGA_top_level is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
			t1x,t1y,t2x,t2y								: in std_logic_vector(15 downto 0);
			b1x,b1y,b2x,b2y								: in std_logic_vector(15 downto 0);
			dis1,dis2,lose1,lose2                  : in std_logic;
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
end component;

component clk_50hz IS
	PORT(reset, clk : IN	STD_LOGIC;
		  trigger : OUT STD_LOGIC);
END component;


component ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			speed1,speed2 : out std_logic_vector(1 downto 0);
			fire1,fire2 : out std_logic
		);
end component;

component de2lcd IS
	PORT(reset, clk_50Mhz, lose1, lose2				: IN	STD_LOGIC;
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		 LCD_RW						: BUFFER STD_LOGIC;
		 DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END component;

component bullet IS
    PORT (
        reset, start, clk_s, clk_f : IN STD_LOGIC; -- clk_s : trigger       clk_f : clk
        fire                       : IN STD_LOGIC; -- high for one clock cycle
        direction                  : IN STD_LOGIC; -- 1 : upward   0 : downward
        xt_h, yt_h                 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        xt_l, yt_l                 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        xb, yb                     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        hit_h, hit_l               : OUT STD_LOGIC;
        display_en                 : OUT STD_LOGIC
    );
END component;

component score_board IS
	PORT(reset, start, clk, hit1, hit2 : IN	STD_LOGIC;
		  score1,score2: OUT STD_LOGIC_VECTOR(3 downto 0);
		  lose1,lose2: OUT STD_LOGIC);
END component;

component leddcd is
	port(
		 data_in : in std_logic_vector(3 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
end component;	

signal tg50 : std_logic;
signal t1x,t1y,t2x,t2y,b1x,b1y,b2x,b2y : std_logic_vector(15 downto 0);
signal sc: std_logic_vector(7 downto 0);
signal sr: std_logic;
signal sp1,sp2: std_logic_vector(1 downto 0);
signal f1,f2:std_logic;
signal hit12,hit11,hit21,hit22, dis1, dis2, l1, l2: std_logic;
signal score1,score2: std_logic_vector(3 downto 0);

begin
	tg: clk_50hz port map(RESET, CLOCK_50, tg50);
	t1: tank port map(RESET, '1', CLOCK_50, '1', tg50,sp1,t1x,t1y);
	t2: tank port map(RESET, '1', CLOCK_50, '0', tg50,sp2,t2x,t2y);
	vga: VGA_top_level port map(CLOCK_50, RESET_N, t1x, t1y, t2x, t2y, b1x, b1y, b2x, b2y, dis1, dis2, l1,l2, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK);
	keyboard: ps2 port map(k_clk,k_data,CLOCK_50,RESET_N, sc,sr,sp1,sp2,f1,f2);
	lcd: de2lcd port map(RESET_N, CLOCK_50, l2,l1,LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED, LCD_RW, LCD_BUS);
	b1: bullet port map(RESET, '1',tg50,CLOCK_50,f1,'1',t2x,t2y,t1x,t1y,b1x,b1y,hit12,hit11,dis1);
	b2: bullet port map(RESET, '1',tg50,CLOCK_50,f2,'0',t2x,t2y,t1x,t1y,b2x,b2y,hit22,hit21,dis2);
	sb: score_board port map(reset,'1',CLOCK_50,hit12,hit21,score1,score2,l1,l2);
	led1: leddcd port map(score1,score_dis(6 downto 0));
	led2: leddcd port map(score2,score_dis(13 downto 7));
	
END update1;