
entity timer is
    generic (
        f_clk : integer := 50_000_000 -- 50 MHz
    );
    port (
        -- std
        clk : in std_logic;
        rst : in std_logic;
        -- values
        mode : in std_logic;
        start : in std_logic;
        -- output
        d_out : out std_logic 
    );
end entity timer;

architecture rtl of timer is
    constant LIVE : integer := f_clk / 5; -- 200ms 
    constant ROUTINE : integer := f_clk * 2; -- 2s 
    signal ctr : integer range 0 to ROUTINE;
    signal active : std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            ctr <= 0;
            active <= '0';
            d_out <= '0';
        elsif rising_edge(clk) then
            d_out <= '0';
            if start = '1' then
                active <= '1';
                 ctr <= 0;
            elsif active = '1' then
                if  ctr < (LIVE - 1) and mode = '0' then
                     ctr <=  ctr + 1;
                elsif  ctr < (ROUTINE - 1) and mode = '1' then
                     ctr <=  ctr + 1;
                else
                    active <= '0';
                    d_out <= '1';
                end if;
            end if;
        end if;
    end process;
end architecture rtl;