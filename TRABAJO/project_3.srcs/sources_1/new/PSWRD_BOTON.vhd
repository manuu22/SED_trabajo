
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
	
    CORRECTO:       out std_logic_vector(2 DOWNTO 0);
    SI:             OUT std_logic_vector(1 DOWNTO 0);
    
    --intentos:       out std_logic_vector(2 downto 0);
    
    tiempo:         out std_logic_vector(0 to 2);--salida para poner cuanto tiempo queda
    cantidad:       out std_logic_vector(0 to 3)--salida de cantidad de veces se ha pulsado

    
);
end PSWRD_BOTON;

architecture Behavioral of PSWRD_BOTON is

-- TODO ESTO ES PARA CONTAR LOS PULSOS 
-- 100000000  equivale a 1 seg
    constant max_count: INTEGER := 100000000*5; --cambia de estado cada 5 segundos
	signal count: INTEGER range 0 to max_count + 10; 
	signal clk_state: STD_LOGIC := '1';
	SIGNAL cnt : UNSIGNED(0 to 3):= "0000";
	signal ok: std_logic := '0';
	signal kkl: std_logic := '0';
	
-- SEÑALES PARA LA SALIDA PARA LA INFORMACION DEL TIEMPO Y CANTIDAD
	signal tempo: unsigned(0 to 2) := "000";
	signal segundos: integer := 1;

-- A PARTIR DE AQUI MAQUINA DE ESTADOS DE LA CONTRASEÑA
    SIGNAL numero: std_logic_vector(3 DOWNTO 0) := "0000";
    type STATES is (Dig0,Dig1,Dig2,Dig3,Dig0_fail);
    signal current_state: STATES := Dig0;
    signal next_state: STATES;

--INTENTOS
    --signal intento: unsigned(1 downto 0) := "11";


begin

--CONTADOR

    gen_clock: process(CLK, clk_state, count, reset)
        begin
            if reset='1' then
                if rising_edge(CLK) then
                  if count < max_count then 
                      count <= count+1; 
                      kkl <= '1';
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
                        NUMERO <= std_logic_vector(cnt); 
                        segundos <= 0;
                        tempo <= (others => '0');
                        kkl <='0';    
    
                    end if;
                end if;
             end if;
            

        end process;
        tiempo   <= std_logic_vector(tempo);
        cantidad <= std_logic_vector(cnt);
        
 --MAQUINA DE ESTADOS
 
 state_register: process (CLK,reset)
 begin
 -- con esto se puede cambiar para los resets
    if(reset='0') then
      current_state <= Dig0; 
    --end if;
 
    elsif rising_edge(clk) then
        current_state<= next_state; 
        end if;
 end process;
 
   nextstate_decod: process (current_state, numero, clk_state, kkl)
 begin
     next_state <= current_state;
   if (clk_state='1' or clk_state='0') and kkl = '0'  then
   
     case current_state is
         when Dig0 =>
            if  numero = "0101" then --5
                next_state <= Dig1;
            end if;
--            if intento = "00" then 
--                next_state <= fail;
--            end if;
          when Dig1 =>
             if  numero = "0110" then --6
                next_state <= Dig2;          
             else 
                 next_state <= Dig0;
                 --intento <= intento -1;
             end if;
          when Dig2 =>
              if  numero = "0010" then --2
                next_state <= Dig2;          
             else 
                 next_state <= Dig0;
                 --intento <= intento -1;
             end if; 
          when Dig3 =>
           when Dig0_fail =>
            if  numero = "0101" then --5
                next_state <= Dig1;
            end if;
  
     end case;
   end if;
--   case intento is 
--    when "00" =>intentos <= "000";
--    when "01" =>intentos <= "001";
--    when "10" =>intentos <= "011";
--    when "11" =>intentos <= "111";
--   end case;
   --intentos <= std_logic_vector(intento);
 end process;
 
 output_decod_luz: process (current_state)
 begin

 case current_state is
    when Dig0  =>
         si <= "10";
         CORRECTO <= "000";
    when Dig1  =>
         si <= "10";
         CORRECTO <= "001";     
    when Dig2  =>
         si <= "01";
         CORRECTO <= "011";
    when Dig3  =>
         si <= "11";
         CORRECTO <= "111";
    when Dig0_fail  =>
         si <= "00";
         CORRECTO <= "000";
     when others => 
         si <= "10";
         CORRECTO <= "000";
end case;
 end process;
 
end Behavioral;
