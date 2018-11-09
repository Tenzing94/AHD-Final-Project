----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2018 01:34:41 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    Port ( opCode : in STD_LOGIC_VECTOR (5 downto 0);
           funct : in STD_LOGIC_VECTOR (5 downto 0);
           controlReg : out STD_LOGIC_VECTOR (8 downto 0));
end control_unit;

architecture Behavioral of control_unit is

Signal controlReg_temp : STD_LOGIC_VECTOR(8 downto 0);
begin

process( opCode, funct )
Begin
    
    -- Get function
    case opCode is
        when "000000" =>             -- It is R-Type
            -- Case funct for R-Type
            case funct is
                when "000001" =>        -- ADD
                    controlReg_temp <= "000000011";
                when "000011" =>        -- SUB
                    controlReg_temp <= "000001011";
                when "000101" =>        -- AND
                    controlReg_temp <= "000010011";
                when "000111" =>        -- OR
                    controlReg_temp <= "000011011";
                when "001001" =>        -- NOR
                    controlReg_temp <= "000100011";
                when others =>
                    controlReg_temp <= "000111000";
            end case;
              
        when "000001" =>        --ADDI
            controlReg_temp <= "000000101";
        when "000010" =>        --SUBI
            controlReg_temp <= "000001101";
        when "000011" =>        --ANDI    
            controlReg_temp <= "000010101";
        when "000100" =>        --ORI    
            controlReg_temp <= "000011101";
        when "000101" =>        --SHL    
            controlReg_temp <= "000101101";
        when "000111" =>        --LW    
            controlReg_temp <= "100000101";
        when "001000" =>        --SW    
            controlReg_temp <= "010000100";
        when "001001" =>        --BLT
            controlReg_temp <= "001110000";
        when "001010" =>        --BEQ
            controlReg_temp <= "001110000";
        when "001011" =>        --BNE
            controlReg_temp <= "001110000";
        when "001100" =>        --JMP
            controlReg_temp <= "000000000";                            
        when others =>          --HLT
            controlReg_temp <= "000111000";
    end case;
        
end process;

controlReg <= controlReg_temp;

end Behavioral;
