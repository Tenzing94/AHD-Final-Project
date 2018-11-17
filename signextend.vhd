----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2018 05:00:33 PM
-- Design Name: 
-- Module Name: signextend - Behavioral
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

entity signextend is
    Port (
            input  : in std_logic_vector(15 downto 0);
            output : out std_logic_vector(31 downto 0)
    );
end signextend;


architecture Behavioral of signextend is

constant temp0 : std_logic_vector(15 downto 0) := "0000000000000000";
constant temp1 : std_logic_vector(15 downto 0) := "1111111111111111";


begin

    process(input)
    begin
        if (input(15) = '0') then
            output <= temp0 & input;
        else 
            output <= temp1 & input;
        end if;
    end process;

end Behavioral;
