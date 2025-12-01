library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_parser is
    generic(
        CLK_FREQ : integer := 50_000_000;
        BAUD_RATE : integer := 9600
    );
    port (
        -- standard
        clk : in std_logic;
        rst : in std_logic;
        -- input = uart via RPi
        d_in : in std_logic;
        -- motor PWM speed
        v_1 : out std_logic;    
        v_2 : out std_logic;
        v_3 : out std_logic;
        v_4 : out std_logic;
        -- motor directions
        d_1 : out std_logic;    
        d_2 : out std_logic;
        d_3 : out std_logic;
        d_4 : out std_logic
    );
end UART_parser;

architecture rtl of UART_parser is
    component UART_rx is
        generic(
            CLK_FREQ : integer;
            BAUD_RATE : integer
        );
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            rx : in  std_logic;
            rx_data : out std_logic_vector(7 downto 0);
            rx_valid : out std_logic
        );
    end component;
    
    --commands
    constant CMD_FORWARD : std_logic_vector(7 downto 0) := x"46"; -- 'F'
    constant CMD_BACKWARD : std_logic_vector(7 downto 0) := x"42"; -- 'B'
    constant CMD_LEFT : std_logic_vector(7 downto 0) := x"4C"; -- 'L'
    constant CMD_RIGHT : std_logic_vector(7 downto 0) := x"52"; -- 'R'
    constant CMD_STOP : std_logic_vector(7 downto 0) := x"53"; -- 'S'
    
    -- UART signals
    signal rx_data  : std_logic_vector(7 downto 0);
    signal rx_valid : std_logic;
    
    -- Motor control signals
    signal ena1 : std_logic := '0';
    signal motor2 : std_logic := '0';
    signal ena3 : std_logic := '0';
    signal ena4 : std_logic := '0';
    signal motor1_dir : std_logic := '0';
    signal motor2_dir : std_logic := '0';
    signal motor3_dir : std_logic := '0';
    signal motor4_dir : std_logic := '0';
    
begin
    -- UART rx instance
    uart_receiver : UART_RX
        generic map(
            CLK_FREQ  => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        )
        port map(
            clk => clk,
            rst => rst,
            rx => d_in,
            rx_data => rx_data,
            rx_valid => rx_valid
        );
    
    v_1 <= ena1;
    v_2 <= ena2;
    v_3 <= ena3;
    v_4 <= ena4;
    d_1 <= dir1;
    d_2 <= dir2;
    d_3 <= dir3;
    d_4 <= dir4;
    
    -- cmd parser process
    process(clk, rst)
    begin
        if rst = '1' then
            ena1 <= '0';
            ena2 <= '0';
            ena3 <= '0';
            ena4 <= '0';
            dir1 <= '0';
            dir2 <= '0';
            dir3 <= '0';
            dir4 <= '0';
            
        elsif rising_edge(clk) then
            if rx_valid = '1' then
                case rx_data is
                    when CMD_FORWARD =>
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '1'; 
                        dir3 <= '1'; 
                        dir4 <= '1'; 
                        
                    when CMD_BACKWARD =>
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '0'; 
                        dir2 <= '0'; 
                        dir3 <= '0'; 
                        dir4 <= '0'; 
                        
                    when CMD_LEFT =>
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '0';
                        dir2 <= '1'; 
                        dir3 <= '0';
                        dir4 <= '1'; 
                        
                    when CMD_RIGHT =>
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1';  
                        dir2 <= '0';  
                        dir3 <= '1'; 
                        dir4 <= '0'; 
                        
                    when CMD_STOP =>
                        ena1 <= '0';
                        ena2 <= '0';
                        ena3 <= '0';
                        ena4 <= '0';
                        dir1 <= '0';
                        dir2 <= '0';
                        dir3 <= '0';
                        dir4 <= '0';
                        
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
end architecture rtl;