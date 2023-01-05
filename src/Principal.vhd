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
    Port (  SW_estado_caja : in STD_LOGIC;--para ir a abrir caja o cerrarla al instante
            boton:           in std_logic;
            CLK :            in std_logic;
            
            LIGHT :          out std_logic_vector(0 to 3);
            segmentos:       out STD_LOGIC_VECTOR (0 to 6);
            ANODOS:          out STD_LOGIC_VECTOR (0 to 7);-- escribira true o error
            LEDS:            out std_logic_vector(2 DOWNTO 0)
            --trys:            out std_logic_vector(2 DOWNTO 0)
           
           
           );
end Principal;

architecture Behavioral of Principal is

    signal s_pswrd_correcta: std_logic_vector(1 downto 0);
    signal s_sync:           std_logic;
    signal s_pswrd:          std_logic;
    signal s_tiempo:         std_logic_vector(0 to 2);
    signal s_cantidad:       std_logic_vector(0 to 3);
   
COMPONENT estado_caja is
     port (
      CLK :       in std_logic;
      SW_caja:    in std_logic;
      PW_RIGTH:   in std_logic_vector(1 downto 0);
      LIGHT :     out std_logic_vector(0 TO 3)
     );
  end COMPONENT;
  
  COMPONENT edge_detector is
     port (
      CLK :       in std_logic;
      IN_EDGE :   in std_logic;
      OUT_EDGE :  out std_logic
     );
  end COMPONENT;
  
  COMPONENT SINCRONIZADOR is
     port (
      CLK :       in std_logic;
      IN_SYNC :   in std_logic;
      OUT_SYNC :  out std_logic
     );
  end COMPONENT;
  
  COMPONENT PSWRD_BOTON is
  port (
	CLK: 	         in STD_LOGIC;
	IN_PSWRD :       in STD_LOGIC;
	reset:           in std_logic;
	
	tiempo:          out std_logic_vector(0 to 2);--salida para poner cuanto tiempo queda
    cantidad:        out std_logic_vector(0 to 3);
    
    --intentos:       out std_logic_vector(2 downto 0);
    
    CORRECTO:        out std_logic_vector(2 DOWNTO 0);
    SI:              out std_logic_vector(1 downto 0)
     );
  end COMPONENT;
  
  COMPONENT DECODER is
  port (
           PW :          in std_logic_vector(1 downto 0);
           Tiempo_dec:   in STD_LOGIC_vector(0 to 2);
           cantidad:     in STD_LOGIC_vector(0 to 3);
           CLK:          in std_logic;
           seg_disp :    out STD_LOGIC_VECTOR (0 to 6);
           AN:           out STD_LOGIC_VECTOR (0 to 7)-- escribirá FAIL O GOOD
     );
  end COMPONENT;
  
        begin

Inst_estado_caja: estado_caja PORT MAP (
    CLK => CLK,
    SW_caja =>SW_estado_caja,
    PW_RIGTH =>s_pswrd_correcta,
    LIGHT=>LIGHT(0 TO 3)
);

Inst_syncron: SINCRONIZADOR PORT MAP (
    CLK => CLK,
    IN_SYNC =>boton,
    OUT_SYNC =>s_sync
);

Inst_edge_det: edge_detector PORT MAP (
    CLK => CLK,
    IN_EDGE =>s_sync,
    OUT_EDGE =>s_pswrd
);


Inst_PSWRD_BOTON: PSWRD_BOTON PORT  MAP(
    CLK => CLK,
    IN_PSWRD=>s_pswrd,
    SI=>s_pswrd_correcta,
    tiempo=>s_tiempo,
    cantidad=>s_cantidad,
    reset=>SW_estado_caja,
    --intentos=>trys,
    CORRECTO =>LEDS -- ESTO SERAN LAS LUCES QUE SE ENCIENDEN SI ESTA BIEN CADA DIGITO DE LA CONTRASEÑA
);

Inst_DECODER: DECODER PORT  MAP(
    CLK => CLK,
    PW=>s_pswrd_correcta,
    tiempo_dec=>s_tiempo,
    cantidad=>s_cantidad,
    seg_disp=>segmentos,
    AN=> ANODOS
);
end Behavioral;
