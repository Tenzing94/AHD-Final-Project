----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2018 03:52:52 PM
-- Design Name: 
-- Module Name: tb_corner_cases - Behavioral
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


-- lib imports
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

USE	WORK.PKG.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_corner_cases is
--  Port ( );
end tb_corner_cases;

architecture Behavioral of tb_corner_cases is

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
       debug : out std_logic_vector(3 downto 0);
       reg_out    : out Register_Type
      );
end component;

 -- convert std_logic_vector to string for writing to the console
   FUNCTION vec2str(vec : std_logic_vector) RETURN string IS
            VARIABLE stmp : string(vec'LEFT+1 DOWNTO 1);
            BEGIN
            FOR i IN vec'REVERSE_RANGE LOOP
            IF vec(i) = '1' THEN
            stmp(i+1) := '1';
            ELSIF vec(i) = '0' THEN
            stmp(i+1) := '0';
            ELSE
            stmp(i+1) := 'X';
            END IF;
            END LOOP;
            RETURN stmp;
    END vec2str;

-- // Signals // --
    signal tRst : std_logic := '0';
    signal tOutA : std_logic_vector(31 downto 0); -- doutA
    signal tOutB : std_logic_vector(31 downto 0); -- doutB
    signal tBit_Flags : std_logic_vector(8 downto 0); -- led output
    signal tHal : std_logic; -- HALT signal
    signal tPC : std_logic_vector(31 downto 0); -- pc output
    signal tRegOut : Register_Type;
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
    
    signal sig_enc : std_logic_vector(63 downto 0);
    signal sig_dec : std_logic_vector(63 downto 0);
    
    signal counter : integer:= 0;
    
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
            pc_output => tPC,
            reg_out => tRegOut);
   
--    Clock process (how the clock should behave)
    clk_process : process
    begin
         tClk <= '0';
         wait for clk_period/2;
         tClk <= '1';
         wait for clk_period/2;
    end process;

    
    -- MAIN PROCESS LOOP
    stim_proc: process
    
    -- IO
    variable good: boolean; --status of the read operation
    variable vt_key : std_logic_vector(127 downto 0);
    variable vt_din : std_logic_vector(63 downto 0);
    variable vt_dec : std_logic_vector(63 downto 0);
    

    begin   
        
    -- TCL output
    counter <= counter + 1;
    write(std.textio.OUTPUT, "" & LF); -- newline
    WRITE(OUTPUT,string'("--RUN --  "));
    WRITE(OUTPUT, integer'image(counter)); 
    WRITE(OUTPUT,string'("   KEY GEN + ENCRYPT  --------"));
    write(std.textio.OUTPUT, "" & LF); -- newline
    
    -- Set input key value
    vt_key := x"00000000000000000000000000000000";
    

     vt_din := x"0000000000000000";

     vt_dec := "1110111011011011101001010010000101101101100011110100101100010101";
     
     -- TCL output
      write(std.textio.OUTPUT, "" & LF); -- newline
      WRITE(OUTPUT,string'("Skey: "));            
      WRITE(OUTPUT, vec2str(vt_key));  
      write(std.textio.OUTPUT, "" & LF); -- newline
      
      -- TCL output
       WRITE(OUTPUT,string'("DIN: "));            
       WRITE(OUTPUT, vec2str(vt_din));  
       write(std.textio.OUTPUT, "" & LF); -- newline
       
       -- TCL output
       WRITE(OUTPUT,string'("ENC_Expected: "));            
       WRITE(OUTPUT, vec2str(vt_dec));  
       write(std.textio.OUTPUT, "" & LF); -- newline
       
     sig_enc <= vt_dec; 
      
    -- Get Decrypt or input value from text
    sig_dec <= vt_din;
    
    -- SWITCH: Input Mode
    tIP <= '0'; -- set to input
    tMode <= "00"; -- set to key expansion mode
    tRst <= '0';
       
       -- INPUT: Key Expansion
       -- 0
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(126 downto 119);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- 1
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(118 downto 111);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --2
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(110 downto 103);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --3
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(102 downto 95);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --4
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(94 downto 87);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --5
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(86 downto 79);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --6
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(79 downto 72);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --7
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(71 downto 64);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --8
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(63 downto 56);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --9
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(55 downto 48);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --10
       tBackdoorInput <= '0';
       tBackdoorInputVals <=  vt_key(47 downto 40);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --11
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(39 downto 32);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --12
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(31 downto 24);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --13
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(23 downto 16);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --14
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(15 downto 8);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       --15
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_key(7 downto 0);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       tBackdoorInput <= '0';


       -- SWITCH MODE: to execution mode
       tBackdoorInputVals <= "00000000";
       tIP <= '1'; -- set to input
       -- Reset the CPU
       tRst <= '1';
       wait for clk_period;
       tRst <= '0';
       
       -- INPUT: ENCRYPTION
       wait for enc_mode_start;
       tIP <= '0';
       tMode <= "01";
       -- Data 1
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(63 downto 56);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 2
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(55 downto 48);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 3
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(47 downto 40);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
        -- Data 4
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(39 downto 32);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 5
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(31 downto 24);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 5
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(23 downto 16);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       -- Data 6
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(15 downto 8);
       wait for clk_period;
       tBackdoorInput <= '1';
       wait for clk_period;
       tBackdoorInput <= '0';
       -- Data 7
       tBackdoorInput <= '0';
       tBackdoorInputVals <= vt_din(7 downto 0);
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

       
       -- wait for signal to become stable
       wait for 700 us;
       
       -- check if the halt has been thrown
       if(tHal='1') then
        -- write results to local console Encrypt
        write(OUTPUT, "---Test Complete---");
        write(std.textio.OUTPUT, "" & LF); -- newline     
        write(OUTPUT, "DOUT: ( Encrypter ) "); 
        write(OUTPUT, vec2str(tEncDoutA) & vec2str(tEncDoutB));
        write(std.textio.OUTPUT, "" & LF); -- newline  
        
        
        if(sig_enc = tEncDoutA&tEncDoutB) then
            write(output, "SUCCESS: Encrypt vector match");
        else
            write(output, "FAILURE: Encrypt vector mismatch");
        end if;
        
        write(std.textio.OUTPUT, "" & LF); -- newline
        assert(sig_enc = tEncDoutA&tEncDoutB)
        report " Encrypt Failed!"
        severity error;
        
        write(std.textio.OUTPUT, "" & LF); -- newline
        write(OUTPUT, "--------------------------------------------------------------------------------------------------------------------------------------------------------------------");   
        write(std.textio.OUTPUT, "" & LF); -- newline
       
       end if;
       
       
       -- Round 2 Key Gen and Decryption
       
       -- TCL output
       counter <= counter + 1;
       write(std.textio.OUTPUT, "" & LF); -- newline
       WRITE(OUTPUT,string'("--RUN --  "));
       WRITE(OUTPUT, integer'image(counter)); 
       WRITE(OUTPUT,string'("  KEY GEN + DECRYPT --------"));
       write(std.textio.OUTPUT, "" & LF); -- newline
       
       -- Set input key value
        vt_key := x"00000000000000000000000000000000";
   
        vt_din := x"0000000000000000";   
        vt_dec := x"EEDBA5216D8F4B15";
        
         -- TCL output
         write(std.textio.OUTPUT, "" & LF); -- newline
         WRITE(OUTPUT,string'("Skey: "));            
         WRITE(OUTPUT, vec2str(vt_key));  
         write(std.textio.OUTPUT, "" & LF); -- newline
         
         -- TCL output
          WRITE(OUTPUT,string'("DEC_IN: "));            
          WRITE(OUTPUT, vec2str(vt_dec));  
          write(std.textio.OUTPUT, "" & LF); -- newline
          
          -- TCL output
         WRITE(OUTPUT,string'("Output_Expected: "));            
         WRITE(OUTPUT, vec2str(vt_din));  
         write(std.textio.OUTPUT, "" & LF); -- newline
          
        sig_enc <= vt_dec; 
         
        -- Get Decrypt or input value from text
        sig_dec <= vt_din;
       
       -- assign values
       tEncDoutA <= vt_dec(63 downto 32);
       tEncDoutB <= vt_dec(31 downto 0);
       
       -- SWITCH: Input Mode
       tIP <= '0'; -- set to input
       tMode <= "00"; -- set to key expansion mode
       tRst <= '0';
      
      -- INPUT: Key Expansion
      -- 0
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(126 downto 119);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      -- 1
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(118 downto 111);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --2
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(110 downto 103);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --3
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(102 downto 95);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --4
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(94 downto 87);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --5
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(86 downto 79);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --6
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(79 downto 72);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --7
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(71 downto 64);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --8
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(63 downto 56);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --9
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(55 downto 48);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --10
      tBackdoorInput <= '0';
      tBackdoorInputVals <=  vt_key(47 downto 40);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --11
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(39 downto 32);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --12
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(31 downto 24);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --13
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(23 downto 16);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --14
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(15 downto 8);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      --15
      tBackdoorInput <= '0';
      tBackdoorInputVals <= vt_key(7 downto 0);
      wait for clk_period;
      tBackdoorInput <= '1';
      wait for clk_period;
      tBackdoorInput <= '0';


      -- SWITCH MODE: to execution mode
      tBackdoorInputVals <= "00000000";
      tIP <= '1'; -- set to input
      -- Reset the CPU
      tRst <= '1';
      wait for clk_period;
      tRst <= '0';
      
      wait for enc_mode_start;
      
     tIP <= '0';
     tMode <= "10";
   
    -- INPUT: Decryption Mode
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
         
      -- wait for signal to become stable
      wait for 700 us;
      
      -- check if the halt has been thrown
      if(tHal='1') then
         -- write results to local console Decrypt
         write(std.textio.OUTPUT, "" & LF); -- newline
         write(OUTPUT, "---Test Complete---");
         write(std.textio.OUTPUT, "" & LF); -- newline     
         write(OUTPUT, "DOUT: ( Decrypt ) "); 
         write(OUTPUT, vec2str(tOutA) & vec2str(tOutB));
         write(std.textio.OUTPUT, "" & LF); -- newline
         
         if(sig_dec = tOutA&tOutB) then
             write(output, "SUCCESS: Decrypt vector match");
         else
             write(output, "FAILURE: Decrypt vector mismatch");
         end if;
         
         write(std.textio.OUTPUT, "" & LF); -- newline
         assert(sig_dec = tOutA&tOutB)
         report " Decrypt Failed!"
         severity error;
             
        write(std.textio.OUTPUT, "" & LF); -- newline
        write(OUTPUT, "--------------------------------------------------------------------------------------------------------------------------------------------------------------------");   
        write(std.textio.OUTPUT, "" & LF); -- newline
      
      end if;
       
       
       -- Rond 3 Key + enc1 + enc2
       
       
       -- enc 1
       -- TCL output
       counter <= counter + 1;
       write(std.textio.OUTPUT, "" & LF); -- newline
       WRITE(OUTPUT,string'("--RUN --  "));
       WRITE(OUTPUT, integer'image(counter)); 
       WRITE(OUTPUT,string'("   KEY GEN + ENCRYPT 1 + ENCRYPT 2--------"));
       write(std.textio.OUTPUT, "" & LF); -- newline
       
       -- Set input key value
       vt_key := x"00000000000000000000000000000000";
       
   
       vt_din := x"0000000000000000";
   
        vt_dec := "1110111011011011101001010010000101101101100011110100101100010101";
        
        WRITE(OUTPUT,string'("-------------ENCRYPT 1------------"));
        write(std.textio.OUTPUT, "" & LF); -- newline
        -- TCL output
         write(std.textio.OUTPUT, "" & LF); -- newline
         WRITE(OUTPUT,string'("Skey: "));            
         WRITE(OUTPUT, vec2str(vt_key));  
         write(std.textio.OUTPUT, "" & LF); -- newline
         
         -- TCL output
          WRITE(OUTPUT,string'("DIN: "));            
          WRITE(OUTPUT, vec2str(vt_din));  
          write(std.textio.OUTPUT, "" & LF); -- newline
          
          -- TCL output
          WRITE(OUTPUT,string'("ENC_Expected: "));            
          WRITE(OUTPUT, vec2str(vt_dec));  
          write(std.textio.OUTPUT, "" & LF); -- newline
          
        sig_enc <= vt_dec; 
         
       -- Get Decrypt or input value from text
       sig_dec <= vt_din;
       
       -- SWITCH: Input Mode
       tIP <= '0'; -- set to input
       tMode <= "00"; -- set to key expansion mode
       tRst <= '0';
          
          -- INPUT: Key Expansion
          -- 0
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(126 downto 119);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- 1
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(118 downto 111);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --2
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(110 downto 103);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --3
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(102 downto 95);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --4
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(94 downto 87);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --5
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(86 downto 79);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --6
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(79 downto 72);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --7
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(71 downto 64);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --8
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(63 downto 56);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --9
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(55 downto 48);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --10
          tBackdoorInput <= '0';
          tBackdoorInputVals <=  vt_key(47 downto 40);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --11
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(39 downto 32);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --12
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(31 downto 24);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --13
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(23 downto 16);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --14
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(15 downto 8);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --15
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(7 downto 0);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          tBackdoorInput <= '0';
   
   
          -- SWITCH MODE: to execution mode
          tBackdoorInputVals <= "00000000";
          tIP <= '1'; -- set to input
          -- Reset the CPU
          tRst <= '1';
          wait for clk_period;
          tRst <= '0';
          
          -- INPUT: ENCRYPTION
          wait for enc_mode_start;
          tIP <= '0';
          tMode <= "01";
          -- Data 1
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(63 downto 56);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 2
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(55 downto 48);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 3
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(47 downto 40);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
           -- Data 4
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(39 downto 32);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 5
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(31 downto 24);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 5
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(23 downto 16);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 6
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(15 downto 8);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          tBackdoorInput <= '0';
          -- Data 7
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(7 downto 0);
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
   
          
          -- wait for signal to become stable
          wait for 700 us;
          
          -- check if the halt has been thrown
          if(tHal='1') then
           -- write results to local console Encrypt
           write(OUTPUT, "---Test Complete---");
           write(std.textio.OUTPUT, "" & LF); -- newline     
           write(OUTPUT, "DOUT: ( Encrypter ) "); 
           write(OUTPUT, vec2str(tEncDoutA) & vec2str(tEncDoutB));
           write(std.textio.OUTPUT, "" & LF); -- newline  
           
           
           if(sig_enc = tEncDoutA&tEncDoutB) then
               write(output, "SUCCESS: Encrypt vector match");
           else
               write(output, "FAILURE: Encrypt vector mismatch");
           end if;
           
           write(std.textio.OUTPUT, "" & LF); -- newline
           assert(sig_enc = tEncDoutA&tEncDoutB)
           report " Encrypt Failed!"
           severity error;
          
          end if;
          
       -- enc 2
       
              
   
        vt_din := x"1000000000000000";
   
        vt_dec := x"26035D4E3E012C55";
         
          write(std.textio.OUTPUT, "" & LF); -- newline
         WRITE(OUTPUT,string'("-------------ENCRYPT 2------------"));
         write(std.textio.OUTPUT, "" & LF); -- newline
         -- TCL output
          WRITE(OUTPUT,string'("DIN: "));            
          WRITE(OUTPUT, vec2str(vt_din));  
          write(std.textio.OUTPUT, "" & LF); -- newline
          
          -- TCL output
          WRITE(OUTPUT,string'("ENC_Expected: "));            
          WRITE(OUTPUT, vec2str(vt_dec));  
          write(std.textio.OUTPUT, "" & LF); -- newline
          
        sig_enc <= vt_dec; 
         
       -- Get Decrypt or input value from text
       sig_dec <= vt_din;
       
       -- SWITCH: Input Mode
       tIP <= '0'; -- set to input
       tMode <= "00"; -- set to key expansion mode
       tRst <= '0';
          
          -- INPUT: Key Expansion
          -- 0
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(126 downto 119);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- 1
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(118 downto 111);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --2
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(110 downto 103);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --3
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(102 downto 95);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --4
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(94 downto 87);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --5
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(86 downto 79);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --6
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(79 downto 72);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --7
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(71 downto 64);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --8
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(63 downto 56);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --9
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(55 downto 48);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --10
          tBackdoorInput <= '0';
          tBackdoorInputVals <=  vt_key(47 downto 40);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --11
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(39 downto 32);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --12
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(31 downto 24);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --13
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(23 downto 16);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --14
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(15 downto 8);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          --15
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_key(7 downto 0);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          tBackdoorInput <= '0';
   
   
          -- SWITCH MODE: to execution mode
          tBackdoorInputVals <= "00000000";
          tIP <= '1'; -- set to input
          -- Reset the CPU
          tRst <= '1';
          wait for clk_period;
          tRst <= '0';
          
          -- INPUT: ENCRYPTION
          wait for enc_mode_start;
          tIP <= '0';
          tMode <= "01";
          -- Data 1
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(63 downto 56);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 2
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(55 downto 48);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 3
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(47 downto 40);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
           -- Data 4
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(39 downto 32);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 5
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(31 downto 24);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 5
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(23 downto 16);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          -- Data 6
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(15 downto 8);
          wait for clk_period;
          tBackdoorInput <= '1';
          wait for clk_period;
          tBackdoorInput <= '0';
          -- Data 7
          tBackdoorInput <= '0';
          tBackdoorInputVals <= vt_din(7 downto 0);
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
   
          
          -- wait for signal to become stable
          wait for 700 us;
          
          -- check if the halt has been thrown
          if(tHal='1') then
           -- write results to local console Encrypt
           write(OUTPUT, "---Test Complete---");
           write(std.textio.OUTPUT, "" & LF); -- newline     
           write(OUTPUT, "DOUT: ( Encrypter ) "); 
           write(OUTPUT, vec2str(tEncDoutA) & vec2str(tEncDoutB));
           write(std.textio.OUTPUT, "" & LF); -- newline  
           
           
           if(sig_enc = tEncDoutA&tEncDoutB) then
               write(output, "SUCCESS: Encrypt vector match");
           else
               write(output, "FAILURE: Encrypt vector mismatch");
           end if;
           
           write(std.textio.OUTPUT, "" & LF); -- newline
           assert(sig_enc = tEncDoutA&tEncDoutB)
           report " Encrypt Failed!"
           severity error;
           
           write(std.textio.OUTPUT, "" & LF); -- newline
           write(OUTPUT, "--------------------------------------------------------------------------------------------------------------------------------------------------------------------");   
           write(std.textio.OUTPUT, "" & LF); -- newline
          
          end if;
             
       -- Round 4 KEy gen Decrypt 1 + Decrypt 2
         
         -- TCL output
         counter <= counter + 1;
         write(std.textio.OUTPUT, "" & LF); -- newline
         WRITE(OUTPUT,string'("--RUN --  "));
         WRITE(OUTPUT, integer'image(counter)); 
         WRITE(OUTPUT,string'("  KEY GEN + DECRYPT1 + DECRYPT 2 --------"));
         write(std.textio.OUTPUT, "" & LF); -- newline
         
         -- Set input key value
          vt_key := x"00000000000000000000000000000000";
     
          vt_din := x"0000000000000000";   
          vt_dec := x"EEDBA5216D8F4B15";
      
          WRITE(OUTPUT,string'("-------------DECRYPT 1------------"));
          write(std.textio.OUTPUT, "" & LF); -- newline
          
           -- TCL output
           write(std.textio.OUTPUT, "" & LF); -- newline
           WRITE(OUTPUT,string'("Skey: "));            
           WRITE(OUTPUT, vec2str(vt_key));  
           write(std.textio.OUTPUT, "" & LF); -- newline
           
           -- TCL output
            WRITE(OUTPUT,string'("DEC_IN: "));            
            WRITE(OUTPUT, vec2str(vt_dec));  
            write(std.textio.OUTPUT, "" & LF); -- newline
            
            -- TCL output
           WRITE(OUTPUT,string'("Output_Expected: "));            
           WRITE(OUTPUT, vec2str(vt_din));  
           write(std.textio.OUTPUT, "" & LF); -- newline
            
          sig_enc <= vt_dec; 
           
          -- Get Decrypt or input value from text
          sig_dec <= vt_din;
         
         -- assign values
         tEncDoutA <= vt_dec(63 downto 32);
         tEncDoutB <= vt_dec(31 downto 0);
         
         -- SWITCH: Input Mode
         tIP <= '0'; -- set to input
         tMode <= "00"; -- set to key expansion mode
         tRst <= '0';
        
        -- INPUT: Key Expansion
        -- 0
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(126 downto 119);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        -- 1
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(118 downto 111);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --2
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(110 downto 103);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --3
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(102 downto 95);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --4
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(94 downto 87);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --5
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(86 downto 79);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --6
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(79 downto 72);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --7
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(71 downto 64);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --8
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(63 downto 56);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --9
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(55 downto 48);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --10
        tBackdoorInput <= '0';
        tBackdoorInputVals <=  vt_key(47 downto 40);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --11
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(39 downto 32);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --12
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(31 downto 24);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --13
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(23 downto 16);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --14
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(15 downto 8);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        --15
        tBackdoorInput <= '0';
        tBackdoorInputVals <= vt_key(7 downto 0);
        wait for clk_period;
        tBackdoorInput <= '1';
        wait for clk_period;
        tBackdoorInput <= '0';
  
  
        -- SWITCH MODE: to execution mode
        tBackdoorInputVals <= "00000000";
        tIP <= '1'; -- set to input
        -- Reset the CPU
        tRst <= '1';
        wait for clk_period;
        tRst <= '0';
        
        wait for enc_mode_start;
        
       tIP <= '0';
       tMode <= "10";
     
      -- INPUT: Decryption Mode
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
           
        -- wait for signal to become stable
        wait for 700 us;
        
        -- check if the halt has been thrown
        if(tHal='1') then
           -- write results to local console Decrypt
           write(std.textio.OUTPUT, "" & LF); -- newline
           write(OUTPUT, "---Test Complete---");
           write(std.textio.OUTPUT, "" & LF); -- newline     
           write(OUTPUT, "DOUT: ( Decrypt ) "); 
           write(OUTPUT, vec2str(tOutA) & vec2str(tOutB));
           write(std.textio.OUTPUT, "" & LF); -- newline
           
           if(sig_dec = tOutA&tOutB) then
               write(output, "SUCCESS: Decrypt vector match");
           else
               write(output, "FAILURE: Decrypt vector mismatch");
           end if;
           
           write(std.textio.OUTPUT, "" & LF); -- newline
           assert(sig_dec = tOutA&tOutB)
           report " Decrypt Failed!"
           severity error;
              
        end if;
        
        -- Decrypt 2
        
         -- TCL output
        
        -- Set input key value
         vt_key := x"00000000000000000000000000000000";
    
         vt_din := x"1000000000000000";   
         vt_dec := x"26035D4E3E012C55";
        
         write(std.textio.OUTPUT, "" & LF); -- newline
         WRITE(OUTPUT,string'("-------------DECRYPT 2------------"));
         write(std.textio.OUTPUT, "" & LF); -- newline
         
          -- TCL output
          write(std.textio.OUTPUT, "" & LF); -- newline
          WRITE(OUTPUT,string'("Skey: "));            
          WRITE(OUTPUT, vec2str(vt_key));  
          write(std.textio.OUTPUT, "" & LF); -- newline
          
          -- TCL output
           WRITE(OUTPUT,string'("DEC_IN: "));            
           WRITE(OUTPUT, vec2str(vt_dec));  
           write(std.textio.OUTPUT, "" & LF); -- newline
           
           -- TCL output
          WRITE(OUTPUT,string'("Output_Expected: "));            
          WRITE(OUTPUT, vec2str(vt_din));  
          write(std.textio.OUTPUT, "" & LF); -- newline
           
         sig_enc <= vt_dec; 
          
         -- Get Decrypt or input value from text
         sig_dec <= vt_din;
        
        -- assign values
        tEncDoutA <= vt_dec(63 downto 32);
        tEncDoutB <= vt_dec(31 downto 0);
        
         
        -- SWITCH MODE: to execution mode
        tBackdoorInputVals <= "00000000";
        tIP <= '1'; -- set to input
        -- Reset the CPU
        tRst <= '1';
        wait for clk_period;
        tRst <= '0';
        
        wait for enc_mode_start;
        
       tIP <= '0';
       tMode <= "10";
     
      -- INPUT: Decryption Mode
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
           
        -- wait for signal to become stable
        wait for 700 us;
        
        -- check if the halt has been thrown
        if(tHal='1') then
           -- write results to local console Decrypt
           write(std.textio.OUTPUT, "" & LF); -- newline
           write(OUTPUT, "---Test Complete---");
           write(std.textio.OUTPUT, "" & LF); -- newline     
           write(OUTPUT, "DOUT: ( Decrypt ) "); 
           write(OUTPUT, vec2str(tOutA) & vec2str(tOutB));
           write(std.textio.OUTPUT, "" & LF); -- newline
           
           if(sig_dec = tOutA&tOutB) then
               write(output, "SUCCESS: Decrypt vector match");
           else
               write(output, "FAILURE: Decrypt vector mismatch");
           end if;
           
           write(std.textio.OUTPUT, "" & LF); -- newline
           assert(sig_dec = tOutA&tOutB)
           report " Decrypt Failed!"
           severity error;
               
          write(std.textio.OUTPUT, "" & LF); -- newline
          write(OUTPUT, "--------------------------------------------------------------------------------------------------------------------------------------------------------------------");   
          write(std.textio.OUTPUT, "" & LF); -- newline
        
        end if;
   
        -- Key Gen + Reset
        
        -- TCL output
        counter <= counter + 1;
        write(std.textio.OUTPUT, "" & LF); -- newline
        WRITE(OUTPUT,string'("--RUN --  "));
        WRITE(OUTPUT, integer'image(counter)); 
        WRITE(OUTPUT,string'("   KEY GEN + RESET --------"));
        write(std.textio.OUTPUT, "" & LF); -- newline
        
        -- Set input key value
        vt_key := x"00000000000000000000000000000000";
         
         -- TCL output
          write(std.textio.OUTPUT, "" & LF); -- newline
          WRITE(OUTPUT,string'("Skey: "));            
          WRITE(OUTPUT, vec2str(vt_key));  
          write(std.textio.OUTPUT, "" & LF); -- newline

        -- SWITCH: Input Mode
        tIP <= '0'; -- set to input
        tMode <= "00"; -- set to key expansion mode
        tRst <= '0';
           
           -- INPUT: Key Expansion
           -- 0
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(126 downto 119);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           -- 1
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(118 downto 111);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --2
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(110 downto 103);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --3
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(102 downto 95);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --4
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(94 downto 87);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --5
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(86 downto 79);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --6
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(79 downto 72);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --7
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(71 downto 64);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --8
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(63 downto 56);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --9
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(55 downto 48);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --10
           tBackdoorInput <= '0';
           tBackdoorInputVals <=  vt_key(47 downto 40);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --11
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(39 downto 32);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --12
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(31 downto 24);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --13
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(23 downto 16);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --14
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(15 downto 8);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           --15
           tBackdoorInput <= '0';
           tBackdoorInputVals <= vt_key(7 downto 0);
           wait for clk_period;
           tBackdoorInput <= '1';
           wait for clk_period;
           tBackdoorInput <= '0';
    
    
           -- SWITCH MODE: to execution mode
           tBackdoorInputVals <= "00000000";
           tIP <= '1'; -- set to input
           -- Reset the CPU
           tRst <= '1';
           wait for clk_period;
           tRst <= '0';
           
           -- wait for key gen to complete
           wait for enc_mode_start/2;
           
          -- Reset the CPU
           tRst <= '1';
           wait for clk_period;
           tRst <= '0';
           
           -- wait for key gen to complete
           wait for enc_mode_start;
               
           if(tHal='1') then
              -- write results to local console Encrypt
              write(OUTPUT, "---Test Complete---");
              write(std.textio.OUTPUT, "" & LF); -- newline     
              write(OUTPUT, "SKEY GENERATED"); 
              write(std.textio.OUTPUT, "" & LF); -- newline  
          end if;
               
           -- Encryption + Reset
           
           -- TCL output
           counter <= counter + 1;
           write(std.textio.OUTPUT, "" & LF); -- newline
           WRITE(OUTPUT,string'("--RUN --  "));
           WRITE(OUTPUT, integer'image(counter)); 
           WRITE(OUTPUT,string'("   ENCRYPTION + RESET --------"));
           write(std.textio.OUTPUT, "" & LF); -- newline
            vt_key := x"00000000000000000000000000000000";
            vt_din := "0000000000000000000000000000000000000000000000000000000000000000";
        
            vt_dec := "1110111011011011101001010010000101101101100011110100101100010101";
             
             
             -- TCL output
              write(std.textio.OUTPUT, "" & LF); -- newline
              WRITE(OUTPUT,string'("Skey: "));            
              WRITE(OUTPUT, vec2str(vt_key));  
              write(std.textio.OUTPUT, "" & LF); -- newline
             
            -- TCL output
            WRITE(OUTPUT,string'("DIN: "));            
            WRITE(OUTPUT, vec2str(vt_din));  
            write(std.textio.OUTPUT, "" & LF); -- newline
            
            -- TCL output
            WRITE(OUTPUT,string'("ENC_Expected: "));            
            WRITE(OUTPUT, vec2str(vt_dec));  
            write(std.textio.OUTPUT, "" & LF); -- newline
              
            sig_enc <= vt_dec; 
             
           -- Get Decrypt or input value from text
           sig_dec <= vt_din;
             
           -- SWITCH: Input Mode
           tIP <= '0'; -- set to input
           tMode <= "00"; -- set to key expansion mode
           tRst <= '0';
              
              -- INPUT: Key Expansion
              -- 0
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(126 downto 119);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              -- 1
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(118 downto 111);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --2
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(110 downto 103);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --3
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(102 downto 95);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --4
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(94 downto 87);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --5
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(86 downto 79);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --6
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(79 downto 72);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --7
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(71 downto 64);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --8
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(63 downto 56);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --9
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(55 downto 48);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --10
              tBackdoorInput <= '0';
              tBackdoorInputVals <=  vt_key(47 downto 40);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --11
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(39 downto 32);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --12
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(31 downto 24);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --13
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(23 downto 16);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --14
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(15 downto 8);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              --15
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_key(7 downto 0);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              tBackdoorInput <= '0';
       
       
              -- SWITCH MODE: to execution mode
              tBackdoorInputVals <= "00000000";
              tIP <= '1'; -- set to input
              -- Reset the CPU
              tRst <= '1';
              wait for clk_period;
              tRst <= '0';
                                   
              -- wait for key gen to complete
              wait for enc_mode_start;
                          
                        
              -- INPUT: ENCRYPTION
              tIP <= '0';
              tMode <= "01";
              -- Data 1
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(63 downto 56);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              -- Data 2
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(55 downto 48);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              -- Data 3
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(47 downto 40);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
               -- Data 4
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(39 downto 32);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              -- Data 5
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(31 downto 24);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              -- Data 5
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(23 downto 16);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              -- Data 6
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(15 downto 8);
              wait for clk_period;
              tBackdoorInput <= '1';
              wait for clk_period;
              tBackdoorInput <= '0';
              -- Data 7
              tBackdoorInput <= '0';
              tBackdoorInputVals <= vt_din(7 downto 0);
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
             
             wait for clk_period*100;
             
             -- toggle the RST
             tRst <= '0';
             wait for rst_mode_bounce;
             tRst <= '1';
             wait for clk_period;
             tRst <= '0';
             
             -- Wait for encrypt to end
             wait for enc_mode_start;
             -- assign values
             tEncDoutA <= tOutA;
             tEncDoutB <= tOutB;
       
              
              -- wait for signal to become stable
              wait for 700 us;
              
              -- check if the halt has been thrown
              if(tHal='1') then
               -- write results to local console Encrypt
               write(OUTPUT, "---Test Complete---");
               write(std.textio.OUTPUT, "" & LF); -- newline     
               write(OUTPUT, "DOUT: ( Encrypter ) "); 
               write(OUTPUT, vec2str(tEncDoutA) & vec2str(tEncDoutB));
               write(std.textio.OUTPUT, "" & LF); -- newline  
               
               
               if(sig_enc = tEncDoutA&tEncDoutB) then
                   write(output, "SUCCESS: Encrypt vector match");
               else
                   write(output, "FAILURE: Encrypt vector mismatch");
               end if;
               
               write(std.textio.OUTPUT, "" & LF); -- newline
               assert(sig_enc = tEncDoutA&tEncDoutB)
               report " Encrypt Failed!"
               severity error;
               
               write(std.textio.OUTPUT, "" & LF); -- newline
               write(OUTPUT, "--------------------------------------------------------------------------------------------------------------------------------------------------------------------");   
               write(std.textio.OUTPUT, "" & LF); -- newline
              
              end if;
              -- Round 7 Decrypt _ Reset
                     
                 -- TCL output
                 counter <= counter + 1;
                 write(std.textio.OUTPUT, "" & LF); -- newline
                 WRITE(OUTPUT,string'("--RUN --  "));
                 WRITE(OUTPUT, integer'image(counter)); 
                 WRITE(OUTPUT,string'("  DECRYPT + RESET --------"));
                 write(std.textio.OUTPUT, "" & LF); -- newline
                 
                 -- Set input key value
             
                  vt_din := "0001000100010001000100000000000000000000000000000000000000000000";   
                  vt_dec := "0101111101000010010110100011011111110001001010001111101001111110";
                  
                   
                   -- TCL output
                    WRITE(OUTPUT,string'("DEC_IN: "));            
                    WRITE(OUTPUT, vec2str(vt_dec));  
                    write(std.textio.OUTPUT, "" & LF); -- newline
                    
                    -- TCL output
                   WRITE(OUTPUT,string'("Output_Expected: "));            
                   WRITE(OUTPUT, vec2str(vt_din));  
                   write(std.textio.OUTPUT, "" & LF); -- newline
                    
                  sig_enc <= vt_dec; 
                   
                  -- Get Decrypt or input value from text
                  sig_dec <= vt_din;
                 
                 -- assign values
                 tEncDoutA <= vt_dec(63 downto 32);
                 tEncDoutB <= vt_dec(31 downto 0);

               tIP <= '0';
               tMode <= "10";
             
              -- INPUT: Decryption Mode
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
                
                wait for 100 ns;
               -- Toggle Reset 
               tRst <= '0';
               wait for clk_period/2;
               tRst <= '1';
               wait for clk_period/2;
               tRst <= '0';
                -- wait for signal to become stable
                wait for 700 us;
                
                -- check if the halt has been thrown
                if(tHal='1') then
                   -- write results to local console Decrypt
                   write(std.textio.OUTPUT, "" & LF); -- newline
                   write(OUTPUT, "---Test Complete---");
                   write(std.textio.OUTPUT, "" & LF); -- newline     
                   write(OUTPUT, "DOUT: ( Decrypt ) "); 
                   write(OUTPUT, vec2str(tOutA) & vec2str(tOutB));
                   write(std.textio.OUTPUT, "" & LF); -- newline
                   
                   if(sig_dec = tOutA&tOutB) then
                       write(output, "SUCCESS: Decrypt vector match");
                   else
                       write(output, "FAILURE: Decrypt vector mismatch");
                   end if;
                   
                   write(std.textio.OUTPUT, "" & LF); -- newline
                   assert(sig_dec = tOutA&tOutB)
                   report " Decrypt Failed!"
                   severity error;
                       
                  write(std.textio.OUTPUT, "" & LF); -- newline
                  write(OUTPUT, "--------------------------------------------------------------------------------------------------------------------------------------------------------------------");   
                  write(std.textio.OUTPUT, "" & LF); -- newline
                
                end if;
                  
       wait;
    end process;

   
end Behavioral;
