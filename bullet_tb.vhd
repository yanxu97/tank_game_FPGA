LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY bullet_tb IS
    PORT (
        tb_xb, tb_yb       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        tb_hit_h, tb_hit_l : OUT STD_LOGIC;
        tb_display_en      : OUT STD_LOGIC
    );
END bullet_tb;

ARCHITECTURE test OF bullet_tb IS
    COMPONENT bullet IS
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
    END COMPONENT;

    SIGNAL tb_reset, tb_start, tb_clk_s, tb_clk_f : STD_LOGIC;
    SIGNAL tb_fire                                : STD_LOGIC;
    SIGNAL tb_direction                           : STD_LOGIC;
    SIGNAL tb_xt_h, tb_yt_h, tb_xt_l, tb_yt_l     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL hold_clock                             : STD_LOGIC;

    -- CONSTANT clk_period_s : TIME := 20000000 ns; -- 0.02s
    CONSTANT clk_period_s : TIME := 200 ns; -- 0.02s
    CONSTANT clk_period_f : TIME := 20 ns;

BEGIN
    dut : bullet PORT MAP(tb_reset, tb_start, tb_clk_s, tb_clk_f, tb_fire, tb_direction, tb_xt_h, tb_yt_h, tb_xt_l, tb_yt_l, tb_xb, tb_yb, tb_hit_h, tb_hit_l, tb_display_en);

    clock_process_s : PROCESS
    BEGIN
        tb_clk_s <= '0';
        WAIT FOR clk_period_s/2; --for 0.02 s signal is '0'.
        tb_clk_s <= '1';
        WAIT FOR clk_period_s/2; --for next 0.02 s signal is '1'.
        IF (hold_clock = '1') THEN
            WAIT;
        END IF;
    END PROCESS clock_process_s;

    clock_process_f : PROCESS
    BEGIN
        tb_clk_f <= '0';
        WAIT FOR clk_period_f/2; --for 10 ns signal is '0'.
        tb_clk_f <= '1';
        WAIT FOR clk_period_f/2; --for next 10 ns signal is '1'.
        IF (hold_clock = '1') THEN
            WAIT;
        END IF;
    END PROCESS clock_process_f;

    reset_process : PROCESS IS
    BEGIN
        tb_reset <= '0';
        WAIT FOR clk_period_f;
        tb_reset <= '1';
        WAIT FOR clk_period_f;
        tb_reset <= '0';
        WAIT;
    END PROCESS reset_process;

    testing : PROCESS IS
    BEGIN
        tb_start <= '0';
        WAIT FOR clk_period_f * 4;
        hold_clock   <= '0';
        tb_start     <= '1';
        tb_direction <= '0';
        tb_xt_h      <= STD_LOGIC_VECTOR(to_unsigned(320, 16));
        tb_yt_h      <= STD_LOGIC_VECTOR(to_unsigned(20, 16));
        tb_xt_l      <= STD_LOGIC_VECTOR(to_unsigned(320, 16));
        tb_yt_l      <= STD_LOGIC_VECTOR(to_unsigned(460, 16));
        tb_fire      <= '1';

        WAIT FOR clk_period_f * 2;
        tb_fire  <= '0';
        tb_start <= '0';

        WAIT FOR clk_period_s * 50;
        hold_clock <= '1';

        WAIT;

    END PROCESS testing;

END ARCHITECTURE test;