----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2022 13:16:10
-- Design Name: 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
    Port ( PW :          in std_logic_vector(1 downto 0);
           Tiempo_dec :  in STD_LOGIC_VECTOR (0 to 2);
           Cantidad:     in STD_LOGIC_VECTOR (0 to 3);
           CLK:          in std_logic;
           
           seg_disp :    out STD_LOGIC_VECTOR (0 to 6);
           AN:           out STD_LOGIC_VECTOR (0 to 7)-- escribira true o error
           );
end decoder;

architecture Behavioral of decoder is

signal aux_CLK: std_logic;
begin 
   
  CLK_aux : process(CLK)
    variable cont: integer:=0;
    begin     
if rising_edge (CLK) then
        cont := cont+1;
    if cont= 10**5 then -- deberia ser 1.66 para pasar a unos 300HZ aprox
       cont:=0;
        aux_CLK <= not aux_CLK;
    end if; 
 end if;
end process;


process (aux_CLK)
variable disp0,disp1,disp2,disp3,disp5,disp7:std_logic_vector(0 to 6);
variable bucle: std_logic_vector(0 to 5):="011111";
begin
if rising_edge (aux_CLK) then

case PW is 
    when "00" =>
         disp0:= "0111000";--F 
         disp1:="0001000" ;--A
         disp2:="1111001" ;--I
         disP3:="1110001" ;--L
        
    
    when "11" => 
         disp0:="0100000" ;--G 6
         disp1:="0000001" ;--O
         disp2:="0000001" ;--O
         disP3:="1000010";--D 6 invertido
    when others=>
         
         disp0:="1111110" ;
         disp1:="1111110" ;
         disp2:="1111110" ;
         disP3:="1111110";
         
       
 END CASE;
 
 
 case tiempo_dec is
 
 when "000" =>
    disp7:="0000001" ;--0
  
 when "001" =>
    disp7:="1001111" ;--1
 when "010" =>
    disp7:="0010010" ;--2
 when "011" =>
    disp7:="0000110" ;--3
 when "100" =>
    disp7:="1001100" ;--4
when "101" =>
    disp7:="0100100" ;--5
 when others =>
    disp7:="1111110" ;--despues de 5 segundos no imprime nada

end case;


case cantidad is
 
 when "0000" =>
    disp5:="0000001" ; --0
  
 when "0001" =>
    disp5:="1001111" ; --1
 when "0010" =>
    disp5:="0010010" ;--2
 when "0011" =>
    disp5:="0000110" ;--3
 when "0100" =>
    disp5:="1001100" ;--4
 when "0101" =>
    disp5:="0100100" ;--5
when "0110" => 
    disp5:="0100000" ;--6
when "0111" =>
    disp5:="0001111" ;--7
when "1000" =>
    disp5:="0000000" ;--8
when "1001" =>
    disp5:="0001100" ;--9
 when others =>
    disp5:="1111110" ; -- imprime quiones

end case;

 
 CASE  bucle is
     when "011111"=>
         seg_disp<= disp0;
         AN<="01111111";
    
    When "101111"=>
        seg_disp<= disp1;
         AN<="10111111";
  
    when "110111"=>
        seg_disp<= disp2;
        AN<="11011111";
   
    when "111011"=>
        seg_disp<= disp3;
        AN<="11101111";
        
    when "111101"=>
        seg_disp<= disp5;
        AN<="11111011";
        
     when "111110"=>
        seg_disp<= disp7;
        AN<="11111110";
   
     when others=>  
         seg_disp<= "1111110";
        AN<="00001010";
 
 
    end case;
BUCLE:= bucle(5)& bucle(0 to 4);
 
    END IF;   
 end process ;   

end Behavioral;
