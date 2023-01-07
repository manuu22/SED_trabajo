----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2022 18:34:13
-- Design Name: 
-- Module Name: edge_detector - Behavioral
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
--use ieee.numeric_std.all;

entity SINCRONIZADOR is
     port (
         CLK      : in  std_logic;
         IN_SYNC  : in  std_logic;     
         OUT_SYNC : out std_logic
     );
end SINCRONIZADOR;

architecture BEHAVIORAL of SINCRONIZADOR is
    signal sreg : std_logic_vector(2 downto 0) := (others => '0');
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            sreg <= sreg(1 downto 0) & IN_SYNC;
        end if; 
    end process;

    with sreg select
        OUT_SYNC <= '1' when "100",
                    '0' when others;
end BEHAVIORAL;
