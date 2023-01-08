----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2023 18:16:29
-- Design Name: 
-- Module Name: tb_estado_caja - Behavioral
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

entity tb_estado_caja is
end tb_estado_caja;

architecture tb of tb_estado_caja is

    component estado_caja
        port (CLK      : in std_logic;
              SW_caja  : in std_logic;
              PW_RIGTH : in std_logic_vector (1 downto 0);
              LIGHT    : out std_logic_vector (0 to 3));
    end component;

    signal CLK      : std_logic;
    signal SW_caja  : std_logic;
    signal PW_RIGTH : std_logic_vector (1 downto 0);
    signal LIGHT    : std_logic_vector (0 to 3);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : estado_caja
    port map (CLK      => CLK,
              SW_caja  => SW_caja,
              PW_RIGTH => PW_RIGTH,
              LIGHT    => LIGHT);

   
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    
    CLK <= TbClock;

    stimuli : process
    begin
        
       
        SW_caja <= '0';
        PW_RIGTH <= (others => '0');

       
        wait for 100 * TbPeriod;
        PW_RIGTH<="11";
        wait for 100 * TbPeriod;
        SW_caja <= '1'; 
        wait for 100 * TbPeriod;
        SW_caja <= '0';
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;