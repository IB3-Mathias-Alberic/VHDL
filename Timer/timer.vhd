library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Generic (
        CLK_FREQ : integer := 50000000
    );
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        button : in STD_LOGIC;
        output : out STD_LOGIC
    );
end timer;

architecture Behavioral of timer is
    constant COUNT_MAX : integer := CLK_FREQ * 2;
    signal counter : integer range 0 to COUNT_MAX := 0;
    signal timer_active : std_logic := '0';
    signal button_prev : std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            timer_active <= '0';
            button_prev <= '0';
            output <= '0';
        elsif rising_edge(clk) then
            button_prev <= button;
            if button = '1' and button_prev = '0' then
                timer_active <= '1';
                counter <= 0;
                output <= '1';
            elsif timer_active = '1' then
                if counter < COUNT_MAX - 1 then
                    counter <= counter + 1;
                    output <= '1';
                else
                    timer_active <= '0';
                    counter <= 0;
                    output <= '0';
                end if;
            else
                output <= '0';
            end if;
        end if;
    end process;
end Behavioral;