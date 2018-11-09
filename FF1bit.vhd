----------------------------------------------------------------------------------
-- Company: NYU Tandon AHD
-- Engineer: 
-- 
-- Create Date: 11/06/2018
-- Design Name: 
-- Module Name: FF1bit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Flip Flop with 1 bit input and output for MIPS32-AHD 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created (11/06/2018 12:55PM)
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FF1bit is
    Port (
            clk, input : in std_logic;
            output     : out std_logic 
    
    );
end FF1bit;

architecture Behavioral of FF1bit is

signal temp : std_logic;

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            temp <= input;
        end if;
    
    output <= temp;
    end process;


end Behavioral;
