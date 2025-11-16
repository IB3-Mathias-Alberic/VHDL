library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    port (
        clk : in std_logic;
        rst : in std_logic;
        -- pwm variables
        v : in unsigned(7 downto 0); -- velocity
        dir : in std_logic; -- direction: 0 forwards, 1 backwards
        -- output
        pwm_out : out std_logic
    );
end pwm;

architecture rtl of pwm is
    signal ctr : unsigned(7 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ctr <= (others => '0');
                pwm_out <= '0';
            end if;
        end if;

end architecture;