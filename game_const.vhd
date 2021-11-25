library IEEE;
use IEEE.std_logic_1164.all;
--Additional standard or custom libraries go here
package game_const is
constant  TANK_WIDTH : integer :=60;
constant BULLET_WIDTH : integer := 16;
constant TANK_HEIGHT : integer := 40;
constant BULLET_HEIGHT : integer := 30;

constant coord_length : integer := 16;

end package game_const;
package body game_const is
--Subroutine declarations go here
-- you will not have any need for it now, this package is only for defining -
-- some useful constants
end package body game_const;