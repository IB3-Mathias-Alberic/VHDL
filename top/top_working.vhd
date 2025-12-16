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
        -- directions
        dir_M : in std_logic; -- master direction
        dir_1 : out std_logic;
        dir_2 : out std_logic;
        dir_3 : out std_logic;
        dir_4 : out std_logic;
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
    
    -- motor direction signals from controller
    signal d_1, d_2, d_3, d_4 : std_logic;

    
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
            d_1 : out std_logic;
            d_2 : out std_logic;
            d_3 : out std_logic;
            d_4 : out std_logic
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
            d_1 => d_1,
            d_2 => d_2,
            d_3 => d_3,
            d_4 => d_4
        );
    
    pwm_inst : pwm
        port map (
            clk => clk,
            rst => rst,
            pwm => pwm_in,
            pwm_out => pwm_m
        );
    
    dir_1 <= d_1 xor dir_M;
    dir_2 <= d_2 xor dir_M;
    dir_3 <= d_3 xor dir_M;
    dir_4 <= d_4 xor dir_M;
    
    -- LED array voor debugging (toont huidige rx_data)
    leds <= rx_data;

end architecture structural;