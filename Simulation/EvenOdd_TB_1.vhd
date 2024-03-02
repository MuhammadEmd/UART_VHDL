----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2024 04:37:50 PM
-- Design Name: 
-- Module Name: EvenOdd_TB_1 - Behavioral
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

entity EvenOdd_TB_1 is
--  Port ( );
end EvenOdd_TB_1;

architecture Behavioral of EvenOdd_TB_1 is

component EvenOdd is
    generic(data_length : integer := 8);
    Port   (data_in     : in STD_LOGIC_VECTOR (data_length - 1 downto 0);
            clk         : in std_logic;
            new_data    : in std_logic;
            ready_out  : out std_logic := '0';
            is_odd     : out STD_LOGIC);
end component;

signal clk   : STD_LOGIC;
signal new_data : std_logic := '0';
signal is_odd   : STD_LOGIC;
signal ready_out   : STD_LOGIC;
signal data_in   : STD_LOGIC_vector(8 -1 downto 0);

constant clock_period : time := 10 ns;
signal stop_the_clock   : boolean:= false;


begin
uut : EvenOdd generic map(data_length => 8)
              Port map   (data_in     => data_in,
                          clk         => clk,
                          new_data    => new_data,
                          ready_out   => ready_out,
                          is_odd      => is_odd);


stimulus : process
begin
    new_data <= '0';
    wait for 100ns;
    data_in <= "10100100";
    new_data <= '1';
    wait for 10ns;
    new_data <= '0';
    
    wait for 200ns;
    data_in <= "10100000";
    new_data <= '1';
    wait for 10ns;
    new_data <= '0';
    
    wait for 200ns;
    data_in <= "10110100";
    new_data <= '1';
    wait for 10ns;
    new_data <= '0';
    
    wait for 200ns;
    data_in <= "10110101";
    new_data <= '1';
    wait for 10ns;
    new_data <= '0';
    
    wait for 200ns;
    data_in <= "11111111";
    new_data <= '1';
    wait for 10ns;
    new_data <= '0';
    
    wait for 200ns;
    data_in <= "00000000";
    new_data <= '1';
    wait for 10ns;
    new_data <= '0';
    
    wait for 2000ms;
    stop_the_clock <=true;
end process;


clocking : process
begin
    while not stop_the_clock loop
        clk <= '0', '1' after clock_period/2 ;
        wait for clock_period;
    end loop;
    wait;
end process;

end Behavioral;
