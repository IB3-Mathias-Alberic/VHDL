library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    generic (
        f_clk : integer := 50_000_000  -- 50 MHz
    );
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        mode  : in  std_logic;   -- '0' = live (200 ms), '1' = routine (2 s)
        start : in  std_logic;   -- trigger om timer te starten
        d_out : out std_logic    -- = '1' gedurende de hele actieve periode
    );
end entity timer;

architecture rtl of timer is
    constant LIVE    : integer := f_clk / 5;      -- 200 ms  (0.2 * 50e6)
    constant ROUTINE : integer := f_clk * 2;      -- 2 s    (2 * 50e6)
    signal ctr    : integer range 0 to ROUTINE;
    signal active : std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            ctr    <= 0;
            active <= '0';
            d_out  <= '0';
        elsif rising_edge(clk) then
            d_out <= '0';  -- default laag

            if start = '1' then
                -- Start nieuwe timing
                active <= '1';
                ctr    <= 0;
                d_out  <= '1';
            elsif active = '1' then
                -- Blijf hoog tijdens tellen
                d_out <= '1';

                if mode = '0' then
                    -- Live mode: 200 ms
                    if ctr < (LIVE - 1) then
                        ctr <= ctr + 1;
                    else
                        active <= '0';
                        d_out <= '0';
                    end if;
                else
                    -- Routine mode: 2 s
                    if ctr < (ROUTINE - 1) then
                        ctr <= ctr + 1;
                    else
                        active <= '0';
                        d_out <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture rtl;