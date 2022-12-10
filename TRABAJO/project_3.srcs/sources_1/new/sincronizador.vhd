
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sincronizador is

 port ( 
 CLK :      in std_logic;
 IN_SYNC :  in std_logic;
 
 OUT_SYNC : out std_logic
 );
end sincronizador;

architecture Behavioral of sincronizador is

signal sreg : std_logic_vector(2 downto 0);
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


end Behavioral;
