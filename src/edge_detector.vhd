library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity EDGE_DETECTOR is
    port (
        CLK      : in  std_logic;
        IN_EDGE  : in  std_logic;
        OUT_EDGE : out std_logic
     );
end EDGE_DETECTOR;

architecture BEHAVIORAL of EDGE_DETECTOR is
    signal sreg : std_logic_vector(1 downto 0);
begin
    process (CLK)
    begin
        if rising_edge(CLK) then 
            OUT_EDGE <= sreg(1);
            sreg <= sreg(0) & IN_EDGE;
        end if; 
    end process;
end BEHAVIORAL;
