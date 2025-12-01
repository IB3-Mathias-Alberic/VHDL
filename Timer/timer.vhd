library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    generic(
        f_clk : integer := 50_000_000;
        LIVE_t : integer := 200;     -- 200ms
        ARRAY : integer := 2000    -- 2s
    );
    port (
        -- standard
        clk : in  std_logic;
        rst : in  std_logic;
        -- mode
        mode : in  std_logic;  -- '0' = 200ms, '1' = 2s
        -- output
        d_out : out std_logic
    );
end timer;

architecture rtl of timer is
    constant cnt_LIVE : integer := (f_clk / 1000) * LIVE_t;
    constant cnt_ARRAY : integer := (f_clk / 1000) * ARRAY_t;
    
    signal ctr : integer range 0 to cnt_ARRAY := 0;
    signal max_count : integer range 0 to cnt_ARRAY := cnt_LIVE;
    
begin
    max_count <= cnt_ARRAY when mode = '1' else cnt_LIVE;
    
    process(clk, rst)
    begin
        if rst = '1' then
            ctr   <= 0;
            d_out <= '0';
        elsif rising_edge(clk) then
            if ctr < max_count - 1 then
                ctr   <= ctr + 1;
                d_out <= '1'; 
            else
                ctr <= 0;
                d_out <= '0';
            end if;
        end if;
    end process;
    
end architecture rtl;
