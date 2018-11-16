library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_dmem is
--  Port ( );
end tb_dmem;

architecture Behavioral of tb_dmem is

component dmem is
    Port ( 
            CLK, WE : in std_logic;
            A, WD   : in std_logic_vector(31 downto 0);
            RD      : out std_logic_vector(31 downto 0)           );
end component;


signal tClk, tWe: STD_LOGIC;
signal tA,tWd,tRd : STD_LOGIC_VECTOR(31 downto 0);

signal period : time := 10 ns;

begin

uut: dmem PORT MAP( CLK => tclk,
                  A => tA,
                  WD => tWd,
                  RD => tRD,
                  WE => tWe);

process
begin

    -- case A
    tWe <= '1';
    tWd <= "00000000000000000000000000000001";
    tA <= "00000000000000000000000000000000";
    wait for period;

    -- case B
    tWe <= '0';
    tWd <= "00000000000000000000000000000000";
    tA <= "00000000000000000000000000000001";
    tRD <= "00000000000000000000000000000001";
    wait for period;

end process;

end Behavioral;
