LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			speed1,speed2 : out std_logic_vector(1 downto 0);
			fire1,fire2 : out std_logic
		);
end entity ps2;


architecture structural of ps2 is

component keyboard IS
	PORT( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset, read : IN STD_LOGIC;
			scan_code : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			scan_ready : OUT STD_LOGIC);
end component keyboard;

component oneshot is
port(
	pulse_out : out std_logic;
	trigger_in : in std_logic; 
	clk: in std_logic );
end component oneshot;

component leddcd is
	port(
		 data_in : in std_logic_vector(3 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
end component leddcd;

signal scan2 : std_logic;
signal scan_code2, history0, history1,history2 : std_logic_vector( 7 downto 0 );
signal read : std_logic;
signal sp1,sp2 : std_logic_vector(1 downto 0);
signal f1,f2 : std_logic;

begin

u1: keyboard port map(	
				keyboard_clk => keyboard_clk,
				keyboard_data => keyboard_data,
				clock_50MHz => clock_50MHz,
				reset => reset,
				read => read,
				scan_code => scan_code2,
				scan_ready => scan2
			);

pulser: oneshot port map(
   pulse_out => read,
   trigger_in => scan2,
   clk => clock_50MHz
			);

scan_readyo <= scan2;
scan_code <= scan_code2;

speed1<=sp1;
speed2<=sp2;
fire1<=f1;
fire2<=f2;

a1 : process(scan2)
begin
	if(rising_edge(scan2)) then
	history2 <= history1;
	history1 <= history0;
	history0 <= scan_code2;
	end if;
end process a1;


speed : process(scan2,reset)
variable det1,det2 : std_logic;
begin
	if (reset='0')then
		sp1<="00";
		sp2<="00";
		f1<='0';
		f2<='0';
		det1:='0';
		det2:='0';
		
	
	elsif(rising_edge(scan2)) then
		f1<='0';
		f2<='0';
		if(scan_code2=X"1C")then
			sp1<="00";
		elsif(scan_code2=X"1B")then
			sp1<="01";
		elsif(scan_code2=X"23")then
			sp1<="10";
		elsif(scan_code2=X"3B")then
			sp2<="00";
		elsif(scan_code2=X"42")then
			sp2<="01";
		elsif(scan_code2=X"4B")then
			sp2<="10";
		elsif(history2=X"12") and (history1=X"F0")then
			f1<='1';
		elsif(history2=X"59") and (history1=X"F0")then
			f2<='1';
		end if;
	end if;
end process speed;

end architecture structural;