library ieee;
use ieee.std_logic_1164.all;


entity tb_pc is
end tb_pc;

architecture tb of tb_pc is
    signal tClr : std_logic;
    signal tPcIn, tPcOut : std_logic_vector(31 downto 0);
    signal tClk : std_logic := '0';

begin
    -- PC
    UUT : entity work.pc port map (in_pc => tPcIn, clk => tClk, clr => tClr, out_pc => tPcOut);
    
    -- IMEM
    UUT2 : entity work.imem port map (in_pc => tPcOut);

    
    tb1 : process
        constant half_period: time := 50 ns;
        begin
            -- active hi reset
            tClk <= not tClk after half_period;
            tClr <= '1';
            tPcIn <= "00000000000000000000000000000001";
            wait for half_period;
            
            -- load PC with '1'
            tClr <= '0';
            tClk <= not tClk after half_period;
            tPcIn <= "00000000000000000000000000000001";
            wait for half_period;
            
            -- load PC with '2'
            tClr <= '0';
            tClk <= not tClk after half_period;
            tPcIn <= "00000000000000000000000000000010";
            wait for half_period;
            
            -- load PC with '3'
            tClr <= '0';
            tClk <= not tClk after half_period;
            tPcIn <= "00000000000000000000000000000011";
            wait for half_period;
            
            wait; -- indefinitely suspend process
        end process;
end tb;