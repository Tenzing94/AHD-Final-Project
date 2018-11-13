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
    signal tClk100 : std_logic;
    signal tSwitch : std_logic;
    signal tLED : std_logic_vector(12 downto 0);
    signal tSw : std_logic_vector(2 downto 0);
    
    constant clk_period : time := 10 ns;
    
begin
    -- // Testbench Components // --    
    -- Top Module
    UUT: entity work.top_module port map(
            clk100 => tClk100,
            LED => tLED,
            SW => tSw,
            clk => tClk,
            rst => tRst,
            output => tOut);
            
   -- Clock process definitions
    clk_process :process
    begin
         tClk <= '0';
         wait for clk_period/2;
         tClk <= '1';
         wait for clk_period/2;
    end process;
    
       -- Stimulus process
    stim_proc: process
    begin        
       -- hold reset state high for 100ns
       tRst <= '1';
       wait for 100 ns;    
       wait for clk_period*10;

       -- start cpu (starts the PC) 
       tRst <='0';
 
       wait;
    end process;
end testbench;