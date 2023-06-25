-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Konstantin Romanets (xroman18)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Finite state machine controlling RX side
entity UART_RX_FSM is
    port(
        CLK              : in    std_logic;                         -- clock
        RST              : in    std_logic;                         -- reset             
        DATA             : in    std_logic;                         -- data in
        DATA_END         : in    std_logic;                         -- data read end
        CLK_CNT          : in    std_logic_vector(4 downto 0);      -- clock counter
        
        READ_EN          : out   std_logic;                         -- read enable
        CLK_CNT_EN       : out   std_logic;                         -- clock counter enable
        VALID            : out   std_logic                          -- data validation state
    );
end entity;

architecture behavioral of UART_RX_FSM is

    type FSM_State is (IDLE, START, READ, FINISH, VALIDATE);
    signal state : FSM_State := IDLE;

begin

    -- Input detector
    -- IDLE: wait for start bit
    -- START: wait for 5 clock cycles
    -- READ: read data
    -- FINISH: wait for 16 clock cycles
    -- VALIDATE: validate data
    states: process (CLK, RST) begin
        if RST = '1' then
            state <= IDLE;
        else
            if rising_edge(CLK) then
                case state is
                    when IDLE => 
                        if DATA = '0' then
                            state <= START;
                        end if;
                    when START =>
                        -- 22 reads since START
                        if CLK_CNT = "10110" then
                            state <= READ;
                        end if;
                    when READ =>
                        if DATA_END = '1' then
                            state <= FINISH;
                        end if;
                    when FINISH =>
                        -- 16
                        if CLK_CNT = "10000" then
                            state <= VALIDATE;
                        end if;
                    when VALIDATE => 
                        state <= IDLE;      
                    when others => null;
                end case;
            end if;
        end if;
    end process states;

    -- Output control
    output: process(state) begin
        case state is
            when IDLE => 
                READ_EN <= '0';
                CLK_CNT_EN <= '0';
                VALID <= '0';
            when START => 
                READ_EN <= '0';
                CLK_CNT_EN <= '1';
                VALID <= '0';
            when READ => 
                READ_EN <= '1';
                CLK_CNT_EN <= '1';
                VALID <= '0';
            when FINISH => 
                READ_EN <= '0';
                CLK_CNT_EN <= '1';
                VALID <= '0';
            when VALIDATE => 
                READ_EN <= '0';
                CLK_CNT_EN <= '0';
                VALID <= '1';
            when others => null;
        end case;
    end process output;

end architecture;
