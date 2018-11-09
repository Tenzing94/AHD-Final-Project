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
    type ROM_type is array (0 to 19) of std_logic_vector(7 downto 0);
     constant rom_data: ROM_type:=(
       "00000000","00000001","00010000","00000001",
       "00000000","01000000","00001000","00000001",
       "00100000","10000001","00000000","00000000",
       "00011100","10000011","00000000","00000000",
       "11111100","00000000","00000000","00000000"
      );  
    begin
        out_imem <= rom_data(to_integer(unsigned(in_pc(31 downto 0)))) & rom_data(to_integer(unsigned(in_pc(31 downto 0)) + 1 )) & rom_data(to_integer(unsigned(in_pc(31 downto 0)) + 2 )) & rom_data(to_integer(unsigned(in_pc(31 downto 0)) + 3 ));
end Behavioral;
