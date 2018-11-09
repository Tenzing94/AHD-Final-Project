----------------------------------------------------------------------------------
-- Company: NYU Tandon AHD
-- Engineer: 
-- 
-- Create Date: 11/05/2018 02:34:14 PM
-- Design Name: 
-- Module Name: imem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Tenzing - I changed line 40 from '(31 downto 2)' to '(31 downto 0)'
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity imem is
    Port ( 
           in_pc : in std_logic_vector (31 downto 0);
           out_imem : out std_logic_vector (31 downto 0));
end imem;

architecture Behavioral of imem is
    -- ROM: Instruction Memory -- 
    type ROM_type is array (0 to 3) of std_logic_vector(31 downto 0);
     constant rom_data: ROM_type:=(
       "00000000000000010001000000000001",
       "00000000010000000000100000000001",
       "00100000100000010000000000000000",
       "00011100100000110000000000000000"
      );  
    begin
        out_imem <= rom_data(to_integer(unsigned(in_pc(31 downto 0))));
end Behavioral;
