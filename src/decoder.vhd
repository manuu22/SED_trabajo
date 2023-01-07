----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03.12.2022 13:16:10
-- Design Name:
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DECODER is
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
end DECODER;

architecture BEHAVIORAL of DECODER is
    type segment_vector is array(integer range <>) of std_logic_vector(6 downto 0);

    signal strobe  : std_logic := '0';
    signal anode   : std_logic_vector(7 downto 0) := (7 => '0', others => '1');
    signal digsegs : segment_vector(anode'range);
begin
    AN <= anode;

    strober: process(CLK)
        subtype count_t is integer range 0 to DIVISOR - 1;
        variable count : count_t := count_t'high;
    begin
        if rising_edge(CLK) then
            strobe <= '0';
            count := count - 1;
            if count = 0 then
                strobe <= '1';
                count := count_t'high;
            end if;
        end if;
    end process;

    scanner: process(CLK)
    begin
        if rising_edge(CLK) then
            if strobe = '1' then
                anode <= anode(0) & anode(anode'high downto 1);
            end if;
        end if;
    end process;

    muxer: with anode select
        SEG_DISP <= digsegs(0) when "11111110",
                    digsegs(1) when "11111101",
                    digsegs(2) when "11111011",
                    digsegs(3) when "11110111",
                    digsegs(5) when "11011111",
                    digsegs(7) when "01111111",
                    (others => '1') when others;

    msg_decoder: with PW select
        digsegs(3 downto 0) <=
            ("0111000", "0001000", "1111001", "1110001") when "00", -- FAIL
            ("0100000", "0000001", "0000001", "1000010") when "11", -- GOOD
            ("1111110", "1111110", "1111110", "1111110") when others;

    qty_decoder: with to_integer(CANTIDAD) select
        digsegs(5) <=
            "0000001" when 0,
            "1001111" when 1,
            "0010010" when 2,
            "0000110" when 3,
            "1001100" when 4,
            "0100100" when 5,
            "0100000" when 6,
            "0001111" when 7,
            "0000000" when 8,
            "0001100" when 9,
            "1111110" when others;

    time_decoder: with to_integer(TIEMPO_DEC) select
        digsegs(7) <=
            "0000001" when 0,
            "1001111" when 1,
            "0010010" when 2,
            "0000110" when 3,
            "1001100" when 4,
            "0100100" when 5,
            "1111110" when others;
end BEHAVIORAL;
