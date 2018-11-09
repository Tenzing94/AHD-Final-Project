-- Testbench for AHD-MIPS-32
-- AHD, Fall 2018

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_top_module is
end tb_top_module;

architecture testbench of tb_top_module is
    -- // Testbench Components // --
    signal tRst : std_logic;
    signal tOut : std_logic_vector(31 downto 0);
    signal tClk : std_logic := '0'; -- init. the clock (required!)
    
begin
    -- // Testbench Components // --    
    -- Top Module
    UUT: entity work.top_module port map(
            clk => tClk,
            rst => tRst,
            output => tOut);
            

    tb1 : process
        constant period: time := 5 ns;
        begin
            --RST the top module, cycle 1
            tClk <= '1'; wait for period;
            tRst <= '1';           
            tClk <= '0'; wait for period;
            
            --  RST low - cycle 2
            tClk <= '1'; wait for period;
            tRst <= '0';           
            tClk <= '0'; wait for period;
            
            --  RST low - cycle 3
            tClk <= '1'; wait for period;
            tRst <= '0';           
            tClk <= '0'; wait for period;
            
            --  RST low - cycle 4
            tClk <= '1'; wait for period;
            tRst <= '0';           
            tClk <= '0'; wait for period;
            
            -- RST low - cycle 5
            tClk <= '1'; wait for period;
            tRst <= '0';           
            tClk <= '0'; wait for period;
            
            -- RST low - cycle 6
            tClk <= '1'; wait for period;
            tRst <= '0';           
            tClk <= '0'; wait for period;
        end process;
end testbench;