library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_rf is
--  Port ( );
end tb_rf;

architecture Behavioral of tb_rf is

component rf is
    Port (
            CLK, WE3   : in std_logic;
            A1, A2, A3 : in std_logic_vector(4 downto 0);
            WD3        : in std_logic_vector(31 downto 0);   
            RD1, RD2   : out std_logic_vector(31 downto 0)
    );
end component;


signal tClk, tWe3: STD_LOGIC;
signal tA1, tA2, tA3 : std_logic_vector(4 downto 0);
signal tWD3, tRD1, tRD2 : std_logic_vector(31 downto 0);

signal period : time := 10 ns;

begin

uut: rf PORT MAP( CLK => tClk,
                  A1 => tA1,
                  A2 => tA2,
                  A3 => tA3,
                  WE3 => tWe3,
                  WD3 => tWD3,
                  RD1 => tRD1,
                  RD2 => tRD2
);

process
begin

    -- case A, write 0x01 to reg 0x03
    tWe3 <= '1';
    tA1 <= "00001";
    tA2 <= "00010";
    tA3 <= "00011";
    tWD3 <= "00000000000000000000000000000001";
    wait for period;

    -- case B, retrieve reg 0x03
    tWe3 <= '0';
    tA1 <= "00011";
    tA2 <= "00011";
    tA3 <= "00011";
    tWD3 <= "00000000000000000000000000000000";
    wait for period;

end process;

end Behavioral;
