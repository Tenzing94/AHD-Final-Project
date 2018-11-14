----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2018 05:12:03 PM
-- Design Name: 
-- Module Name: top_module - Behavioral
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
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity top_module is
    Port ( 
           -- hardware-level declarations
           clk100 : in std_logic;
           LED      : out std_logic_vector(12 downto 0);
           C 		: out  STD_LOGIC_VECTOR (7 downto 0);
           A 		: out  STD_LOGIC_VECTOR (7 downto 0);
           SW       : in std_logic_vector(2 downto 0);
           -- non-hardware declarations
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0));
end top_module;

architecture Behavioral of top_module is

--- HEX TO LED ---
component Hex2LED --Converts a 4 bit hex value into the pattern to be displayed on the 7seg
port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component; 
-- SIGNALS
type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;
signal Val : std_logic_vector(3 downto 0) := (others => '0');
signal HexVal: std_logic_vector(31 downto 0);
signal slowCLK: std_logic:='0';
signal i_cnt: std_logic_vector(19 downto 0):=x"00000";

-- Component PC
component pc
    Port ( in_pc : in STD_LOGIC_VECTOR (31 downto 0);
       clr : in STD_LOGIC;
       clk : in STD_LOGIC;
       out_pc : out STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Component Imem
component imem
    Port ( 
       in_pc : in std_logic_vector (31 downto 0);
       out_imem : out std_logic_vector (31 downto 0));
end component;

-- Component RF
component rf
    Port (
        CLK, WE3   : in std_logic;
        A1, A2, A3 : in std_logic_vector(4 downto 0);
        WD3        : in std_logic_vector(31 downto 0);   
        RD1, RD2   : out std_logic_vector(31 downto 0));
end component;

-- Component Control Unit
component control_unit
    Port ( opCode : in STD_LOGIC_VECTOR (5 downto 0);
       funct : in STD_LOGIC_VECTOR (5 downto 0);
       controlReg : out STD_LOGIC_VECTOR (8 downto 0));
end component;

-- Component Sign Extend
component signextend
    Port (
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0));
end component;

-- component ALU
component ALU_FPGA
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
       SrcB : in STD_LOGIC_VECTOR (31 downto 0);
       ALU_Control : in STD_LOGIC_VECTOR (2 downto 0);
       ALU_Result : out STD_LOGIC_VECTOR (31 downto 0);
       Flag_Zero : out STD_LOGIC;
       Flag_Negative : out STD_Logic);
end component;

 -- component DMEM
 component dmem
     Port ( 
         CLK, WE : in std_logic;
         A, WD   : in std_logic_vector(31 downto 0);
         RD      : out std_logic_vector(31 downto 0));
 end component;
 
 --  Component MUX32
 component mux32bit2to1
     Port (
         SEL       : in std_logic;
         A, B      : in std_logic_vector(31 downto 0);
         X         : out std_logic_vector(31 downto 0));
 end component;

 --  Component MUX5
component mux5bit2to1
 Port (
     SEL       : in std_logic;
     A, B      : in std_logic_vector(4 downto 0);
     X         : out std_logic_vector(4 downto 0));
end component;


-- Compunent SignExtt
component signextent
    Port (
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0));
end component;

-- Left shift Component
component Shift_Left_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Shift_Amt : in STD_LOGIC_VECTOR (4 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

-- Component Add 
component Add_Func
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

-- Signals

signal in_pc : std_logic_vector (31 downto 0) := X"00000000";
signal demux_pc: std_logic_vector (31 downto 0);
signal progCounter : std_logic_vector (31 downto 0);
signal pcPlus4 : std_logic_vector (31 downto 0);
signal pcBranch : std_logic_vector (31 downto 0);
signal pcJump : std_logic_vector (31 downto 0);

signal currentInst : std_logic_vector (31 downto 0);

signal sourceA : std_logic_vector (31 downto 0);
signal register2 : std_logic_vector (31 downto 0);
signal sourceB : std_logic_vector (31 downto 0);
signal currentInst_A3 : std_logic_vector (4 downto 0);

signal signImm : std_logic_vector (31 downto 0);
signal signImmLeftShift : std_logic_vector (31 downto 0);

signal ALUResult : std_logic_vector (31 downto 0);
signal zero: std_logic;
signal negative: std_logic;
signal orOp: std_logic;

signal memReadData : std_logic_vector (31 downto 0);

signal result : std_logic_vector (31 downto 0);


-- Control signals
signal cPCsrc: std_logic;
signal cMemToReg: std_logic;
signal cMemWrite: std_logic;
signal cBranch: std_logic;
signal cALUOpcode: std_logic_vector(2 downto 0);
signal cALUSrc: std_logic;
signal cRegDst: std_logic;
signal cRegWrite: std_logic;
signal tempCoontrolReg : std_logic_vector ( 8 downto 0 );

constant two : std_logic_vector( 4 downto 0 ) := "00010";
constant four : std_logic_vector( 31 downto 0 ) := X"00000004";
constant one : std_logic_vector( 31 downto 0 ) := X"00000001";

begin

-----Creating a slowCLK of 500Hz using the board's 100MHz clock----
process(CLK100)
    begin
    if (rising_edge(CLK100)) then
        if (i_cnt=x"186A0")then --Hex(186A0)=Dec(100,000)
            slowCLK<=not slowCLK; --slowCLK toggles once after we see 100000 rising edges of CLK. 2 toggles is one period.
            i_cnt<=x"00000";
        else
            i_cnt<=i_cnt+'1';
        end if;
    end if;
end process;

-----We use the 500Hz slowCLK to run our 7seg display at roughly 60Hz-----
timer_inc_process : process (slowCLK)
begin
    if (rising_edge(slowCLK)) then
                if(Val="1000") then
                Val<="0001";
                else
                Val <= Val + '1'; --Val runs from 1,2,3,...8 on every rising edge of slowCLK
            end if;
        end if;
    --end if;
end process;

-- Define control Reg
cMemToReg <= tempCoontrolReg(8);
cMemWrite <= tempCoontrolReg(7);
cBranch <= tempCoontrolReg(6);
cALUOpcode <= tempCoontrolReg(5 downto 3);
cALUSrc <= tempCoontrolReg(2);
cRegDst <= tempCoontrolReg(1);
cRegWrite <= tempCoontrolReg(0);

-- Main Components
pc1: pc PORT MAP(in_pc => demux_pc, clr => rst, clk => clk, out_pc => progCounter );
imem0: imem PORT MAP( in_pc => progCounter, out_imem => currentInst);
rf0: rf PORT Map ( clk => clk, WE3 => cRegWrite, A1 => currentInst( 25 downto 21), A2 => currentInst( 20 downto 16 ), A3 => currentInst_A3 , WD3 => result , RD1 => sourceA, RD2 => register2 );
alu0: ALU_FPGA PORT MAP( SrcA => sourceA, SrcB => sourceB, ALU_Control => cALUOpcode, ALU_Result => ALUResult, Flag_Zero => zero, Flag_Negative => negative );
cu0: control_unit PORT MAP( opcode => currentInst( 31 downto 26), funct => currentInst( 5 downto 0), controlReg => tempCoontrolReg );
dmem0: dmem PORT MAP ( clk => clk, WE => cMemWrite, A => ALUResult, WD => register2, RD => memReadData );


-- MUX and other components
mux0: mux32bit2to1 PORT MAP( SEL => cPCsrc, A => pcPlus4, B => pcBranch, X => in_pc );
mux1: mux5bit2to1 PORT MAP( SEL => cRegDst, A => currentInst( 20 downto 16 ), B => currentInst( 15 downto 11 ), X => currentInst_A3 );
mux2: mux32bit2to1 PORT MAP( SEL => cALUSrc, A => register2, B => signImm, X => sourceB );
mux3: mux32bit2to1 PORT MAP( SEL => cMemToReg, A => ALUResult, B => memReadData, X => result);
se0: signextend PORT MAP ( input => currentInst( 15 downto 0), output => signImm );
ls0: Shift_Left_Func PORT MAP ( A_Source => signImm, Shift_Amt => two , Output_Val => signImmLeftShift);
adder1: Add_Func PORT MAP ( A_Source => progCounter, B_Source => four , Output_Val => pcPlus4 );
adder2: Add_Func PORT MAP ( A_Source => signImmLeftShift , B_Source => pcPlus4 , Output_Val => pcBranch );

-- Branch signal
orOp <= zero OR negative;
cPCsrc <= cBranch AND orOp;

pcJump <=  in_pc(31 downto 28) & currentInst(25 downto 0) & "00";

-- PC depends  jump, halt or normal
with currentInst( 31 downto 26 ) select
    demux_pc <= pcJump when b"001100",      --Jump
                demux_pc when b"111111",                               --Halt
                in_pc when others;                                 -- Normal inst


-- // LEDs // --
LED(0) <= negative;
LED(1) <= zero;
LED(2) <= cPCsrc;
LED(3) <= cMemToReg;
LED(4) <= cBranch;
LED(5) <= cALUSrc;
LED(6) <= cRegDst;
LED(7) <= cRegWrite;
LED(10 downto 8) <= cALUOpcode;

-- // 7-SEG // --
--This select statement selects one of the 7-segment diplay anode(active low) at a time. 
with Val select
	A <= "01111111" when "0001",
				  "10111111" when "0010",
				  "11011111" when "0011",
				  "11101111" when "0100",
				  "11110111" when "0101",
				  "11111011" when "0110",
				  "11111101" when "0111",
				  "11111110" when "1000",
				  "11111111" when others;

--This select statement selects the value of HexVal to the necessary
--cathode signals to display it on the 7-segment
with Val select
	C <= NAME(0) when "0001", --NAME contains the pattern for each hex value to be displayed.
				  NAME(1) when "0010", --See below for the conversion
				  NAME(2) when "0011",
				  NAME(3) when "0100",
				  NAME(4) when "0101",
				  NAME(5) when "0110",
				  NAME(6) when "0111",
				  NAME(7) when "1000",
				  NAME(0) when others;

-- assign to TL signal
HexVal <= result;

--Hex2LED for converting each Hex value to a pattern to be given to the cathode.
CONV1: Hex2LED port map (CLK => CLK100, X => HexVal(31 downto 28), Y => NAME(0));
CONV2: Hex2LED port map (CLK => CLK100, X => HexVal(27 downto 24), Y => NAME(1));
CONV3: Hex2LED port map (CLK => CLK100, X => HexVal(23 downto 20), Y => NAME(2));
CONV4: Hex2LED port map (CLK => CLK100, X => HexVal(19 downto 16), Y => NAME(3));		
CONV5: Hex2LED port map (CLK => CLK100, X => HexVal(15 downto 12), Y => NAME(4));
CONV6: Hex2LED port map (CLK => CLK100, X => HexVal(11 downto 8), Y => NAME(5));
CONV7: Hex2LED port map (CLK => CLK100, X => HexVal(7 downto 4), Y => NAME(6));
CONV8: Hex2LED port map (CLK => CLK100, X => HexVal(3 downto 0), Y => NAME(7));


-- // SWITCHES // --

-- // BUTTONS // --


-- Output Assignment from TL

output <= result;


end Behavioral;