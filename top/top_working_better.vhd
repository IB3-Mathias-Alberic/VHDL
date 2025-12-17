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
        clk : in std_logic; -- w5
        rst : in std_logic; -- t18
        -- UART input
        rx : in std_logic; -- b18
        -- PWM
        pwm_in : in unsigned(7 downto 0); -- find space
        pwwm_out : out std_logic; -- like this 
        --pwm_out_1 : out std_logic; or distriibuted
        --pwm_out_2 : out std_logic; 
        --pwm_out_3 : out std_logic; 
        --pwm_out_4 : out std_logic; 


        -- ena
        ena_front : out std_logic; -- choose port
        ena_rear : out std_logic; -- choose port
        -- directions (2 bits each)
        dir_M : in std_logic; -- master direction, choose
        dir_1 : out std_logic_vector(1 downto 0); -- choose all dir ports
        dir_2 : out std_logic_vector(1 downto 0);
        dir_3 : out std_logic_vector(1 downto 0);
        dir_4 : out std_logic_vector(1 downto 0);
        -- LEDs
        leds : out std_logic_vector(7 downto 0) -- leds v14 - u16
    );
end top;

architecture structural of top is
    
    -- UART signals
    signal rx_data : std_logic_vector(7 downto 0);
    signal rx_valid : std_logic;
    
    -- motor direction signals
    signal d_1_top, d_2_top, d_3_top, d_4_top : std_logic;
    signal ena_1_top, ena_2_top, ena_3_top, ena_4_top : std_logic;  

    
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
            ena_1 => ena_1_top,
            ena_2 => ena_2_top,
            ena_3 => ena_3_top,
            ena_4 => ena_4_top,
            d_1 => d_1_top,
            d_2 => d_2_top,
            d_3 => d_3_top,
            d_4 => d_4_top
        );
    
    pwm_front_inst : pwm
        port map (
            clk => clk,
            rst => rst,
            pwm => pwm_in,
            pwm_out => pwm_front
        );
    
    pwm_rear_inst : pwm
        port map (
            clk => clk,
            rst => rst,
            pwm => pwm_in,
            pwm_out => pwm_rear
        );
    
    -- master inverts direction
    dir_1 <= d_1_top & (not d_1_top);
    dir_2 <= d_2_top & (not d_2_top);
    dir_3 <= d_3_top & (not d_3_top);
    dir_4 <= d_4_top & (not d_4_top);
    
    -- Gate PWM outputs with enable signals
    ena_front <= ena_1_top and ena_2_top;
    ena_rear <= ena_3_top and ena_4_top;
    
    -- LED array voor debugging (toont huidige rx_data)
    leds <= rx_data;

end architecture structural;