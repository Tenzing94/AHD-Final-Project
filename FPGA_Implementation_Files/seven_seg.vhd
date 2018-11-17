----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2018 12:27:44 PM
-- Design Name: 
-- Module Name: seven_seg - Behavioral
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

entity seven_seg is
    Port ( 
           clk_for_ssd        : in std_logic; -- used by the seven seg display
           ss_input           : in std_logic_vector (31 downto 0); -- output from the top_module
           Cathode_Pattern    : out std_logic_vector (6 downto 0);
           AN_Activate        : out std_logic_vector (7 downto 0)
			);
end seven_seg;

architecture Behavioral of seven_seg is

signal output : std_logic_vector(3 downto 0);
signal switch_between_displays : std_logic_vector(2 downto 0) := "000";


begin
    
    process (output)
    begin
        case output(3 downto 0) is
            when "0000" => Cathode_Pattern <= "1000000"; -- "0"
            when "0001" => Cathode_Pattern <= "1111001"; -- "1" 
            when "0010" => Cathode_Pattern <= "0100100"; -- "2" 
            when "0011" => Cathode_Pattern <= "0110000"; -- "3" 
            when "0100" => Cathode_Pattern <= "0011001"; -- "4" 
            when "0101" => Cathode_Pattern <= "0010010"; -- "5" 
            when "0110" => Cathode_Pattern <= "0000010"; -- "6" 
            when "0111" => Cathode_Pattern <= "1111000"; -- "7" 
            when "1000" => Cathode_Pattern <= "0000000"; -- "8"     
            when "1001" => Cathode_Pattern <= "0010000"; -- "9" 
            when "1010" => Cathode_Pattern <= "0001000"; -- a
            when "1011" => Cathode_Pattern <= "0000011"; -- b
            when "1100" => Cathode_Pattern <= "1000110"; -- C
            when "1101" => Cathode_Pattern <= "0100001"; -- d
            when "1110" => Cathode_Pattern <= "0000110"; -- E
            when "1111" => Cathode_Pattern <= "0001110"; -- F
            when others => Cathode_Pattern <= "1111111"; -- NULL
        end case;
    end process;

    -- I did NOT use a debouncer for the display button
    process(clk_for_ssd)
    begin
        if (clk_for_ssd'event AND clk_for_ssd = '1') then
            if (switch_between_displays = "000") then
                output <= ss_input(31 downto 28);
                switch_between_displays <= "001";
                AN_Activate <= "01111111";
            elsif (switch_between_displays = "001") then
                output <= ss_input(27 downto 24);
                switch_between_displays <= "010";
                AN_Activate <= "10111111";
            elsif (switch_between_displays = "010") then
                output <= ss_input(23 downto 20);
                switch_between_displays <= "011";
                AN_Activate <= "11011111";
            elsif (switch_between_displays = "011") then
                output <= ss_input(19 downto 16);
                switch_between_displays <= "100";
                AN_Activate <= "11101111";
            elsif (switch_between_displays = "100") then
                output <= ss_input(15 downto 12);
                switch_between_displays <= "101";
                AN_Activate <= "11110111";
            elsif (switch_between_displays = "101") then
                output <= ss_input(11 downto 8);
                switch_between_displays <= "110";
                AN_Activate <= "11111011";
            elsif (switch_between_displays = "110") then
                output <= ss_input(7 downto 4);
                switch_between_displays <= "111";
                AN_Activate <= "11111101";
            elsif (switch_between_displays = "111") then
                output <= ss_input(3 downto 0);
                switch_between_displays <= "000";
                AN_Activate <= "11111110";
            end if;  
         end if;

    end process;
        
end Behavioral;
