library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_parser is
    port (
        -- standard
        clk : in std_logic;
        rst : in std_logic;
        -- input = uart via RPi
        d_in : in std_logic;
        -- motor PWM outputs
        v_1 : out std_logic;    
        v_2 : out std_logic;
        v_3 : out std_logic;
        v_4 : out std_logic;
        -- motor directions
        d_1 : out std_logic;    
        d_2 : out std_logic;
        d_3 : out std_logic;
        d_4 : out std_logic;
        );
end UART_parser;

architecture rtl of UART_parser is

begin

end architecture;
