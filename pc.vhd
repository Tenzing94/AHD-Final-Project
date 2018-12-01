----------------------------------------------------------------------------------
-- Company: NYU Tandon Final
-- Engineer: Brent Rubell
-- 
-- Create Date: 11/05/2018 01:48:08 PM
-- Design Name: Program Counter - MIPS32
-- Module Name: pc - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pc is
    Port ( in_pc : in STD_LOGIC_VECTOR (31 downto 0);
           clr : in STD_LOGIC;
           clk : in STD_LOGIC;
           mode : in STD_LOGIC_VECTOR(1 downto 0);
           out_pc : out STD_LOGIC_VECTOR (31 downto 0));
end pc;

architecture Behavioral of pc is
signal pc_val : std_logic_vector(31 downto 0);

begin
  process (clk, clr, in_pc)
  begin
    if rising_edge(clk) then
        if(clr ='1') then
            if(mode = "00") then
                pc_val <= "00000000000000000000000000000000"; -- active hi rst
            elsif (mode = "01") then
                pc_val <= "00000000000000000000001100011000";
            elsif(mode = "10") then
                pc_val <= "00000000000000000000010100011000";
            else
                pc_val <= "00000000000000000000000000000000";
            end if;           
        else
            pc_val <= in_pc; -- load PC address
        end if;
    end if;
  end process;
 
out_pc <= pc_val;
 
end Behavioral;
