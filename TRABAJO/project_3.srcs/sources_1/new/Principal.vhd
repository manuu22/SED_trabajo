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
         boton: in std_logic;
          CLK : in std_logic;
           LIGHT : out std_logic_vector(0 TO 3)
           );
end Principal;

architecture Behavioral of Principal is

    signal s_pswrd_correcta: std_logic;
    signal s_sync: std_logic;
    signal s_pswrd: std_logic;

COMPONENT estado_caja is
     port (
     CLK : in std_logic;
    SW_caja: in std_logic;
     PW_RIGTH: in std_logic;
    LIGHT : out std_logic_vector(0 TO 3)
     );
  end COMPONENT;
  
  COMPONENT EDGE_DETECTOR is
     port (
     CLK : in std_logic;
 IN_EDGE : in std_logic;
 OUT_EDGE : out std_logic
     );
  end COMPONENT;
  
  COMPONENT SINCRONIZADOR is
     port (
     CLK : in std_logic;
 IN_SYNC : in std_logic;
 OUT_SYNC : out std_logic
     );
  end COMPONENT;
  
  COMPONENT PSWRD_BOTON is
  port (
     CLK : in std_logic;
 IN_PSWRD : in std_logic;
 CORRECTO : out std_logic
     );
  end COMPONENT;
  
        begin

Inst_estado_caja: estado_caja PORT MAP (
CLK => CLK,
SW_caja =>SW_estado_caja,
PW_RIGTH =>s_pswrd_correcta,
LIGHT=>LIGHT(0 TO 3)
);

Inst_SINCRON: SINCRONIZADOR PORT MAP(
CLK => CLK,
IN_SYNC=>BOTON,
OUT_SYNC=>s_SYNC
);

Inst_EDGE_DETEC: EDGE_DETECTOR PORT  MAP(
CLK => CLK,
IN_EDGE=>s_sync,
OUT_EDGE=>s_pswrd
);

Inst_PSWRD_BOTON: PSWRD_BOTON PORT  MAP(
CLK => CLK,
IN_PSWRD=>s_pswrd,
CORRECTO=>s_pswrd_correcta
);
end Behavioral;
