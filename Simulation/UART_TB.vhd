----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2024 08:12:07 AM
-- Design Name: 
-- Module Name: UART_TB - Behavioral
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

entity UART_TB is
--  Port ( );
end UART_TB;

architecture Behavioral of UART_TB is

component UART_module 
    generic(data_in_num       : integer := 8;
            stop_bit_num      : integer := 1;
            start_bit_num     : integer := 1;
            parity_enable     : integer := 1;
            baudRate          : integer := 19200;
            clockFreq         : integer := 100000000);
    Port (  TX                : out STD_LOGIC;
            RX                : in STD_LOGIC;
            InputData         : in STD_LOGIC_VECTOR (7 downto 0);
            InputValid        : in STD_LOGIC;
            OutputValid       : out STD_LOGIC;
            OutputData        : out STD_LOGIC_VECTOR (7 downto 0);
            clk               : in STD_LOGIC;
            Rst               : in STD_LOGIC;
            Error             : out STD_LOGIC);
end component;

signal      TX                : STD_LOGIC;
signal      RX                : STD_LOGIC;
signal      InputData         : STD_LOGIC_VECTOR (7 downto 0);
signal      InputValid        : STD_LOGIC;
signal      OutputValid       : STD_LOGIC;
signal      OutputData        : STD_LOGIC_VECTOR (7 downto 0);
signal      clk               : STD_LOGIC;
signal      Rst               : STD_LOGIC;
signal      Error             : STD_LOGIC;



constant clock_period         : time    := 10 ns;
constant counter              : integer := 0;
constant clock_br_period      : time    := 52us;
signal   stop_the_clock       : boolean := false;


begin

uut: UART_module generic map
           (data_in_num       => 8,
            stop_bit_num      => 1,
            start_bit_num     => 1,
            parity_enable     => 1,
            baudRate          => 19200,
            clockFreq         => 100000000)
                 Port map
           (TX                => TX,
            RX                => RX,
            InputData         => InputData,
            InputValid        => InputValid,
            OutputValid       => OutputValid,
            OutputData        => OutputData,
            clk               => clk,
            Rst               => Rst,
            Error             => Error);


stimulus: process
    begin
    wait for 2ns;
    
    rst <= '1';
    RX <= '1';
    wait for 8ns;
    rst <= '0';
    wait for 8ns;
    InputValid <= '1';
    InputData <= "01010111";
    
    wait for clock_period ;
    wait for 3ns;
    InputValid <= '0';  
    
    wait for 25ns;
    
    wait for 350us;
    
    InputValid <= '1';
    InputData <= "01010101";
    
    wait for clock_period ;
    wait for 3ns;
    InputValid <= '0';  
    
    
    
    
    RX <= '1';
    
    wait for 20ns;
    rst <= '0';
    
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    RX <= '0';
    
    wait for clock_br_period; --bit 0
    RX <= '0';
    
    wait for clock_br_period; --bit 1
    RX <= '0';
    
    wait for clock_br_period; --bit 2
    RX <= '1';
    
    wait for clock_br_period; --bit 3
    RX <= '1';
    
    wait for clock_br_period; --bit 4
    RX <= '0';
    
    wait for clock_br_period; --bit 5
    RX <= '1';
    
    wait for clock_br_period; --bit 6
    RX <= '0';
    
    wait for clock_br_period; --bit 7
    RX <= '1';
    
    wait for clock_br_period; --parity bit
    RX <= '0';
    
    wait for clock_br_period; --stop bit
    RX <= '1';
    
    --- start sec data recieve
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    RX <= '0';
    
    wait for clock_br_period; --bit 0
    RX <= '1';
    
    wait for clock_br_period; --bit 1
    RX <= '1';
    
    wait for clock_br_period; --bit 2
    RX <= '1';
    
    wait for clock_br_period; --bit 3
    RX <= '1';
    
    wait for clock_br_period; --bit 4
    RX <= '0';
    
    wait for clock_br_period; --bit 5
    RX <= '1';
    
    wait for clock_br_period; --bit 6
    RX <= '0';
    
    wait for clock_br_period; --bit 7
    RX <= '1';
    
    wait for clock_br_period; --parity bit
    RX <= '1';
    
    wait for clock_br_period; --stop bit
    RX <= '0';
    
    
    wait for clock_br_period; --stop bit
    RX <= '1';
    
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    RX <= '0';
    
    wait for clock_br_period; --bit 0
    RX <= '1';
    
    wait for clock_br_period; --bit 1
    RX <= '1';
    
    wait for clock_br_period; --bit 2
    RX <= '1';
    
    wait for clock_br_period; --bit 3
    RX <= '1';
    
    wait for clock_br_period; --bit 4
    RX <= '0';
    
    wait for clock_br_period; --bit 5
    RX <= '1';
    
    wait for clock_br_period; --bit 6
    RX <= '0';
    
    wait for clock_br_period; --bit 7
    RX <= '1';
    
    wait for clock_br_period; --parity bit
    RX <= '1';
    
    wait for clock_br_period; --stop bit
    RX <= '0';
    
    
    wait for clock_br_period; --stop bit
    RX <= '1';
    
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    RX <= '0';
    
    wait for clock_br_period; --bit 0
    RX <= '0';
    
    wait for clock_br_period; --bit 1
    RX <= '0';
    
    wait for clock_br_period; --bit 2
    RX <= '1';
    
    wait for clock_br_period; --bit 3
    RX <= '1';
    
    wait for clock_br_period; --bit 4
    RX <= '0';
    
    wait for clock_br_period; --bit 5
    RX <= '1';
    
    wait for clock_br_period; --bit 6
    RX <= '0';
    
    wait for clock_br_period; --bit 7
    RX <= '1';
    
    wait for clock_br_period; --parity bit
    RX <= '0';
    
    wait for clock_br_period; --stop bit
    RX <= '1';
    
    wait for 2000ms;
    stop_the_clock <= true;
    end process;

clocking: process
    begin
        while not stop_the_clock loop
            clk <= '0', '1' after clock_period/2 ;
            wait for clock_period;
        end loop;
        wait;
    end process;  

end Behavioral;
