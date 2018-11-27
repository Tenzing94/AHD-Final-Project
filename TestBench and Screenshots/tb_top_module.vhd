-- // Testbench for MIPS32 // --
-- NYU Fall 2018, Group 5

-- lib imports
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use STD.TEXTIO.ALL;

entity tb_top_module is
end tb_top_module;

architecture testbench of tb_top_module is

component top_module is
    Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       outputA : out STD_LOGIC_VECTOR (31 downto 0);
       outputB : out STD_LOGIC_VECTOR (31 downto 0);
       bit_flags : out STD_LOGIC_VECTOR (8 downto 0); -- LED output
       hal : out STD_LOGIC;
       backdoor_input_button : in STD_LOGIC;
       backdoor_input_values : in STD_LOGIC_VECTOR (15 downto 0)
      );
end component;

    -- // Signals // --
    signal tRst : std_logic := '0';
    signal tOutA : std_logic_vector(31 downto 0); -- doutA
    signal tOutB : std_logic_vector(31 downto 0); -- doutB
    signal tBit_Flags : std_logic_vector(8 downto 0); -- led output
    signal tHal : std_logic; -- HALT signal
    -- dmem signals
    signal tBackdoorInput : std_logic;
    signal tBackdoorInputVals : std_logic_vector(15 downto 0);
    
    -- clock-specific signals
    signal tClk : std_logic := '0'; -- init. the clock (required!)
    constant clk_period : time := 10 ns; -- modifiable clock period
    constant cycle_time : time := 50000000 ps; -- avg + buffer time to reach a HALT command
    
begin
     
    -- Top Module
    UUT: top_module port map(
            clk => tClk,
            rst => tRst,
            outputA => tOutA,
            outputB => tOutB,
            bit_flags => tBit_Flags,
            hal => tHal,
            backdoor_input_button => tBackdoorInput,
            backdoor_input_values => tBackdoorInputVals);
   

   -- Clock process (how the clock should behave)
    clk_process :process
    begin
         tClk <= '0';
         wait for clk_period/2;
         tClk <= '1';
         wait for clk_period/2;
    end process;
    
    -- Stimulus process (how other parts of the TB should behave
    stim_proc: process
    begin   
       -- reset the CPU     
       -- hold reset state high for 100ns
       tRst <= '1';
       wait for 20 ns;
       tRst <= '0';
       tBackdoorInputVals <= "0000000000000000";
       wait for clk_period/2;
       tBackdoorInput <= '1';
       wait for clk_period/2;

       tBackdoorInputVals <= "0000000000000000";
       wait for clk_period/2;
       tBackdoorInput <= '1';
       wait for clk_period/2;
        
              
       wait for clk_period;

       -- start cpu (starts the PC) 
       tRst <='0';
       wait for cycle_time;
    end process;
end testbench;
