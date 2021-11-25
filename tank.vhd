LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY tank IS
	PORT(reset, start, clk, direction, update : IN	STD_LOGIC;
		  speed : IN STD_LOGIC_VECTOR(1 downto 0);
		  pos_x,pos_y: OUT STD_LOGIC_VECTOR(15 downto 0));
END tank;


ARCHITECTURE fsm_t OF tank IS
	TYPE state IS (idle,f0,f1,f2,b0,b1,b2);
	SIGNAL current,nex : state;
	SIGNAL x, x_c : std_logic_vector(15 downto 0);
begin
statereg : process(reset,clk, direction) is
begin
	if(reset='1')then
		current<=idle;
		x<=std_logic_vector(to_signed(320,16));
		pos_x<= std_logic_vector(to_signed(320,16));
		if (direction='0')then
			pos_y<= std_logic_vector(to_signed(50,16));
		else
			pos_y<= std_logic_vector(to_signed(420,16));
		end if;
		
	elsif (rising_edge(clk))then
		if (direction='0')then
			pos_y<= std_logic_vector(to_signed(50,16));
		else
			pos_y<= std_logic_vector(to_signed(420,16));
		end if;
		current<=nex;
		pos_x<=x_c;
		x<=x_c; 
	end if;
end process statereg;

statelogic : process(x,start,current,update,speed,direction) is
begin
	nex<=current;
	x_c<=x;
	case(current)is
		when idle=>
			if (start='1')then
				if(direction='0')then
					if(speed="00")then
						nex<=b0;
					elsif (speed="01")then
						nex<=b1;
					else
						nex<=b2;
					end if;
				else
					if(speed="00")then
						nex<=f0;
					elsif (speed="01")then
						nex<=f1;
					else
						nex<=f2;
					end if;
				end if;
			end if;
		when f0=>
			if (update = '1')then
				x_c<=std_logic_vector(resize(signed(x)+to_signed(1,16),16));
				if(signed(x)>620)then
					if(speed="00")then
						nex<=b0;
					elsif (speed="01")then
						nex<=b1;
					else
						nex<=b2;
					end if;
					
				else
					if(speed="00")then
						nex<=f0;
					elsif (speed="01")then
						nex<=f1;
					else
						nex<=f2;
					end if;
				end if;
			end if;
		
		when f1=>
			if (update = '1')then
				x_c<=std_logic_vector(resize(signed(x)+to_signed(2,16),16));
				if(signed(x)>620)then
					if(speed="00")then
						nex<=b0;
					elsif (speed="01")then
						nex<=b1;
					else
						nex<=b2;
					end if;
					
				else
					if(speed="00")then
						nex<=f0;
					elsif (speed="01")then
						nex<=f1;
					else
						nex<=f2;
					end if;
				end if;
			end if;
		
		when f2=>
			if (update = '1')then
				x_c<=std_logic_vector(resize(signed(x)+to_signed(3,16),16));
				if(signed(x)>620)then
					if(speed="00")then
						nex<=b0;
					elsif (speed="01")then
						nex<=b1;
					else
						nex<=b2;
					end if;
					
				else
					if(speed="00")then
						nex<=f0;
					elsif (speed="01")then
						nex<=f1;
					else
						nex<=f2;
					end if;
				end if;
			end if;
		when b0=>
			if (update = '1')then
				x_c<=std_logic_vector(resize(signed(x)-to_signed(1,16),16));
				if(signed(x)<40)then
					if(speed="00")then
						nex<=f0;
					elsif (speed="01")then
						nex<=f1;
					else
						nex<=f2;
					end if;
					
				else
					if(speed="00")then
						nex<=b0;
					elsif (speed="01")then
						nex<=b1;
					else
						nex<=b2;
					end if;
				end if;
			end if;
			
		when b1=>
			if (update = '1')then
				x_c<=std_logic_vector(resize(signed(x)-to_signed(2,16),16));
				if(signed(x)<40)then
					if(speed="00")then
						nex<=f0;
					elsif (speed="01")then
						nex<=f1;
					else
						nex<=f2;
					end if;
					
				else
					if(speed="00")then
						nex<=b0;
					elsif (speed="01")then
						nex<=b1;
					else
						nex<=b2;
					end if;
				end if;
			end if;
		when b2=>
			if (update = '1')then
				x_c<=std_logic_vector(resize(signed(x)-to_signed(3,16),16));
				if(signed(x)<40)then
					if(speed="00")then
						nex<=f0;
					elsif (speed="01")then
						nex<=f1;
					else
						nex<=f2;      
					end if;
				else
					if(speed="00")then
						nex<=b0;
					elsif (speed="01")then
						nex<=b1;
					else
						nex<=b2;
					end if;
				end if;
			end if;
		end case;
end process statelogic;			
END fsm_t;