-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Konstantin Romanets (xroman18)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;                        -- clock
        RST      : in std_logic;                        -- reset
        DIN      : in std_logic;                        -- data in
        DOUT     : out std_logic_vector(7 downto 0);    -- data out
        DOUT_VLD : out std_logic                        -- data validation signal
    );
end entity;

-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is

    signal read_en         : std_logic;
    signal clk_cnt_en   : std_logic;

    -- clock counter
    signal clk_cnt      : std_logic_vector(4 downto 0);

    -- data counter
    signal dat_cnt      : std_logic_vector(3 downto 0);


begin

    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM
    port map (
        CLK         => CLK,             
        RST         => RST,             
        DATA        => DIN,             
        DATA_END    => dat_cnt(3),      
        CLK_CNT     => clk_cnt,         
        READ_EN     => read_en,           
        CLK_CNT_EN  => clk_cnt_en,      
        VALID       => DOUT_VLD        
    );

    clock_counter: process(CLK, RST) begin
        if RST = '1' then
            clk_cnt <= (others => '0');
        else
            if rising_edge(CLK) then
                if clk_cnt_en = '1' then
                    if read_en = '1' and clk_cnt(4) = '1' then
                        clk_cnt <= "00001";
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                else
                    clk_cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process clock_counter;

    data_counter: process(CLK, RST) begin
        if RST = '1' then
            dat_cnt <= (others => '0');
        else
            if rising_edge(CLK) then
                if read_en = '1' and clk_cnt(4) = '1' then
                    dat_cnt <= dat_cnt + 1;
                end if;

                if read_en = '0' then
                    dat_cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process data_counter;

    demux: process(CLK, RST) begin
        if RST = '1' then
            DOUT <= (others => '0');
        else
            if rising_edge(CLK) then
                if read_en = '1' and clk_cnt(4) = '1' then
                    case dat_cnt is
                        when "0000" => DOUT(0) <= DIN;
                        when "0001" => DOUT(1) <= DIN;
                        when "0010" => DOUT(2) <= DIN;
                        when "0011" => DOUT(3) <= DIN;
                        when "0100" => DOUT(4) <= DIN;
                        when "0101" => DOUT(5) <= DIN;
                        when "0110" => DOUT(6) <= DIN;
                        when "0111" => DOUT(7) <= DIN;
                        when others => null;
                    end case;
                end if;
            end if;
        end if;

    end process demux;

end architecture;
