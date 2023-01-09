library ieee;
use ieee.std_logic_1164.all;

entity tb_decoder is
end tb_decoder;

architecture tb of tb_decoder is

    component decoder
        port (PW         : in std_logic_vector (1 downto 0);
              Tiempo_dec : in std_logic_vector (0 to 2);
              Cantidad   : in std_logic_vector (0 to 3);
              CLK        : in std_logic;
              seg_disp   : out std_logic_vector (0 to 6);
              AN         : out std_logic_vector (0 to 7));
    end component;

    signal PW         : std_logic_vector (1 downto 0);
    signal Tiempo_dec : std_logic_vector (0 to 2);
    signal Cantidad   : std_logic_vector (0 to 3);
    signal CLK        : std_logic;
    signal seg_disp   : std_logic_vector (0 to 6);
    signal AN         : std_logic_vector (0 to 7);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : decoder
    port map (PW         => PW,
              Tiempo_dec => Tiempo_dec,
              Cantidad   => Cantidad,
              CLK        => CLK,
              seg_disp   => seg_disp,
              AN         => AN);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        PW <= (others => '0');
        Tiempo_dec <= (others => '0');
        Cantidad <= (others => '0');

        -- EDIT Add stimuli here
        wait for 1000000 * TbPeriod;

	 PW <= "11";
        Tiempo_dec <="101";
        Cantidad <= "0101";

        -- EDIT Add stimuli here
        wait for 1000000 * TbPeriod;

	 PW <= "10";
        Tiempo_dec <="111";
        Cantidad <= "1111";

        -- EDIT Add stimuli here
        wait for 1000000  * TbPeriod;



        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
