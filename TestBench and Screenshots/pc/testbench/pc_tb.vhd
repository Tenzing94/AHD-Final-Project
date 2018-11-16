library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pc_tb is
--  Port ( );
end pc_tb;

architecture Behavioral of pc_tb is

component pc
    Port ( in_pc : in STD_LOGIC_VECTOR (31 downto 0);
           clr : in std_logic;
           clk : in std_logic;
           out_pc : out STD_LOGIC_VECTOR(31 downto 0));
end component;

signal t_pcin : STD_LOGIC_VECTOR(31 downto 0);
signal t_pcout : STD_LOGIC_VECTOR(31 downto 0);
signal tclr : STD_LOGIC;
signal tclk : STD_LOGIC;

signal period : time := 10 ns;

begin

uut: pc PORT MAP( in_pc => t_pcin,
                  clr => tclr,
                  out_pc => t_pcout,
                  clk => tclk  );

process
begin

    -- 1
    tclr <= '1';
    t_pcin <= "00000000000000000000000000000001";
    wait for period;

    -- 2
    t_pcin <= "00000000000000000000000000000010";
    tclr <= '1';
    wait for period;    
    
    -- 3
    t_pcin <= "00000000000000000000000000000011";
    tclr <= '1';
    wait for period;
    
    tclr <= '0';
    wait for period;

      
end process;

end Behavioral;
