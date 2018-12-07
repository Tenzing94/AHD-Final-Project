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
       backdoor_input_button : in STD_LOGIC; -- SW(0)
       backdoor_input_values : in STD_LOGIC_VECTOR (7 downto 0); -- (SW(15):SW(9))
       mode: in std_logic_vector(1 downto 0);
       input_or_process: in STD_LOGIC; -- input or execution, mode selection
       pc_output : out std_logic_vector (31 downto 0);
       debug : out std_logic_vector(3 downto 0)
      );
end component;

    -- // Signals // --
    signal tRst : std_logic := '0';
    signal tOutA : std_logic_vector(31 downto 0); -- doutA
    signal tOutB : std_logic_vector(31 downto 0); -- doutB
    signal tBit_Flags : std_logic_vector(8 downto 0); -- led output
    signal tHal : std_logic; -- HALT signal
    signal tPC : std_logic_vector(31 downto 0); -- pc output
    -- dmem signals
    signal tBackdoorInput : std_logic;
    signal tBackdoorInputVals : std_logic_vector(7 downto 0);
    signal tMode : std_logic_vector(1 downto 0);
    signal tIP : std_logic;
    signal tDebug : std_logic_vector(3 downto 0);
    -- dout signals
    signal tEncDoutA : std_logic_vector(31 downto 0);
    signal tEncDoutB : std_logic_vector(31 downto 0);

    
    
    -- clock-specific signals
    signal tClk : std_logic := '0'; -- init. the clock (required!)
    constant clk_period : time := 10 ns; -- modifiable clock period
    constant input_period : time := 1 ns;
    constant cycle_time : time := 50000000 ps; -- avg + buffer time to reach a HALT command
    constant enc_mode_start : time := 800000 ns; -- start time for enc_mode, tHAL thrown
    constant enc_mode_end : time := 70000 ns; -- end time for enc_mode
    constant rst_mode_bounce : time := 340 ns;
    
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
            backdoor_input_values => tBackdoorInputVals,
            mode => tMode,
            input_or_process => tIP,
            debug => tDebug,
            pc_output => tPC);
   
--    Clock process (how the clock should behave)
    clk_process : process
    begin
         tClk <= '0';
         wait for clk_period/2;
         tClk <= '1';
         wait for clk_period/2;
    end process;


    
    -- Stimulus process (how other parts of the TB should behave
    stim_proc: process
    begin   
       tIP <= '0'; -- set to input
       tMode <= "00"; -- set to key expansion mode
       tRst <= '0';
       -- Key Expansion
       -- 0
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- 1
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --2
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --3
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --4
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --5
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --6
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --7
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --8
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --9
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --10
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --11
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --12
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --13
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --14
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --15
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "11111111";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       tBackdoorInput <= '0';


       -- switch to execution mode
       tBackdoorInputVals <= "00000000";
       tIP <= '1'; -- set to input
        
       -- Reset the CPU
       tRst <= '1';
       wait for clk_period;
       tRst <= '0';
       
       -- enc_mode
       wait for enc_mode_start;
       tIP <= '0';
       tMode <= "01";
       
       -- Data 0
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 1
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 2
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 3
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
        -- Data 4
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 5
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 5
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000000";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 6
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000001";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       tBackdoorInput <= '0';
       -- Data 7
       tBackdoorInput <= '0';
       tBackdoorInputVals <= "00000001";
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       tBackdoorInput <= '0';
           
       -- EXECUTE Encryption
       wait for 10 ns;
       tIP <= '1';
       tBackdoorInputVals <= "00000000";
       -- toggle the RST
       tRst <= '0';
       wait for rst_mode_bounce;
       tRst <= '1';
       wait for clk_period;
       tRst <= '0';
      
        
      -- SWITCH to decrypt mode
      wait for enc_mode_start;
      -- assign values
      tEncDoutA <= tOutA;
      tEncDoutB <= tOutB;
       tIP <= '0';
       tMode <= "10";
     
      -- Data 1
      wait for 2 ns;
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutA(31 downto 24);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- Data 2
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutA(23 downto 16);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- Data 3
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutA(15 downto 8);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- Data 4
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutA(7 downto 0);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- Data 5
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutB(31 downto 24);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- Data 6
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutB(23 downto 16);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- Data 7
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutB(15 downto 8);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- Data 8
      tBackdoorInput <= '0';
      tBackdoorInputVals <= tEncDoutB(7 downto 0);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      tBackdoorInput <= '0';

                 
       -- EXECUTE Decryption
       wait for 10 ns;
       tIP <= '1';
       tBackdoorInputVals <= "00000000";
       -- toggle the RST
       tRst <= '0';
       wait for rst_mode_bounce;
       tRst <= '1';
       wait for clk_period;
       tRst <= '0';
       
       
       wait;
    end process;
         
end testbench;