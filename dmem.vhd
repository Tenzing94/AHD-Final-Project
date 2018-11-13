----------------------------------------------------------------------------------
-- Company: NYU Tandon AHD
-- Engineer: 
-- 
-- Create Date: 11/06/2018
-- Design Name: 
-- Module Name: dmem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Data Memory for MIPS32-AHD 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created (11/06/2018 03:49PM)
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity dmem is
    Port ( 
            CLK, WE : in std_logic;
            A, WD   : in std_logic_vector(31 downto 0);
            RD      : out std_logic_vector(31 downto 0)           
    );
end dmem;


architecture Behavioral of dmem is

-- Component Sign Extend
component signextend
    Port (
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0));
end component;

type RAM_Type is array (0 to 31) of std_logic_vector(15 downto 0);

signal RAM : RAM_Type := (
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000"
);

signal sig_input : std_logic_vector(15 downto 0);

begin
    
    process(clk)
    begin
        if (rising_edge(clk) AND WE = '1') then
            RAM(to_integer(unsigned(A(4 downto 0)))) <= WD(15 downto 0);
        end if;  
    end process;
    
    sig_input <= RAM(to_integer(unsigned(A(4 downto 0))));
    
    signext : signextend PORT MAP (input => sig_input, output => RD);

end Behavioral;
