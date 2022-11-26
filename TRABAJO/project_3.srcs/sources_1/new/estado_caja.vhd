library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity estado_caja is
--  Port ( );
port (
 CLK : in std_logic;
 SW_caja: in std_logic;
 PW_RIGTH: in std_logic;
 LIGHT : out std_logic_vector(0 TO 3)

 );
end estado_caja;

architecture Behavioral of estado_caja is

type STATES is (C_cerrada, C_abriendo, C_abierta);
 signal current_state: STATES := C_cerrada;
 signal next_state: STATES;
 
begin
 state_register: process (SW_caja,CLK)
 begin
    if SW_caja = '0' then
        current_state<= C_cerrada;
    elsif rising_edge(clk) then
        current_state<= next_state; 
    end if;
 end process;
 
 nextstate_decod: process (SW_caja, current_state)
 begin
 next_state <= current_state;
 case current_state is
    when C_cerrada =>
        if SW_caja = '1' then 
        next_state <= C_abriendo;
        end if;
 when C_abriendo =>
        if SW_caja = '1' AND PW_RIGTH = '1' then 
        next_state <= C_abierta;
        end if; 
 when others =>
        next_state <= C_cerrada;
 end case;
 end process;
 
 
 output_decod: process (current_state)
 begin
 LIGHT <= (OTHERS => '0');
 case current_state is
    when C_cerrada  =>
        LIGHT(0) <= '1';
    when C_abriendo  =>
        LIGHT(1) <= '1';
    when C_abierta => 
        LIGHT(2) <= '1';
     when others => 
         LIGHT <= (OTHERS => '0');
end case;
 end process;


end Behavioral;