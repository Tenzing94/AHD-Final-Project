----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2018 10:51:28 PM
-- Design Name: 
-- Module Name: super_top_module - Behavioral
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

entity super_top_module is
    Port ( CLK100MHZ : in STD_LOGIC; -- internal clock
           BTNC      : in STD_LOGIC; -- clock button
           BTNU      : in STD_LOGIC; -- reset button
           CA        : out  std_logic_vector (6 downto 0); -- Cathodes
           AN        : out  std_logic_vector (7 downto 0); -- Anodes
           LED       : out STD_LOGIC_VECTOR (15 downto 0) -- LED output
      );
end super_top_module;


architecture Behavioral of super_top_module is

------------------------------ COMPONENTS ------------------------------
component debouncer is
    port(   clk : in std_logic; -- 100MHZ internal clock
            button_in : in std_logic;
            pulse_out : out std_logic
        );
end component;

component clk_slow is
    Port (
        clk_in : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end component;

component top_module is
    Port ( clk       : in STD_LOGIC;
           rst       : in STD_LOGIC;
           output    : out STD_LOGIC_VECTOR (31 downto 0);
           bit_flags : out STD_LOGIC_VECTOR (8 downto 0); -- LED output
           hal       : out STD_LOGIC
          );
end component;

component clk_for_ssd is
    Port (
        clk_in : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end component;

component seven_seg is
    Port ( 
           clk_for_ssd        : in std_logic; -- used by the seven seg display
           ss_input           : in std_logic_vector (31 downto 0); -- output from the top_module
           Cathode_Pattern    : out std_logic_vector (6 downto 0);
           AN_Activate        : out std_logic_vector (7 downto 0)
			);
end component;


------------------------------ SIGNALS ------------------------------
signal sig_clk_100Mhz, sig_clk_for_ssd : std_logic;
signal sig_BTNC : std_logic;
signal sig_SW_clk : std_logic;
signal sig_clock_button, sig_reset_button : std_logic;
signal sig_output : std_logic_vector(31 downto 0);
signal sig_bit_flags : std_logic_vector(8 downto 0);
signal sig_cathode : std_logic_vector(6 downto 0);
signal sig_anode : std_logic_vector(7 downto 0);
signal hal : std_logic;

begin

------------------------------ PORT MAPS ------------------------------
DBBTNC  : debouncer PORT MAP (clk => sig_clk_100Mhz, button_in => sig_BTNC, pulse_out => sig_clock_button);
TOP     : top_module PORT MAP (clk => sig_clock_button, rst => sig_reset_button, output => sig_output, bit_flags => sig_bit_flags, hal =>  hal);
CLKSSD  : clk_for_ssd PORT MAP (clk_in => sig_clk_100Mhz, clk_out => sig_clk_for_ssd);
SSD     : seven_seg PORT MAP (clk_for_ssd => sig_clk_for_ssd, ss_input => sig_output, Cathode_Pattern => sig_cathode, AN_Activate => sig_anode);


sig_clk_100Mhz <= CLK100MHZ;
sig_BTNC <= BTNC;
sig_reset_button <= BTNU; -- no need for a debouncer for the reset button
CA <= sig_cathode;
AN <= sig_anode;
LED(8 downto 0) <= sig_bit_flags;

with hal select
    LED(15 downto 9) <= "1111111" when '1',
                        "0000000" when others;

end Behavioral;
