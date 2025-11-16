library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    port (
        clk : in std_logic;
        rst : in std_logic;
        -- pwm waarden
        snelheid : in unsigned(7 downto 0);
        richting : in std_logic;
        -- singaal
        pwm_out : out std_logic
    );
end pwm;

architecture rtl of pwm is

begin

end architecture;