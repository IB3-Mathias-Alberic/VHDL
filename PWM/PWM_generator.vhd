library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    generic (
        DEADZONE : integer := 10 -- set 15 as minimum in the app
    );

    port (
        -- standard
        clk : in std_logic;
        rst : in std_logic;
        -- pwm variables
        pwm : in unsigned(7 downto 0); -- velocity 0-255
        -- output
        pwm_out : out std_logic
    );
end pwm;

architecture pwm_architecture of pwm is
    signal ctr : unsigned(7 downto 0);
    signal pwm_invalid : boolean  := false; 

begin
    pwm_invalid <= (pwm < DEADZONE); 

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then -- rst resets
                ctr <= (others => '0');
                pwm_out <= '0';
            elsif pwm_invalid then
                pwm_out <=  '0';  -- PWM too low
            else
                ctr <= ctr + 1;
                    if ctr < pwm then
                        pwm_out <= '1';
                    else
                        pwm_out <= '0';
                    end if;
            end if;
        end if;
    end process;
end architecture;
