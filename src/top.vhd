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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TOP is
    generic (
        CLKIN_FREQ : positive := 100_000_000
    );
    port (
        CLK100MHZ      : in  std_logic;
        SW             : in  std_logic_vector( 0 downto 0);
        BTNU           : in  std_logic;
        LED            : out std_logic_vector(15 downto 0);
        CA, CB, CC, CD : out std_logic;
        CE, CF, CG, DP : out std_logic;
        AN             : out std_logic_vector(7 downto 0)
   );
end TOP;

architecture STRUCTURAL of TOP is

    alias SW_ESTADO_CAJA : std_logic is SW(0);
    alias BOTON          : std_logic is BTNU;
    alias LIGHT          : std_logic_vector(3 downto 0) is LED( 3 downto  0);
    alias LEDS           : std_logic_vector(2 downto 0) is LED(11 downto  9);
--    alias TRYS          : std_logic_vector(2 downto 0) is LED(15 downto 13);

    signal s_pswrd_correcta : std_logic_vector(1 downto 0);
    signal s_sync           : std_logic;
    signal s_pswrd          : std_logic;
    signal s_tiempo         : unsigned(2 downto 0);
    signal s_cantidad       : unsigned(3 downto 0);
    signal segmentos        : std_logic_vector(6 downto 0);

    component ESTADO_CAJA is
        port (
            CLK      : in  std_logic;
            SW_caja  : in  std_logic;
            PW_RIGTH : in  std_logic_vector(1 downto 0);
            LIGHT    : out std_logic_vector(3 downto 0)
        );
    end component;

    component EDGE_DETECTOR is
        port (
            CLK      : in  std_logic;
            IN_EDGE  : in  std_logic;
            OUT_EDGE : out std_logic
        );
    end component;

    component SINCRONIZADOR is
        port (
            CLK      : in  std_logic;
            IN_SYNC  : in  std_logic;
            OUT_SYNC : out std_logic
        );
    end component;

    component PSWRD_BOTON is
        port (
            CLK      : in  std_logic;
            IN_PSWRD : in  std_logic;
            RESET    : in  std_logic;
            TIEMPO   : out unsigned(2 downto 0);--salida para poner cuanto tiempo queda
            CANTIDAD : out unsigned(3 downto 0);
            --intentos : out std_logic_vector(2 downto 0);
            CORRECTO : out std_logic_vector(2 downto 0);
            SI       : out std_logic_vector(1 downto 0)
        );
    end component;

    component DECODER is
        generic (
            DIVISOR    : positive
        );
        port (
            PW         : in  std_logic_vector(1 downto 0);
            TIEMPO_DEC : in  unsigned(2 downto 0);
            CANTIDAD   : in  unsigned(3 downto 0);
            CLK        : in  std_logic;
            SEG_DISP   : out std_logic_vector(6 downto 0);
            AN         : out std_logic_vector(7 downto 0)
        );
    end component;
  
begin
    LED(15 downto 12) <= (others => '0');
    LED( 8 downto  4) <= (others => '0');

    (CA, CB, CC, CD, CE, CF, CG) <= segmentos;
    DP <= '1';

    btn_syncronzer: SINCRONIZADOR
        port map (
            CLK      => CLK100MHZ,
            IN_SYNC  => boton,
            OUT_SYNC => s_sync
        );

    btn_edge_dtctr: EDGE_DETECTOR
        port map (
            CLK      => CLK100MHZ,
            IN_EDGE  => s_sync,
            OUT_EDGE => s_pswrd
        );

    safebox_fsm: ESTADO_CAJA
        port map (
            CLK      => CLK100MHZ,
            SW_caja  => SW_estado_caja,
            PW_RIGTH => s_pswrd_correcta,
            LIGHT    => LIGHT(3 downto 0)
        );

    inst_pswrd_boton: PSWRD_BOTON
        port  map (
            CLK      => CLK100MHZ,
            IN_PSWRD => s_pswrd,
            SI       => s_pswrd_correcta,
            TIEMPO   => s_tiempo,
            CANTIDAD => s_cantidad,
            RESET    => SW_estado_caja,
            -- intentos=>trys,
            CORRECTO => LEDS -- ESTO SERAN LAS LUCES QUE SE ENCIENDEN SI ESTA BIEN CADA DIGITO DE LA CONTRASEÑA
        );

    decoder1: DECODER
        generic map (
            DIVISOR    => CLKIN_FREQ / 333
        )
        port  map(
            CLK        => CLK100MHZ,
            PW         => s_pswrd_correcta,
            TIEMPO_DEC => s_tiempo,
            CANTIDAD   => s_cantidad,
            SEG_DISP   => segmentos,
            AN         => AN
        );
end STRUCTURAL;
