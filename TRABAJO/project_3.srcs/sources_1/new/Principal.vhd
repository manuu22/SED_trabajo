----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2022 18:26:51
-- Design Name: 
-- Module Name: Principal - Behavioral
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

entity Principal is
    Port ( SW_estado_caja : in STD_LOGIC;--para ir a abrir caja o cerrarla al instante
          SW_INTRO_PSWRD : in STD_LOGIC_VECTOR(1 downto 0);--poner contraseña
          CLK : in std_logic;
           LIGHT : out std_logic_vector(0 TO 3)
           );
end Principal;

architecture Behavioral of Principal is

signal s_pswrd_correcta: std_logic;


COMPONENT estado_caja is
     port (
     CLK : in std_logic;
    SW_caja: in std_logic;
     PW_RIGTH: in std_logic;
    LIGHT : out std_logic_vector(0 TO 3)
     );
  end COMPONENT;
  
  COMPONENT PSWRD is
     port (
     CLK : in std_logic;
     sw_pswrd:in std_logic_vector(1 downto 0);
     correcto:out std_logic
     );
  end COMPONENT;
begin

Inst_estado_caja: estado_caja PORT MAP (
CLK => CLK,
SW_caja =>SW_estado_caja,
PW_RIGTH =>s_pswrd_correcta,
LIGHT=>LIGHT
);

Inst_PSWRD: PSWRD PORT MAP (
CLK => CLK,
sw_pswrd =>SW_INTRO_PSWRD,
correcto =>s_pswrd_correcta
);
end Behavioral;
