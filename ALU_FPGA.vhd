----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2018 07:49:04 AM
-- Design Name: 
-- Module Name: ALU_FPGA - ALU_FPGA_Body
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

entity ALU_FPGA is
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
           SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           ALU_Control : in STD_LOGIC_VECTOR (2 downto 0);
           ALU_Result : out STD_LOGIC_VECTOR (31 downto 0);
           Flag_Zero : out STD_LOGIC;
           Flag_Negative : out STD_Logic);
end ALU_FPGA;

architecture ALU_FPGA_Body of ALU_FPGA is

component Add_Func
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

component Subtract_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

component AND_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

component OR_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

component NOR_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

component Shift_Left_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Shift_Amt : in STD_LOGIC_VECTOR (4 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

component CMP_Func is
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
           SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           Negative_Flag : out STD_LOGIC;
           Zero_Flag : out STD_LOGIC);
end component;

component Halt_Func is
    Port ( Output_Val : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal ALU_Output : STD_LOGIC_VECTOR (31 downto 0);
signal Output_Add, Output_Sub, Output_And, Output_Or, Output_Nor, Output_ShiftLL, Output_Halt : STD_LOGIC_VECTOR (31 downto 0); 
signal Zero_Flg_Add, Zero_Flg_Sub, Zero_Flg_And, Zero_Flg_Or, Zero_Flg_Nor, Zero_Flg_ShiftLL, Zero_Flg_CMP : STD_LOGIC;
signal Negative_Flag_CMP : STD_LOGIC;
begin

Map_Ports_Add:  Add_Func Port Map ( A_Source => SrcA,
                                    B_Source => SrcB,
                                    Output_Val => Output_Add,
                                    Zero_Flag => Zero_Flg_Add);
                                
Map_Ports_Sub:  Subtract_Func Port Map ( A_Source => SrcA,
                                         B_Source => SrcB,
                                         Output_Val => Output_Sub,
                                         Zero_Flag => Zero_Flg_Sub);                                

Map_Ports_And:  AND_Func Port Map ( A_Source => SrcA,
                                    B_Source => SrcB,
                                    Output_Val => Output_And,
                                    Zero_Flag => Zero_Flg_And);
                                    
Map_Ports_Or:  OR_Func Port Map ( A_Source => SrcA,
                                  B_Source => SrcB,
                                  Output_Val => Output_Or,
                                  Zero_Flag => Zero_Flg_Or);

Map_Ports_Nor: NOR_Func Port Map ( A_Source => SrcA,
                                   B_Source => SrcB,
                                   Output_Val => Output_Nor,
                                   Zero_Flag => Zero_Flg_Nor);
                                   
Map_Ports_SLL: Shift_Left_Func Port Map ( A_Source => SrcA,
                                          Shift_Amt => SrcB(4 downto 0),
                                          Output_Val => Output_ShiftLL,
                                          Zero_Flag => Zero_Flg_ShiftLL);

Map_Ports_CMP:  CMP_Func Port Map ( SrcA => SrcA,
                                    SrcB => SrcB,
                                    Negative_Flag => Negative_Flag_CMP,
                                    Zero_Flag => Zero_Flg_CMP);
                                    
Map_Ports_Halt: Halt_Func Port Map ( Output_Val => Output_Halt);
                                                                              
                                          
Select_Func: with ALU_Control select
             ALU_Output <= Output_Add when "000",
                           Output_Sub when "001",
                           Output_And when "010",
                           Output_Or when "011",
                           Output_Nor when "100",
                           Output_ShiftLL when "101",
                           Output_Halt when "111",
                           X"00000000" when others;
                 
Select_Zero_Flag: with ALU_Control select
                  Flag_Zero <= Zero_Flg_Add when "000",
                               Zero_Flg_Sub when "001",
                               Zero_Flg_And when "010",
                               Zero_Flg_Or when "011",
                               Zero_Flg_Nor when "100",
                               Zero_Flg_ShiftLL when "101",
                               Zero_Flg_CMP when "110",
                               '0' when others;
                               
Select_Negative_Flag: with ALU_Control select
                      Flag_Negative <= Negative_Flag_CMP when "110",
                      '0' when others;
                      
ALU_Result <= ALU_Output;
                                           
end ALU_FPGA_Body;