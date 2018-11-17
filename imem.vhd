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
    type ROM_type is array (0 to 59) of std_logic_vector(7 downto 0);
     constant rom_data: ROM_type:=(
          "00000100","00000001","00000000","00000100",
          "00000100","00000010","00000000","00001000",
          "00000000","00100001","00001000","00000001",
          "00101000","00100010","11111111","11111110",
          "00000100","00000011","00000000","00000011",
          "00000100","00000100","00000000","00000001",
          "00000100","10000100","00000000","00000001",
          "00101100","01100100","11111111","11111000",
          "00000100","00000101","00000000","00000001",
          "00000100","10100101","00000000","00000001",
          "00100100","10100011","11111111","11111000",
          "00110000","00000000","00000000","00011000",
          "00000100","00000110","00000000","11111111",
          "00000100","00000111","00000000","10101010",
          "11111100","00000000","00000000","00000000"
      );  
    begin
        out_imem <= rom_data(to_integer(unsigned(in_pc(31 downto 0)))) & rom_data(to_integer(unsigned(in_pc(31 downto 0)) + 1 )) & rom_data(to_integer(unsigned(in_pc(31 downto 0)) + 2 )) & rom_data(to_integer(unsigned(in_pc(31 downto 0)) + 3 ));
end Behavioral;

