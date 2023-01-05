----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2022 00:22:57
-- Design Name: 
-- Module Name: PSWRD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PSWRD_SW is
 Port ( 
 CLK : in std_logic;
-- pedir_pswrd:in std_logic;-- señal que llega para que metamos la contraseña(creo que no hace falta)
 sw_pswrd:in std_logic_vector(1 downto 0);
  LIGHT : out std_logic_vector(0 TO 2);
 correcto:out std_logic
 );
end PSWRD_SW;

architecture Behavioral of PSWRD_SW is

type STATES is (bien0, bien1, bien2);
 signal current_state: STATES := bien0;
 signal next_state: STATES;
 
begin

state_register: process (CLK)
 begin
    if rising_edge(CLK) then
        current_state<= next_state;     
    end if;
 end process;
 
 nextstate_decod: process (sw_pswrd, current_state)
 begin
 next_state <= current_state;
 case current_state is
    when bien0 =>
        if sw_pswrd(0) = '1' then 
        next_state <= bien1;
        end if;
 when bien1 =>
        if sw_pswrd(1) = '1' then 
        next_state <=bien2;
        end if; 
 when bien2 =>   
        if sw_pswrd(0) = '0' then 
        next_state <= bien0;   
        end if; 
 when others =>
        next_state <= bien0;
 end case;
 end process;
 
 output_decod: process (current_state)
 begin
 
 case current_state is
    when bien2=>
        correcto <= '1';
     when others => 
         correcto <='0';
end case;
end process;

output_decod_luz: process (current_state)
 begin
 LIGHT <= (OTHERS => '0');
 case current_state is
    when bien0  =>
        LIGHT(0) <= '1';
    when bien1  =>
        LIGHT(1) <= '1';
    when bien2 => 
        LIGHT(2) <= '1';
     when others => 
         LIGHT <= (OTHERS => '0');
end case;
 end process;
end Behavioral;
