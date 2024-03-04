----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2024 02:04:57 PM
-- Design Name: 
-- Module Name: receiver - Behavioral
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

entity receiver_TB is
--  Port ( );
end receiver_TB;

architecture Behavioral of receiver_TB is

component receiver
    generic(data_in_num       : integer := 8;
            stop_bit_num      : integer := 1;
            start_bit_num     : integer := 1;
            parity_enable     : integer := 1);
    port(   Data_in_s         : in STD_LOGIC;
            clk               : in STD_LOGIC;
            clk_br            : in std_logic;
            reset             : in STD_LOGIC;
            Data_out_p        : out STD_LOGIC_VECTOR (7 downto 0);
            data_out_valid    : out STD_LOGIC;
            error             : out STD_LOGIC);
    end component;

constant clock_period         : time    := 10 ns;
constant counter              : integer := 0;
constant clock_br_period      : time    := 129us;
signal   stop_the_clock       : boolean := false;



signal clk              : std_logic  := '0';
signal clk_br           : std_logic  := '0';
signal reset            : std_logic  := '0';
signal error            : std_logic  := '0';
signal data_out_valid   : std_logic  := '0';
signal Data_in_s        : std_logic;
signal Data_out_p       : std_logic_vector(8 -1 downto 0);


begin


uut: receiver
     generic map(data_in_num    => 8,
                 stop_bit_num   => 1,
                 start_bit_num  => 1,
                 parity_enable  => 1)
     port map(   Data_in_s      => Data_in_s,
                 clk            => clk,
                 clk_br         => clk_br,
                 reset          => reset,
                 Data_out_p     => Data_out_p,
                 data_out_valid => data_out_valid,
                 error          => error);


stimulus: process
    begin
    
    Data_in_s <= '1';
    reset <= '1';
    wait for 20ns;
    reset <= '0';
    
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 0
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 1
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 2
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 3
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 4
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 5
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 6
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 7
    Data_in_s <= '1';
    
    wait for clock_br_period; --parity bit
    Data_in_s <= '0';
    
    wait for clock_br_period; --stop bit
    Data_in_s <= '1';
    
    --- start sec data recieve
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 0
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 1
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 2
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 3
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 4
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 5
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 6
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 7
    Data_in_s <= '1';
    
    wait for clock_br_period; --parity bit
    Data_in_s <= '1';
    
    wait for clock_br_period; --stop bit
    Data_in_s <= '0';
    
    
    wait for clock_br_period; --stop bit
    Data_in_s <= '1';
    
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 0
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 1
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 2
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 3
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 4
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 5
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 6
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 7
    Data_in_s <= '1';
    
    wait for clock_br_period; --parity bit
    Data_in_s <= '1';
    
    wait for clock_br_period; --stop bit
    Data_in_s <= '0';
    
    
    wait for clock_br_period; --stop bit
    Data_in_s <= '1';
    
    wait for clock_br_period;
    wait for clock_br_period;
    
    wait for clock_br_period; --start bit
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 0
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 1
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 2
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 3
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 4
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 5
    Data_in_s <= '1';
    
    wait for clock_br_period; --bit 6
    Data_in_s <= '0';
    
    wait for clock_br_period; --bit 7
    Data_in_s <= '1';
    
    wait for clock_br_period; --parity bit
    Data_in_s <= '0';
    
    wait for clock_br_period; --stop bit
    Data_in_s <= '1';
    
    
--    input_data_valid <= '1';
--    data_in_p <= "01010111";
    
--    wait for clock_period ;
--    wait for 3ns;
--    input_data_valid <= '0';  
    
--    wait for 25ns;
    
--    wait for 350us;
    
--    input_data_valid <= '1';
--    data_in_p <= "01010101";
    
--    wait for clock_period ;
--    wait for 3ns;
--    input_data_valid <= '0';  
    
--    wait for 25ns;
    
--    input_data_valid <= '1';
--    data_in_p <= "01000111";
    
--    wait for clock_period ;
--    wait for 3ns;
--    input_data_valid <= '0';   

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
                
baud_rate: process
    begin
        while not stop_the_clock loop
            clk_br <= '0', '1' after clock_br_period/2 ;
            wait for clock_br_period;
        end loop;
        wait;
    end process; 



end Behavioral;
