----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2018 10:13:47 AM
-- Design Name: 
-- Module Name: Shift_Left_Func - Shift_Left_Func_Body
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shift_Left_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Shift_Amt : in STD_LOGIC_VECTOR (4 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end Shift_Left_Func;

architecture Shift_Left_Func_Body of Shift_Left_Func is
signal Data_Out : STD_LOGIC_VECTOR (31 downto 0);
signal Data_Zero_Flag : STD_LOGIC;
begin

    with Shift_Amt select
    Data_Out <= A_Source(30 downto 0) & '0' when "00001",
                A_Source(29 downto 0) & "00" when "00010",
                A_Source(28 downto 0) & "000" when "00011",
                A_Source(27 downto 0) & "0000" when "00100",
                A_Source(26 downto 0) & "00000" when "00101",
                A_Source(25 downto 0) & "000000" when "00110",
                A_Source(24 downto 0) & "0000000" when "00111",
                A_Source(23 downto 0) & "00000000" when "01000",
                A_Source(22 downto 0) & "000000000" when "01001",
                A_Source(21 downto 0) & "0000000000" when "01010",
                A_Source(20 downto 0) & "00000000000" when "01011",
                A_Source(19 downto 0) & "000000000000" when "01100",
                A_Source(18 downto 0) & "0000000000000" when "01101",
                A_Source(17 downto 0) & "00000000000000" when "01110",
                A_Source(16 downto 0) & "000000000000000" when "01111",
                A_Source(15 downto 0) & "0000000000000000" when "10000",
                A_Source(14 downto 0) & "00000000000000000" when "10001",
                A_Source(13 downto 0) & "000000000000000000" when "10010",
                A_Source(12 downto 0) & "0000000000000000000" when "10011",
                A_Source(11 downto 0) & "00000000000000000000" when "10100",
                A_Source(10 downto 0) & "000000000000000000000" when "10101",
                A_Source(9 downto 0)  & "0000000000000000000000" when "10110",
                A_Source(8 downto 0)  & "00000000000000000000000" when "10111",
                A_Source(7 downto 0)  & "000000000000000000000000" when "11000",
                A_Source(6 downto 0)  & "0000000000000000000000000" when "11001",
                A_Source(5 downto 0)  & "00000000000000000000000000" when "11010",
                A_Source(4 downto 0)  & "000000000000000000000000000" when "11011",
                A_Source(3 downto 0)  & "0000000000000000000000000000" when "11100",
                A_Source(2 downto 0)  & "00000000000000000000000000000" when "11101",
                A_Source(1 downto 0)  & "000000000000000000000000000000" when "11110",
                A_Source(0)           & "0000000000000000000000000000000" when "11111",
                A_Source when others;
                
    with Data_Out select
    Data_Zero_Flag <= '1' when X"00000000",
                      '0' when others;
    Output_Val <= Data_Out;
    Zero_Flag <= Data_Zero_Flag;
end Shift_Left_Func_Body;
