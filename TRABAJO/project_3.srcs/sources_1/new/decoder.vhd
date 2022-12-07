----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2022 13:16:10
-- Design Name: 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
    Port ( PW : in STD_LOGIC;
           CLK: in std_logic;
           seg_disp : out STD_LOGIC_VECTOR (0 to 6);
           AN: out STD_LOGIC_VECTOR (0 to 7)-- escribira true o error
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
    if cont= 100 then -- deberia ser 1.66 para pasar a unos 300HZ aprox
       cont:=0;
        aux_CLK <= not aux_CLK;
    end if; 
 end if;
end process;


process (aux_CLK)
variable disp0,disp1,disp2,disp3:std_logic_vector(0 to 6);
variable bucle: std_logic_vector(0 to 3):="0111";
begin
if rising_edge (aux_CLK) then

case PW is
    when '0' =>
         disp0:= "0111000";--F 
         disp1:="0001000" ;--A
         disp2:="1111001" ;--I
         disP3:="1110001" ;--L
        
    
    when '1' => 
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
 
 CASE  bucle is
     when "0111"=>
         seg_disp<= disp0;
         AN<="01111111";
    
    When "1011"=>
        seg_disp<= disp1;
         AN<="10111111";
  
    when "1101"=>
        seg_disp<= disp2;
        AN<="11011111";
   
    when "1110"=>
        seg_disp<= disp3;
        AN<="11101111";
   
     when others=>  
         seg_disp<= "1111110";
        AN<="00001111";
 
 
    end case;
BUCLE:= bucle(3)& bucle(0 to 2);
 
    END IF;   
 end process ;   

end Behavioral;
