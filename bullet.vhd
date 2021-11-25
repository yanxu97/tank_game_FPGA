LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE WORK.game_const.ALL;

ENTITY bullet IS
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
END bullet;

ARCHITECTURE fsm_bullet OF bullet IS
    COMPONENT collision IS
        PORT (
            reset, start, clk, fire : IN STD_LOGIC;
            xb, yb, xt, yt          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            collision               : OUT STD_LOGIC
        );
    END COMPONENT collision;

    TYPE state IS (idle_1, idle_2, in_air_upward_1, in_air_upward_2, in_air_downward_1, in_air_downward_2);
    SIGNAL curr_st, next_st : state;

    SIGNAL xb_c         : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL yb_C         : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL hit_h_c      : STD_LOGIC;
    SIGNAL hit_l_c      : STD_LOGIC;
    SIGNAL display_en_c : STD_LOGIC;

    SIGNAL xb_q         : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL yb_q         : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL hit_h_q      : STD_LOGIC;
    SIGNAL hit_l_q      : STD_LOGIC;
    SIGNAL display_en_q : STD_LOGIC;

    SIGNAL collision_h : STD_LOGIC;
    SIGNAL collision_l : STD_LOGIC;

    SIGNAL bullet_ready : INTEGER := 0;
BEGIN

    collision_h_case : collision PORT MAP(reset, start, clk_f, display_en_q, xb_q, yb_q, xt_h, yt_h, collision_h);
    collision_l_case : collision PORT MAP(reset, start, clk_f, display_en_q, xb_q, yb_q, xt_l, yt_l, collision_l);

    -- update enable signals
    clock_process_f : PROCESS (clk_f, reset) IS
    BEGIN
        IF (reset = '1') THEN
            curr_st      <= idle_1;
            xb_q         <= (OTHERS => '0');
            yb_q         <= (OTHERS => '0');
            hit_h_q      <= '0';
            hit_l_q      <= '0';
            display_en_q <= '0';
        ELSIF (rising_edge(clk_f)) THEN
            curr_st      <= next_st;
            xb_q         <= xb_c;
            yb_q         <= yb_c;
            hit_h_q      <= hit_h_c;
            hit_l_q      <= hit_l_c;
            display_en_q <= display_en_c;
            -- update position
        END IF;
    END PROCESS clock_process_f;

    -- synchronous 
    comb_process : PROCESS (fire, start, direction, display_en_q, yb_q, collision_h, collision_l) IS
    BEGIN
        next_st      <= curr_st;
        xb_c         <= xb_q;
        yb_c         <= yb_q;
        hit_h_c      <= '0';
        hit_l_c      <= '0';
        display_en_c <= '0';

        CASE (curr_st) IS
            WHEN idle_1 =>
                next_st      <= idle_1;
                display_en_c <= '0';
                bullet_ready <= 0;
                IF (start = '1') THEN
                    IF (fire = '1') THEN
                        IF (direction = '1') THEN
                            next_st <= in_air_upward_1;
                        ELSE
                            next_st <= in_air_downward_1;
                        END IF;
                    END IF;
                END IF;

            WHEN idle_2 =>
                next_st      <= idle_2;
                display_en_c <= '0';
                bullet_ready <= 0;
                IF (fire = '1') THEN
                    IF (direction = '1') THEN
                        next_st <= in_air_upward_1;
                    ELSE
                        next_st <= in_air_downward_1;
                    END IF;
                END IF;

            WHEN in_air_upward_1 =>
                next_st      <= in_air_upward_2;
                display_en_c <= '1';
                xb_c         <= xt_l;
                yb_c         <= STD_LOGIC_VECTOR(to_unsigned(to_integer(signed(yt_l)) - 20, coord_length));

            WHEN in_air_upward_2 =>
                display_en_c <= '1';

                IF (display_en_q = '1') THEN
                    IF (collision_h = '1') THEN
                        next_st      <= idle_2;
                        display_en_c <= '0';
								hit_h_c<='1';
                    ELSIF (to_integer(signed(yb_q)) < 3) THEN
                        next_st      <= idle_2;
                        display_en_c <= '0';
                    END IF;
                END IF;
					 if (clk_s='1')then
						yb_c <= STD_LOGIC_VECTOR(to_unsigned(to_integer(signed(yb_q)) - 1, coord_length));
					end if;
	
            WHEN in_air_downward_1 =>
                next_st      <= in_air_downward_2;
                display_en_c <= '1';
                xb_c         <= xt_h;
                yb_c         <= STD_LOGIC_VECTOR(to_unsigned(to_integer(signed(yt_h)) + 20, coord_length));

            WHEN in_air_downward_2 =>
                display_en_c <= '1';

                IF (display_en_q = '1') THEN
                    IF (collision_l = '1') THEN
                        next_st      <= idle_2;
                        display_en_c <= '0';
								hit_l_c<='1';
                    ELSIF (to_integer(signed(yb_q)) > 477) THEN
                        next_st      <= idle_2;
                        display_en_c <= '0';
                    END IF;
                END IF;
					 if (clk_s='1')then
						yb_c <= STD_LOGIC_VECTOR(to_unsigned(to_integer(signed(yb_q)) + 1, coord_length));
					 end if;
	
        END CASE;
    END PROCESS comb_process;

    xb         <= xb_q;
    yb         <= yb_q;
    hit_h      <= hit_h_q;
    hit_l      <= hit_l_q;
    display_en <= display_en_q;

END ARCHITECTURE fsm_bullet;