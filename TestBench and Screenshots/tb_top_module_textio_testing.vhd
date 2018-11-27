-- // Testbench for MIPS32 // --
-- NYU Fall 2018, Group 5

-- TEXTIO Test

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
           output : out STD_LOGIC_VECTOR (31 downto 0);
           bit_flags : out STD_LOGIC_VECTOR (8 downto 0);
           hal : out STD_LOGIC
           backdoor_input_button : in std_logic;
           backdoor_input_values : in std_logic_vector(15 downto 0);
          );
end component;

    -- // Signals // --
    signal tRst : std_logic := '0';
    signal tOut : std_logic_vector(31 downto 0); -- dout
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
            output => tOut,
            bit_flags => tBit_Flags,
            hal => tHal,
            backdoor_input_button => tBackdoorInput,
            backdoor_input_values => tBackdoorInputVals);
    
    
    
    -- file process for DIN/DOUT
    file_io:
    PROCESS IS
        FILE in_file : TEXT OPEN READ_MODE IS "din_values"; -- din_values.txt
        FILE out_file : TEXT OPEN WRITE_MODE IS "dout_values"; -- dout_values.txt
        VARIABLE out_line : LINE;
        VARIABLE in_line : LINE;
        variable a_reg : std_logic_vector(15 downto 0);
        variable b_reg : std_logic_vector(15 downto 0);
        -- 
        VARIABLE dout : STD_LOGIC_VECTOR(31 downto 0);
            BEGIN
                WHILE NOT ENDFILE(in_file) LOOP --do this till out of data
                
                    READLINE(in_file, in_line); --get line of input stimulus
                    READ(in_line, a); --get A input
                    READ(in_line, b); --get B input
                    -- assign variable c to the dout
                    -- c = DOUT
                    --   WRITE(out_line, c); --save results to line
                    --    WRITELINE(out_file, out_line); --write line to file
             END LOOP;
             ASSERT FALSE REPORT "Simulation done" SEVERITY NOTE;
             WAIT; --allows the simulation to halt!
    END PROCESS;

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
       -- TODO: Add in dmem configuration
       wait for clk_period;

       -- start cpu (starts the PC) 
       tRst <='0';
       wait for cycle_time;
    end process;
end testbench;
