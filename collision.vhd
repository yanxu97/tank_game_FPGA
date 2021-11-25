LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use WORK.game_const.all;

ENTITY collision IS
	PORT(reset, start, clk, fire : IN	STD_LOGIC;
		  xb,yb,xt,yt : IN STD_LOGIC_VECTOR(15 downto 0);
		  collision : OUT STD_LOGIC);
END collision;


ARCHITECTURE fsm_c OF collision IS
	TYPE state IS (idle, nf, f, hit);
	SIGNAL current,nex : state;
begin

statereg : process(reset,clk) is
begin
	if(reset='1')then
		current<=idle;
		
	elsif (rising_edge(clk))then		
		current<=nex;
		
	end if;
end process statereg;

statelogic : process(current, start, fire) is
begin
	nex<=current;
	collision<='0';
	case(current)is
		when idle=>
			if (start='1')then
				nex<=nf;
			end if;
			
		when nf=>
			if (fire='1')then
				nex<=f;
			end if;
			
		when f=>
			if (to_integer(signed(xb))+BULLET_WIDTH/2>=to_integer(signed(xt))-TANK_WIDTH/2) and 
				(to_integer(signed(xb))-BULLET_WIDTH/2<=to_integer(signed(xt))+TANK_WIDTH/2) and
				(to_integer(signed(yb))+BULLET_HEIGHT/2>=to_integer(signed(yt))-TANK_HEIGHT/2) and
				(to_integer(signed(yb))-BULLET_HEIGHT/2<=to_integer(signed(yt))+TANK_HEIGHT/2) then
				nex<=hit;
			end if;
			
		when hit=>
			collision<='1';
			nex<=nf;
	end case;
end process statelogic;		

end fsm_c;