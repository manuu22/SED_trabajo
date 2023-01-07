library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity ESTADO_CAJA is
    port (
        CLK      : in  std_logic;
        SW_CAJA  : in  std_logic;
        PW_RIGTH : in  std_logic_vector(1 downto 0);
        LIGHT    : out std_logic_vector(3 downto 0)
    );
end ESTADO_CAJA;

architecture BEHAVIORAL of ESTADO_CAJA is
    type STATES is (C_cerrada, C_abriendo, C_abierta);
    signal current_state: STATES := C_cerrada;
    signal next_state: STATES;
begin
    state_register: process (SW_caja,CLK)
    begin
        if SW_caja = '0' then
            current_state <= C_cerrada;
        elsif rising_edge(clk) then
            current_state <= next_state; 
        end if;
    end process;
 
    nextstate_decod: process (SW_caja, PW_RIGTH, current_state)
    begin
        next_state <= current_state;
        case current_state is
        when C_cerrada =>
            if SW_caja = '1' then 
                next_state <= C_abriendo;
            end if;
        when C_abriendo =>
            if (SW_caja = '1' and PW_RIGTH = "11") then 
                next_state <= C_abierta;
            end if; 
        when C_abierta =>
            if SW_caja = '0' then 
                next_state <= C_cerrada;
            end if;
        when others =>
            next_state <= C_cerrada;
        end case;
    end process;

    output_decod: process (PW_RIGTH, current_state)
    begin
        LIGHT <= (others => '0');
        case current_state is
        when C_cerrada  =>
            LIGHT(0) <= '1';
        when C_abriendo  =>
            LIGHT(1) <= '1';
        when C_abierta => 
            LIGHT(2) <= '1';
            if PW_RIGTH = "11" then
                LIGHT(3) <= '1';
            end if;
        when others => 
            LIGHT <= (others => '0');
        end case;
    end process;
end BEHAVIORAL;
