
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- CREACION DE UN DIVISON DE FRECUENCIA
-- CON EL OBJETIVO DE PODER CONTROLAR LA ENTRADA DE CONTRASEÑA MEDIANTE UN BOTON

entity PSWRD_BOTON is
port (
	CLK: 	        in STD_LOGIC;
	IN_PSWRD :      in STD_LOGIC;
	reset:          in std_logic;
	
    clk_pswrd:		out STD_LOGIC;
    CORRECTO:       out std_logic_vector(1 DOWNTO 0);
    SI:             OUT STD_LOGIC;
    
    tiempo:         out std_logic_vector(1 DOWNTO 0);--salida para poner cuanto tiempo queda
    cantidad:       out std_logic_vector(4 DOWNTO 0);--salida de cantidad de veces se ha pulsado
    
    count_pulsador: out std_logic_vector(4 DOWNTO 0)
    
);
end PSWRD_BOTON;

architecture Behavioral of PSWRD_BOTON is

-- TODO ESTO ES PARA CONTAR LOS PULSOS EN UN SEGUNDO
-- 100000000 esto equivale a 1 seg
    constant max_count: INTEGER := 100000000*5; --cambia de estado cada 5 segundos
	signal count: INTEGER range 0 to max_count + 10; 
	signal clk_state: STD_LOGIC := '1';
	SIGNAL cnt : UNSIGNED(4 DOWNTO 0):= "00000";
	signal ok: std_logic := '0';
	
-- SEÑALES PARA LA SALIDA PARA LA INFORMACION DEL TIEMPO Y CANTIDAD
	signal tempo: unsigned(1 DOWNTO 0) := "000";
	signal segundos: integer := 1;

-- A PARTIR DE AQUI MAQUINA DE ESTADOS DE LA CONTRASEÑA
    SIGNAL numero: std_logic_vector(4 DOWNTO 0) := "00000";
    type STATES is (Dig0,Dig1,Dig2);
    signal current_state: STATES := Dig0;
    signal next_state: STATES;


begin

--CONTADOR

    gen_clock: process(CLK, clk_state, count)
        begin

            if rising_edge(CLK) then
              if count < max_count then 
                  count <= count+1; 
                  if  OK = '0' AND IN_PSWRD = '1'  then 
                      cnt  <= cnt + 1;  --contar cada pulsacion
                      OK   <=  '1';
                  elsif IN_PSWRD = '0'  then 
                    OK <=  '0';
                  end if;
                  
                  if count >= (100000000*segundos) then 
                  segundos <= segundos +1;
                  tempo <= tempo + 1;
                  
                  end if;
                    
                else
                    clk_state <= not clk_state;
                    count <= 0; 
                    cnt <= (others => '0'); 
                    count_pulsador <= std_logic_vector(cnt); 
                    NUMERO <= std_logic_vector(cnt);     

                end if;
            end if;
            clk_pswrd <= clk_state;
            --NUMERO <= "00100";
        end process;
        tiempo   <= std_logic_vector(tempo);
        cantidad <= std_logic_vector(cnt);
        --count_pulsador <= std_logic_vector(cnt); -- esto hace que se actualice cada intante pero para la maquina de estados solo quiero que se actualice cuando se pone a 0 el contador
 
 --maquina de estados
 
 state_register: process (CLK)
 begin
 -- con esto se puede cambiar para los resets
--    if(reset='0') then
--      current_state <= Dig0; 
--    end if;
 
    if rising_edge(clk) then
        current_state<= next_state; 
        end if;
 end process;
 
   nextstate_decod: process (current_state, numero)
 begin
     next_state <= current_state;
     case current_state is
         when Dig0 =>
            if  numero = "00101" then --5
                next_state <= Dig1;
            end if;
          when Dig1 =>
            if(reset='0') then
                next_state <= Dig0; 
            else if  numero = "00110" then --6
                next_state <= Dig2;          
             end if; 
             end if;
          when Dig2 =>
            if(reset='0') then
                next_state <= Dig0; 
            end if;    
     end case;
 end process;
 
 output_decod_luz: process (current_state)
 begin

 case current_state is
    when Dig0  =>
         si <= '0';
         CORRECTO <= "00";
     when Dig1  =>
         si <= '0';
         CORRECTO <= "01";     
      when Dig2  =>
         si <= '1';
         CORRECTO <= "11";
     when others => 
         si <= '0';
         CORRECTO <= "00";
end case;
 end process;
 
end Behavioral;
