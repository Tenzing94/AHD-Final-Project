----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 01:33:07 PM
-- Design Name: 
-- Module Name: clk_slow - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


-- NOTE: THIS MODULE GENERATES A 1HZ CLOCK CYCLE (1S TIME PERIOD)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_slow is
    Port (
        clk_in : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end clk_slow;

architecture Behavioral of clk_slow is
    signal temporal: STD_LOGIC;
    signal counter : integer range 0 to 49999999 := 0; -- 100MHZ/1 = 100M. 50% duty cycle is 50M. Which is 0 to 49.99M
begin
    frequency_divider: process (clk_in) begin
        if rising_edge(clk_in) then
            if (counter = 49999999) then
                temporal <= NOT(temporal); -- if clk was high, then switch it to low since it has completed the period
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clk_out <= temporal; -- temporal is the constant value that represents clk rise/fall. 
end Behavioral;