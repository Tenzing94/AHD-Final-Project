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
    type ROM_type is array (0 to 2) of std_logic_vector(31 downto 0);
     constant rom_data: ROM_type:=(
       "00000000000000000000000000000001",
       "00000000000000000000000000000010",
       "00000000000000000000000000000011"
      );  
    begin
        out_imem <= rom_data(to_integer(unsigned(in_pc(31 downto 2))));
end Behavioral;
