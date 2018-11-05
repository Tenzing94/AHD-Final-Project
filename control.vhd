----------------------------------------------------------------------------------
-- Company: NYU Tandon AHD
-- Engineer: 
-- 
-- Create Date: 11/05/2018 02:47:33 PM
-- Design Name: 
-- Module Name: control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Control Unit for MIPS32-AHD 
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

entity control is
    Port ( imem_in : in STD_LOGIC_VECTOR (31 downto 0);
           isBranch, memToReg, memWrite, aluSrc, regDst, regWrite : out STD_LOGIC;
           aluControl : out std_logic_vector(2 downto 0));
end control;

architecture Behavioral of control is
-- signals --
signal tOpcode : std_logic_vector(5 downto 0);
signal tRs : std_logic_vector(4 downto 0);
signal tRt : std_logic_vector(4 downto 0);
signal tRd : std_logic_vector(4 downto 0);
signal tFunction : std_logic_vector(5 downto 0);
signal tShamt : std_logic_vector(4 downto 0);
signal tIMM : std_logic_vector(15 downto 0);
signal tAddr : std_logic_vector(25 downto 0);

begin
-- begin decoding instruction -- 

-- breaking down instruction into signals for each type
-- R-TYPE -- 
tOpcode <= imem_in(31 downto 25);
tRs <= imem_in(25 downto 20); 
tRt <= imem_in(20 downto 15);
tRd <= imem_in(15 downto 10);
tShamt <= imem_in(10 downto 5);
tFunction <= imem_in(5 downto 0);

-- I-Type -- 
tIMM <= imem_in(15 downto 0);

-- J-Type
tAddr <= imem_in(25 downto 0);


-- handle branching


end Behavioral;


