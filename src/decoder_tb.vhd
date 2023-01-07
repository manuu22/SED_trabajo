----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2023 20:09:28
-- Design Name: 
-- Module Name: DECODER_TB - TESTBENCH
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

entity DECODER_TB is
end DECODER_TB;

architecture TESTBENCH of DECODER_TB is

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
            AN         : out std_logic_vector(7 downto 0)-- escribira true o error
        );
    end component;

    -- Inputs
    signal pw         : std_logic_vector(1 downto 0);
    signal tiempo_dec : unsigned(2 downto 0);
    signal cantidad   : unsigned(3 downto 0);
    signal clk        : std_logic;

    -- Outputs
    signal seg_disp   : std_logic_vector(6 downto 0);
    signal an         : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    uut: DECODER
        generic map (
            DIVISOR    => 5
        )
        port map (
            PW         => pw,
            TIEMPO_DEC => tiempo_dec,
            CANTIDAD   => cantidad,
            CLK        => clk,
            SEG_DISP   => seg_disp,
            AN         => an
        );

    clk_gen: process
    begin
      clk <= '0';
      wait for 0.5 * CLK_PERIOD;
      clk <= '1';
      wait for 0.5 * CLK_PERIOD;
    end process;

    pw_gen: process
        variable vpw : unsigned(1 downto 0) := (others => '0');
    begin
        pw <= std_logic_vector(vpw);
        wait until an = "11111110";
        wait until an = "01111111";
        vpw := vpw + 1;
    end process;

    number_gen: process
        variable number : unsigned(3 downto 0) := (others => '0');
    begin
        tiempo_dec <= number(2 downto 0);
        cantidad   <= number;
        wait until an = "11111110";
        wait until an = "01111111";
        number := (number + 1) mod 10;
    end process;

    terminator: process
    begin
        for i in 1 to 10 loop
            wait until an = "11111110";
        end loop;
        assert false
            report "[PASS]: simulation finished."
            severity failure;
    end process;
end TESTBENCH;
