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
           BTNC      : in STD_LOGIC; -- clock button -- DEBOUNCER YES
           BTNU      : in STD_LOGIC; -- reset button -- DEBOUNCER NO
           BTND      : in STD_LOGIC; -- clock select (select between internal slow clock and the clock button) -- DEBOUNCER YES
           BTNL      : in STD_LOGIC; -- input button (input from the switch goes into the dmem inside top module) -- DEBOUNCER YES
           BTNR      : in STD_LOGIC; -- display button (if button is pressed, r2 (B value) is shown on sseg. Else r1 (A value) is shown) -- DEBOUNCER NO
           SW        : in std_logic_vector (15 downto 0);
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

--component top_module is
--    Port ( clk       : in STD_LOGIC;
--           rst       : in STD_LOGIC;
--           outputA   : out STD_LOGIC_VECTOR (31 downto 0);
--           outputB   : out STD_LOGIC_VECTOR (31 downto 0);
--           bit_flags : out STD_LOGIC_VECTOR (8 downto 0); -- LED output
--           hal       : out STD_LOGIC;
--           backdoor_input_button : in STD_LOGIC;
--           backdoor_input_values : in STD_LOGIC_VECTOR (15 downto 0);
--           debug: out std_logic_vector(2 downto 0)
--          );
--end component;

component top_module is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           outputA : out STD_LOGIC_VECTOR (31 downto 0);
           outputB : out STD_LOGIC_VECTOR (31 downto 0);
           bit_flags : out STD_LOGIC_VECTOR (8 downto 0); -- LED output
           hal : out STD_LOGIC;
           backdoor_input_button : in STD_LOGIC;
           backdoor_input_values : in STD_LOGIC_VECTOR (7 downto 0);
           switch_1 : in STD_LOGIC;
           debug : out std_logic_vector(2 downto 0)
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
           ss_input          : in std_logic_vector (31 downto 0); -- outputA from the top_module
           Cathode_Pattern    : out std_logic_vector (6 downto 0);
           AN_Activate        : out std_logic_vector (7 downto 0)
			);
end component;


------------------------------ SIGNALS ------------------------------
signal sig_clk_100Mhz, sig_clk_slow, sig_clk_for_ssd : std_logic;
signal sig_BTNC, sig_BTND, sig_BTNL : std_logic;
signal sig_SW_clk : std_logic;
signal sig_clock_button, sig_clock_select, sig_input_button : std_logic;
signal sig_outputA, sig_outputB, sig_output : std_logic_vector(31 downto 0);
signal sig_bit_flags : std_logic_vector(8 downto 0);
signal sig_cathode : std_logic_vector(6 downto 0);
signal sig_anode : std_logic_vector(7 downto 0);
signal hal : std_logic;
signal sig_clock_in : std_logic := '0';

signal sig_toggle_clk : std_logic := '0'; -- toggle between internal slow clock and clock button

signal SW_temp : std_logic_vector(15 downto 0) := x"0000";
signal debug: std_logic_vector(2 downto 0);

begin

------------------------------ PORT MAPS ------------------------------
DBBTNC  : debouncer PORT MAP (clk => sig_clk_100Mhz, button_in => sig_BTNC, pulse_out => sig_clock_button);
DBBTND  : debouncer PORT MAP (clk => sig_clk_100Mhz, button_in => sig_BTND, pulse_out => sig_clock_select);
DBBTNL  : debouncer PORT MAP (clk => sig_clk_100Mhz, button_in => sig_BTNL, pulse_out => sig_input_button);
CLKSLOW : clk_slow PORT MAP (clk_in => sig_clk_100Mhz, clk_out => sig_clk_slow);
TOP     : top_module PORT MAP (clk => sig_clock_in, rst => BTNU,outputA => sig_outputA, outputB => sig_outputB, bit_flags => sig_bit_flags, hal =>  hal, backdoor_input_button => SW(0), backdoor_input_values => SW(15 downto 8), switch_1 => SW(1), debug => debug);
--TOP     : top_module PORT MAP (clk => sig_clock_in, rst => BTNU,outputA => sig_outputA, outputB => sig_outputB, bit_flags => sig_bit_flags, hal =>  hal, backdoor_input_button => BTNL, backdoor_input_values => SW,  debug => debug);
CLKSSD  : clk_for_ssd PORT MAP (clk_in => sig_clk_100Mhz, clk_out => sig_clk_for_ssd);
SSD     : seven_seg PORT MAP (clk_for_ssd => sig_clk_for_ssd, ss_input => sig_output, Cathode_Pattern => sig_cathode, AN_Activate => sig_anode);


sig_clk_100Mhz <= CLK100MHZ;
sig_BTNC <= BTNC;
sig_BTND <= BTND;
sig_BTNL <= BTNL;
CA <= sig_cathode;
AN <= sig_anode;
LED(8 downto 0) <= sig_bit_flags;

with hal select
    LED(15) <= '1' when '1',
                        '0' when others;

LED(9) <= sig_input_button;
LED(10) <= BTNU;
LED(13 downto 11) <= debug;

process(sig_clock_select)
begin
    if (sig_clock_select'event and sig_clock_select = '1') then
        if(sig_toggle_clk = '1') then
            sig_toggle_clk <= '0';
        elsif(sig_toggle_clk = '0') then
            sig_toggle_clk <= '1';
        end if;
                  
    end if;
end process;

with sig_toggle_clk select
     sig_clock_in  <= sig_clk_slow when '1',
                      sig_clock_button when others;

with BTNR select
    sig_output <= sig_outputA when '0',
                  sig_outputB when '1';

end Behavioral;
