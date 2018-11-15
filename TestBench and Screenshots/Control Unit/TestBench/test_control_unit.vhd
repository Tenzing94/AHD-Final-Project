----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2018 10:36:34 PM
-- Design Name: 
-- Module Name: test_control_unit - Behavioral
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

entity test_control_unit is
--  Port ( );
end test_control_unit;

architecture Behavioral of test_control_unit is

component control_unit
    Port ( opCode : in STD_LOGIC_VECTOR (5 downto 0);
           funct : in STD_LOGIC_VECTOR (5 downto 0);
           controlReg : out STD_LOGIC_VECTOR (8 downto 0));
end component;

signal op : STD_LOGIC_VECTOR(5 downto 0);
signal fun : STD_LOGIC_VECTOR(5 downto 0);
signal output : STD_LOGIC_VECTOR(8 downto 0);

signal period : time := 10 ns;

begin

cu: control_unit PORT MAP( opCode => op, funct => fun, controlReg => output  );

process
begin
    op <= "000000";     -- add
    fun <= "000001";
    
    wait for period;

    op <= "000001";     -- addi
    fun <= "000000";
    
    wait for period;    
    
    op <= "000000";     --sub         
    fun <= "000011";
    
     wait for period;
    
    op <= "000010";     -- subi
    fun <= "000000";
        
    wait for period;      
    
    op <= "000000";     -- and
    fun <= "000101";
    
    wait for period;

    op <= "000011";     -- andi
    fun <= "000000";
    
    wait for period;  
    
    op <= "000000";     -- or
    fun <= "000111";
    
    wait for period;  
    
    op <= "000000";     -- nor
    fun <= "001001";
    
    wait for period;  
    
    op <= "000100";     -- ori
    fun <= "000000";
    
    wait for period; 
    
    op <= "000101";     -- shl
    fun <= "000000";
    
    wait for period;  

    op <= "000111";     -- lw
    fun <= "000000";
    
    wait for period; 
    
    op <= "001000";     -- sw
    fun <= "000000";
    
    wait for period;
    
    op <= "001001";     -- blt
    fun <= "000000";
    
    wait for period;
    
    op <= "001010";     -- beq
    fun <= "000000";
    
    wait for period;
    
    op <= "001011";     -- bne
    fun <= "000000";
    
    wait for period;
    
    op <= "001100";     -- jump
    fun <= "000000";
    
    wait for period;
    
    op <= "111111";     -- hal
    fun <= "000000";
    
    wait for period;
      
end process;

end Behavioral;
