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
        ena_1 : out std_logic;    
        ena_2 : out std_logic;
        ena_3 : out std_logic;
        ena_4 : out std_logic;
        -- motor directions
        d_1 : out std_logic;    
        d_2 : out std_logic;
        d_3 : out std_logic;
        d_4 : out std_logic
        
    );
end controller;

architecture rtl of controller is
    
    constant Y : std_logic_vector(2 downto 0) := "001"; --F/B
    constant X : std_logic_vector(2 downto 0) := "010"; -- L/R
    constant XY : std_logic_vector(2 downto 0) := "011"; -- y = x
    constant YX : std_logic_vector(2 downto 0) := "100"; -- y = -x
    constant D : std_logic_vector(2 downto 0) := "101"; -- turn
    constant STILL : std_logic_vector(2 downto 0) := "000";

    -- UART signals
    signal rx_cmd : std_logic_vector(2 downto 0);
    
    -- motor control signals
    signal ena1, ena2, ena3, ena4 : std_logic;
    signal dir1, dir2, dir3, dir4 : std_logic;
    
    -- motor layout
    --   FL(1)FR(2)
    --   BL(3)BR(4)
    
begin
    
    -- extract command from UART data
    rx_cmd <= rx_data(2 downto 0);
    
    -- controller
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
                case rx_cmd is
                    -- Y: Forward/Backward - all wheels same direction
                    when Y =>
                        ena1 <= '1'; dir1 <= '0';
                        ena2 <= '1'; dir2 <= '0';
                        ena3 <= '1'; dir3 <= '0';
                        ena4 <= '1'; dir4 <= '0';
                    
                    -- X: Strafe Left/Right
                    -- FL(1) and BR(4) same direction
                    -- FR(2) and BL(3) opposite direction
                    when X =>
                        ena1 <= '1'; dir1 <= '0'; 
                        ena2 <= '1'; dir2 <= '1';  
                        ena3 <= '1'; dir3 <= '1';  
                        ena4 <= '1'; dir4 <= '0'; 
                    
                    -- XY: Diagonal (forward-right / back-left)
                    -- Only FR(2) and BL(3) active
                    when XY =>
                        ena1 <= '0'; dir1 <= '0'; 
                        ena2 <= '1'; dir2 <= '0'; 
                        ena3 <= '1'; dir3 <= '0';  
                        ena4 <= '0'; dir4 <= '0';  
                    
                    -- YX: Diagonal (forward-left / back-right)
                    -- Only FL(1) and BR(4) active
                    when YX =>
                        ena1 <= '1'; dir1 <= '0'; 
                        ena2 <= '0'; dir2 <= '0'; 
                        ena3 <= '0'; dir3 <= '0';  
                        ena4 <= '1'; dir4 <= '0';  
            
                    -- D: Rotate in place
                    -- Left side (1,3) one direction, Right side (2,4) opposite
                    when D =>
                        ena1 <= '1'; dir1 <= '0'; 
                        ena2 <= '1'; dir2 <= '1'; 
                        ena3 <= '1'; dir3 <= '0';  
                        ena4 <= '1'; dir4 <= '1';  
                    
                    -- STILL: All motors off
                    when STILL =>
                        ena1 <= '0'; dir1 <= '0';
                        ena2 <= '0'; dir2 <= '0';
                        ena3 <= '0'; dir3 <= '0';
                        ena4 <= '0'; dir4 <= '0';
                    
                    when others =>
                        --keep state
                        null;
                end case;
            end if;
        end if;
    end process;
    
    d_1 <= dir1;    ena_1 <= ena1;
    d_2 <= dir2;    ena_2 <= ena2;
    d_3 <= dir3;    ena_3 <= ena3;
    d_4 <= dir4;    ena_4 <= ena4;


end architecture rtl;
