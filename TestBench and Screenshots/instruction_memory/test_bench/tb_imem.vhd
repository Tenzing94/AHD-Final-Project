-- Testbench for AHD-MIPS-32
-- IMEM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_imem is
end tb_imem;

architecture testbench of tb_imem is
-- // Testbench Components // --
signal tInPc : std_logic_vector(31 downto 0);
signal tOutImem : std_logic_vector(31 downto 0);

constant clk_period : time := 10 ns;
    
begin
    -- // Testbench Components // --    
    -- Top Module
    UUT: entity work.imem port map(
            in_pc => tInPC,
            out_imem => tOutImem);
            
       -- Stimulus process
    process
    begin        
        -- PC = 0
        tInPc <= "00000000000000000000000000000000";
        wait for clk_period;
        
        -- PC = 1 
        tInPc <= "00000000000000000000000000000001";
        wait for clk_period;

        -- PC = 2
        tInPc <= "00000000000000000000000000000010";
        wait for clk_period;

        -- PC = 3
        tInPc <= "00000000000000000000000000000011";
        wait for clk_period;

        -- PC = 4
        tInPc <= "00000000000000000000000000000100";
        wait for clk_period;

        -- PC = 5
        tInPc <= "00000000000000000000000000000101";
        wait for clk_period;

        -- PC = 6
        tInPc <= "00000000000000000000000000000110";
        wait for clk_period;

        -- PC = 7
        tInPc <= "00000000000000000000000000000111";
        wait for clk_period;

        -- PC = 8
        tInPc <= "00000000000000000000000000001000";
        wait for clk_period;

        -- PC = 9
        tInPc <= "00000000000000000000000000001001";
        wait for clk_period;

        -- PC = 10
        tInPc <= "00000000000000000000000000001010";
        wait for clk_period;

        -- PC = 11
        tInPc <= "00000000000000000000000000001011";
        wait for clk_period;

        -- PC = 12
        tInPc <= "00000000000000000000000000001100";
        wait for clk_period;

        -- PC = 13
        tInPc <= "00000000000000000000000000001101";
        wait for clk_period;
        
end process;
end testbench;