library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_parser is
    generic(
        f_clk : integer := 50_000_000;
        BAUD : integer := 9600
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
            f_clk : integer;
            baudrate : integer
        );
        port(
             clk : in  std_logic;
             rst : in  std_logic;
             -- bits in
             rx : in  std_logic;
             -- received signals
             d_out : out std_logic_vector(7 downto 0);
             d_valid : out std_logic
        );
    end component;
    
    --commands
    constant Y : integer := 0; -- forward, backward
    constant X : integer := 1; -- L, R
    constant XY : integer := 2; -- y = x
    constant YX : integer := 3; -- y = -x
    constant DX : integer := 4; -- turn with cot on x = 0
    constant DY : integer := 5; -- turn with cot on y = 0
    constant D : integer := 6; -- turn about 0,0

    -- UART signals
    signal rx_data  : std_logic_vector(7 downto 0);
    signal rx_valid : std_logic;
    
    -- Motor control signals
    signal ena1 : std_logic := '0';
    signal ena2 : std_logic := '0';
    signal ena3 : std_logic := '0';
    signal ena4 : std_logic := '0';
    signal dir1 : std_logic := '0';
    signal dir2 : std_logic := '0';
    signal dir3 : std_logic := '0';
    signal dir4 : std_logic := '0';
    
begin
    -- UART rx instance
    uart_receiver : UART_RX
        generic map(
            f_clk  => f_clk,
            baudrate => BAUD
        );
        port map(
            clk => clk,
            rst => rst,
            rx => d_in,
            d_out => rx_data,
            d_valid => rx_valid
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

                    -- VERANDER DE RICHTINGEN EN ENAS NOG
                    when Y => -- alles aan 
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '1'; 
                        dir3 <= '1'; 
                        dir4 <= '1'; 
                        
                    when X =>
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '0'; 
                        dir3 <= '0'; 
                        dir4 <= '1'; 
                        
                    when XY => -- alles aan 
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '1'; 
                        dir3 <= '1'; 
                        dir4 <= '1'; 

                    when YX => -- alles aan 
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '1'; 
                        dir3 <= '1'; 
                        dir4 <= '1'; 
                    when DY => -- alles aan 
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '1'; 
                        dir3 <= '1'; 
                        dir4 <= '1'; 
                        
                    when DX => -- alles aan 
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '1'; 
                        dir3 <= '1'; 
                        dir4 <= '1'; 
                        
                    when D => -- alles aan 
                        ena1 <= '1';
                        ena2 <= '1';
                        ena3 <= '1';
                        ena4 <= '1';
                        dir1 <= '1'; 
                        dir2 <= '1'; 
                        dir3 <= '1'; 
                        dir4 <= '1';     
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
end architecture rtl;