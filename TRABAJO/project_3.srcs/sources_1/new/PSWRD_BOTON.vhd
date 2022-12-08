
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- CREACION DE UN DIVISON DE FRECUENCIA
-- CON EL OBJETIVO DE PODER CONTROLAR LA ENTRADA DE CONTRASEÑA MEDIANTE UN BOTON

entity PSWRD_BOTON is
port (
	CLK: 	        in STD_LOGIC;
	IN_PSWRD :      in STD_LOGIC;
	
    clk_pswrd:		out STD_LOGIC;
    CORRECTO:       out std_logic_vector(1 DOWNTO 0);
    SI:             OUT STD_LOGIC;
    count_pulsador: out std_logic_vector(4 DOWNTO 0)
    
);
end PSWRD_BOTON;

architecture Behavioral of PSWRD_BOTON is

-- TODO ESTO ES PARA CONTAR LOS PULSOS EN UN SEGUNDO
    constant max_count: INTEGER := 30; --frecuencia original del reloj interno.
	signal count: INTEGER range 0 to max_count + 10; 
	signal clk_state: STD_LOGIC := '1';
	SIGNAL cnt : UNSIGNED(4 DOWNTO 0):= "00000";
	signal ok: std_logic := '0';

-- A PARTIR DE AQUI MAQUINA DE ESTADOS DE LA CONTRASEÑA
   --SIGNAL        count_pulsador : STD_LOGIC_vector(4 downto 0);
    --SIGNAL numero: UNSIGNED(4 DOWNTO 0) := "00000";
    SIGNAL numero: std_logic_vector(4 DOWNTO 0) := "00000";
    type STATES is (Dig1, Dig2);
    signal current_state: STATES := Dig1;
    signal next_state: STATES;

--COMPONENT estados is
--     port (
--           CLK : in STD_LOGIC;
--           numero : in STD_LOGIC_vector(4 downto 0);
--           CORRECTO : out STD_LOGIC_vector(1 downto 0)
--     );
--end component;

begin

--Inst_estados: estados PORT MAP(
--    CLK => CLK,
--    numero => count_pulsador,
--    CORRECTO =>CORRECTO
--);

--CONTADOR

    gen_clock: process(CLK, clk_state, count)
        begin

            if rising_edge(CLK) then
              if count < max_count then 
                  count <= count+1; 
                  if  OK = '0' AND IN_PSWRD = '1'  then 
                      cnt <= cnt + 1;  
                      OK <=  '1';
                  elsif IN_PSWRD = '0'  then 
                    OK <=  '0';
                  end if;
                    
                else
                    clk_state <= not clk_state;
                    count <= 0; 
                    cnt <= (others => '0'); 
                    count_pulsador <= std_logic_vector(cnt); 
                    NUMERO <= std_logic_vector(cnt);
                    --NUMERO <= cnt; 
                     --if  numero = "00000" then
                        --PERFECT <= "10";
                     --end if;                

                end if;
            end if;
            clk_pswrd <= clk_state;
            --NUMERO <= "00100";
        end process;
        --count_pulsador <= std_logic_vector(cnt); -- esto hace que se actualice cada intante pero para la maquina de estados solo quiero que se actualice cuando se pone a 0 el contador
 
 --maquina de estados
 
 state_register: process (CLK)
 begin
    --if start = '0' then
    --    current_state<= Dig1;
    if rising_edge(clk) then
        current_state<= next_state; 
    end if;
 end process;
 
   nextstate_decod: process (current_state)
 begin
     next_state <= current_state;
     case current_state is
         when Dig1 =>
            if  numero = "00101" then --5
                next_state <= Dig2;
                CORRECTO <= "01";
            end if;
          when Dig2 =>
            if  numero = "00110" then --6
                next_state <= Dig1;
                CORRECTO <= "11";
            end if;  
     end case;
 end process;
 
end Behavioral;
