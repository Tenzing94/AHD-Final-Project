----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2018 04:13:56 PM
-- Design Name: 
-- Module Name: ALU_FPGA_TB - ALU_FPGA_Body_TB
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_FPGA_TB is
--  Port ( );
end ALU_FPGA_TB;

architecture ALU_FPGA_Body_TB of ALU_FPGA_TB is

component ALU_FPGA
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
           SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           ALU_Control : in STD_LOGIC_VECTOR (2 downto 0);
           ALU_Result : out STD_LOGIC_VECTOR (31 downto 0);
           Flag_Zero : out STD_LOGIC;
           Flag_Negative : out STD_Logic);
end component;

signal A,B,ALU_Rslt : STD_LOGIC_VECTOR(31 downto 0);
signal Cntrl_Sig : STD_LOGIC_VECTOR(2 downto 0);
signal Flg_Zero, Flg_Neg : STD_LOGIC;
begin

Map_Signals: ALU_FPGA Port map( SrcA => A,
                                SrcB => B,
                                ALU_Control => Cntrl_Sig,
                                ALU_Result => ALU_Rslt,
                                Flag_Zero => Flg_Zero,
                                Flag_Negative => Flg_Neg);


ALU_Test: process
begin

    --Add
    A <= X"0000000A";
    B <= X"00000004";
    Cntrl_Sig <= "000";
    wait for 100 ns;
    
    --Sub
    A <= X"0000000A";
    B <= X"0000000A";
    Cntrl_Sig <= "001";
    wait for 100 ns;    
    
    --And
    A <= X"0000000A";
    B <= X"00000004";
    Cntrl_Sig <= "010";
    wait for 100 ns; 
    
    --Or
    A <= X"0000000A";
    B <= X"00000004";
    Cntrl_Sig <= "011";
    wait for 100 ns;
    
    --Nor
    A <= X"0000000A";
    B <= X"00000004";
    Cntrl_Sig <= "100";
    wait for 100 ns; 
    
    --SLL
    A <= X"000000F0";
    B <= X"00000004";
    Cntrl_Sig <= "101";
    wait for 100 ns;  
    
    --Halt
    A <= X"000000F0";
    B <= X"00000004";
    Cntrl_Sig <= "111";
    wait for 100 ns;
    
    --CMP
    A <= X"0000000E";
    B <= X"0000000F"; 
    Cntrl_Sig <= "110";
    wait for 100 ns;        
           
end process;


end ALU_FPGA_Body_TB;
