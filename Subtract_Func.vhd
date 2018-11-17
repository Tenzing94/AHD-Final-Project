----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2018 09:30:50 AM
-- Design Name: 
-- Module Name: Subtract_Func - Subtract_Func_Body
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Subtract_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end Subtract_Func;

architecture Subtract_Func_Body of Subtract_Func is
signal Data_Out : signed (31 downto 0);
signal Data_Zero_Flag : STD_LOGIC;
begin
    Data_Out <= signed(A_Source) - signed(B_Source);
    with Data_Out select
        Data_Zero_Flag <= '1' when X"00000000",
                          '0' when others;
    Output_Val <= std_logic_vector(Data_Out);
    Zero_Flag <= Data_Zero_Flag;
end Subtract_Func_Body;
