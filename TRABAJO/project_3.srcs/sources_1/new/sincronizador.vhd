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
--  Port ( );
port ( 
 CLK : in std_logic;
 IN_EDGE : in std_logic;
 OUT_EDGE : out std_logic
 );
end sincronizador;

architecture Behavioral of sincronizador is
signal sreg : std_logic_vector(1 downto 0);
begin
 process (CLK)
 begin
 if rising_edge(CLK) then 
 OUT_EDGE <= sreg(1);
 sreg <= sreg(0) & IN_EDGE;
 end if; 
 end process;


end Behavioral;