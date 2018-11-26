-- // Testbench for MIPS32 // --
-- NYU Fall 2018, Group 5

-- lib imports
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_top_module is
end tb_top_module;

architecture testbench of tb_top_module is

component top_module is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           bit_flags : out STD_LOGIC_VECTOR (8 downto 0); -- LED output
           hal : out STD_LOGIC
          );
end component;

    -- // Signals // --
    signal tRst : std_logic := '0';
    signal tOut : std_logic_vector(31 downto 0); -- dout
    -- we don't have the LEDs on this testbench, so
    -- assign them to signals.
    signal tBit_Flags : std_logic_vector(8 downto 0); 
    signal tHal : std_logic; -- HALT signal
    
    -- clock-specific signals
    signal tClk : std_logic := '0'; -- init. the clock (required!)
    constant clk_period : time := 10 ns; -- modifiable clock period
    constant cycle_time : time := 50000000 ps; -- avg + buffer time to reach a HALT command
    
begin
    -- // Testbench Components // --    
    -- Top Module
    UUT: top_module port map(
            clk => tClk,
            rst => tRst,
            output => tOut,
            bit_flags => tBit_Flags,
            hal => tHal);
            
            
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
       wait for clk_period;

       -- start cpu (starts the PC) 
       tRst <='0';
       wait for cycle_time;
    end process;
end testbench;
