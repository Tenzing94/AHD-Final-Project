-- Testbench for PC Component
library ieee;
use ieee.std_logic_1164.all;

entity tb_pc is
end tb_pc;

architecture tb of tb_pc is
    signal tClr : std_logic;
    signal tPcIn, tPcOut : std_logic_vector(31 downto 0);
    signal tClk : std_logic := '0'; -- make sure you initialise!
begin
    -- SIGNALS, UUT
    UUT : entity work.pc port map (in_pc => tPcIn, clk => tClk, clr => tClr, out_pc => tPcOut);

    tb1 : process
        constant period: time := 100 ns;
        constant half_period: time := 100 ns;
        begin
            -- active hi reset
            tClr <= '1';
            tPcIn <= "00000000000010000000000001000000";
            wait for half_period;
            
            -- load PC
            tClr <= '0';
            tPcIn <= "00010000000000001000000000000001";
            wait for half_period;
            
            wait; -- indefinitely suspend process
        end process;
end tb;