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
    signal ena_front, ena_rear : std_logic;
    
    -- motor direction signals from controller (internal as vectors)
    signal dir1_int, dir2_int, dir3_int, dir4_int : std_logic_vector(1 downto 0);
    
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
            ena_front : out std_logic;
            ena_rear : out std_logic;
            dir_1 : out std_logic_vector(1 downto 0);
            dir_2 : out std_logic_vector(1 downto 0);
            dir_3 : out std_logic_vector(1 downto 0);
            dir_4 : out std_logic_vector(1 downto 0)
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
            ena_front => ena_front,
            ena_rear => ena_rear,
            dir_1 => dir1_int,
            dir_2 => dir2_int,
            dir_3 => dir3_int,
            dir_4 => dir4_int
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
    -- When dir_M = '1', swap CW and CCW bits
    dir_1 <= dir1_int(0) & dir1_int(1) when dir_M = '1' else dir1_int;
    dir_2 <= dir2_int(0) & dir2_int(1) when dir_M = '1' else dir2_int;
    dir_3 <= dir3_int(0) & dir3_int(1) when dir_M = '1' else dir3_int;
    dir_4 <= dir4_int(0) & dir4_int(1) when dir_M = '1' else dir4_int;
    
    -- LED debugging output
    leds <= rx_data;
    
end architecture structural;