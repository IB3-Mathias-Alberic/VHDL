library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port (
        -- standard
        clk : in std_logic;
        rst : in std_logic;
        
        -- input = uart via RPi
        rx_data : in std_logic_vector(7 downto 0);
        rx_valid : in std_logic;
        
        -- motor PWM speed
        ena_front : out std_logic;
        ena_rear : out std_logic;
        
        -- motor directions (2-bit: CW, CCW)
        dir_1 : out std_logic_vector(1 downto 0);
        dir_2 : out std_logic_vector(1 downto 0);
        dir_3 : out std_logic_vector(1 downto 0);
        dir_4 : out std_logic_vector(1 downto 0)
    );
end controller;

architecture rtl of controller is
    -- movements
    constant Y : std_logic_vector(2 downto 0) := "000"; --F/B
    constant X : std_logic_vector(2 downto 0) := "001"; -- L/R
    constant XY : std_logic_vector(2 downto 0) := "010"; -- y = x
    constant YX : std_logic_vector(2 downto 0) := "011"; -- y = -x
    constant DX : std_logic_vector(2 downto 0) := "100"; -- turn about 0,y
    constant DY : std_logic_vector(2 downto 0) := "101"; -- turn about x,0
    constant D : std_logic_vector(2 downto 0) := "110"; -- turn
    constant STILL : std_logic_vector(2 downto 0) := "111"; -- stop, only in array mode
    
    -- direction constants
    constant DIR_CW : std_logic_vector(1 downto 0) := "10";
    constant DIR_CCW : std_logic_vector(1 downto 0) := "01";
    constant DIR_STOP : std_logic_vector(1 downto 0) := "00";
    
    -- UART signals
    signal rx_cmd : std_logic_vector(2 downto 0);
    
    -- motor control signals
    signal ena_F, ena_R : std_logic;
    signal dir1, dir2, dir3, dir4 : std_logic_vector(1 downto 0);
    
    -- motor layout
    -- FL(1)FR(2)
    -- BL(3)BR(4)
    
begin
    -- only take last two bits for command parsing
    rx_cmd <= rx_data(2 downto 0);
    
    -- controller
    process(clk, rst)
    begin
        if rst = '1' then
            ena_F <= '0';
            ena_R <= '0';
            dir1 <= DIR_STOP;
            dir2 <= DIR_STOP;
            dir3 <= DIR_STOP;
            dir4 <= DIR_STOP;
        elsif rising_edge(clk) then
            if rx_valid = '1' then
                case rx_cmd is
                    when Y =>
                        ena_F <= '1';
                        ena_R <= '1';
                        dir1 <= DIR_CW;
                        dir2 <= DIR_CW;
                        dir3 <= DIR_CW;
                        dir4 <= DIR_CW;
                    
                    when X =>
                        ena_F <= '1'; 
                        ena_R <= '1'; 
                        dir1 <= DIR_CW;
                        dir2 <= DIR_CCW;
                        dir3 <= DIR_CCW;
                        dir4 <= DIR_CW;
                    
                    when XY =>
                        ena_F <= '1'; 
                        ena_R <= '1'; 
                        dir1 <= DIR_CW;
                        dir2 <= DIR_CCW;
                        dir3 <= DIR_CCW;
                        dir4 <= DIR_CW;
                    
                    when YX =>
                        ena_F <= '1'; 
                        ena_R <= '1'; 
                        dir1 <= DIR_CCW;
                        dir2 <= DIR_CW;
                        dir3 <= DIR_CW;
                        dir4 <= DIR_CCW;
                    
                    when DX =>
                        ena_F <= '1'; 
                        ena_R <= '1'; 
                        dir1 <= DIR_CW;
                        dir2 <= DIR_CCW;
                        dir3 <= DIR_STOP;
                        dir4 <= DIR_STOP;
                    
                    when DY =>
                        ena_F <= '0'; 
                        ena_R <= '0'; 
                        dir1 <= DIR_STOP;
                        dir2 <= DIR_STOP;
                        dir3 <= DIR_CW;
                        dir4 <= DIR_CCW;
                    
                    when D =>
                        ena_F <= '1'; 
                        ena_R <= '1'; 
                        dir1 <= DIR_CW;
                        dir2 <= DIR_CCW;
                        dir3 <= DIR_CW;
                        dir4 <= DIR_CCW;
                    
                    when STILL =>
                        ena_F <= '0';
                        ena_R <= '0';
                        dir1 <= DIR_STOP; 
                        dir2 <= DIR_STOP;
                        dir3 <= DIR_STOP;
                        dir4 <= DIR_STOP;
                    
                    when others =>
                        null; --keep state
                end case;
            end if;
        end if;
    end process;
    
    ena_front <= ena_F;
    ena_rear <= ena_R;
    
    dir_1 <= dir1;
    dir_2 <= dir2;
    dir_3 <= dir3;
    dir_4 <= dir4;
    
end architecture rtl;