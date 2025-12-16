
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    generic (
        f_clk    : integer := 100_000_000;  -- 100 MHz
        baudrate : integer := 9600
    );
    port (
        -- standard
        clk : in std_logic;
        rst : in std_logic;
        -- UART input
        rx : in std_logic;
        -- PWM in
        pwm_in : in unsigned(7 downto 0);
        -- PWM out
        pwm_m : out std_logic;
        -- master direction
        dir_M : in std_logic;
        -- motor directions (2-bit: CW and CCW)
        dir_1 : out std_logic_vector(1 downto 0);
        dir_2 : out std_logic_vector(1 downto 0);
        dir_3 : out std_logic_vector(1 downto 0);
        dir_4 : out std_logic_vector(1 downto 0);
        -- LEDs
        leds : out std_logic_vector(7 downto 0)
    );
end top;

architecture structural of top is
    
    -- UART signals
    signal rx_data : std_logic_vector(7 downto 0);
    signal rx_valid : std_logic;
    
    -- motor enable signals from controller
    signal ena_1, ena_2, ena_3, ena_4 : std_logic;
    
    -- motor direction signals from controller (internal)
    signal cw1_int, ccw1_int : std_logic;
    signal cw2_int, ccw2_int : std_logic;
    signal cw3_int, ccw3_int : std_logic;
    signal cw4_int, ccw4_int : std_logic;
    
    component UART_Rx is
        generic (
            f_clk : integer;
            baudrate : integer
        );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            rx : in  std_logic;
            d_out : out std_logic_vector(7 downto 0);
            d_valid : out std_logic
        );
    end component;
    
    component pwm is
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            pwm : in  unsigned(7 downto 0);
            pwm_out : out std_logic
        );
    end component;
    
    component controller is
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            rx_data : in  std_logic_vector(7 downto 0);
            rx_valid : in  std_logic;
            ena_1 : out std_logic;
            ena_2 : out std_logic;
            ena_3 : out std_logic;
            ena_4 : out std_logic;
            cw_1 : out std_logic;
            ccw_1 : out std_logic;
            cw_2 : out std_logic;
            ccw_2 : out std_logic;
            cw_3 : out std_logic;
            ccw_3 : out std_logic;
            cw_4 : out std_logic;
            ccw_4 : out std_logic
        );
    end component;
    
begin
    
    uart_rx_inst : UART_Rx
        generic map (
            f_clk => f_clk,
            baudrate => baudrate
        )
        port map (
            clk  => clk,
            rst => rst,
            rx => rx,
            d_out => rx_data,
            d_valid => rx_valid
        );
    
    controller_inst : controller
        port map (
            clk => clk,
            rst => rst,
            rx_data => rx_data,
            rx_valid => rx_valid,
            ena_1 => ena_1,
            ena_2 => ena_2,
            ena_3 => ena_3,
            ena_4 => ena_4,
            cw_1 => cw1_int,
            ccw_1 => ccw1_int,
            cw_2 => cw2_int,
            ccw_2 => ccw2_int,
            cw_3 => cw3_int,
            ccw_3 => ccw3_int,
            cw_4 => cw4_int,
            ccw_4 => ccw4_int
        );
    
    pwm_inst : pwm
        port map (
            clk => clk,
            rst => rst,
            pwm => pwm_in,
            pwm_out => pwm_m
        );
    
    -- Direction logic with master direction inversion
    -- dir(1) = CW, dir(0) = CCW
    -- When dir_M = '1', swap CW and CCW
    dir_1(1) <= cw1_int when dir_M = '0' else ccw1_int;
    dir_1(0) <= ccw1_int when dir_M = '0' else cw1_int;
    
    dir_2(1) <= cw2_int when dir_M = '0' else ccw2_int;
    dir_2(0) <= ccw2_int when dir_M = '0' else cw2_int;
    
    dir_3(1) <= cw3_int when dir_M = '0' else ccw3_int;
    dir_3(0) <= ccw3_int when dir_M = '0' else cw3_int;
    
    dir_4(1) <= cw4_int when dir_M = '0' else ccw4_int;
    dir_4(0) <= ccw4_int when dir_M = '0' else cw4_int;
    
    -- LED debugging output
    leds <= rx_data;
    
end architecture structural;