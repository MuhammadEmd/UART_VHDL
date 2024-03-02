----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2024 01:03:45 PM
-- Design Name: 
-- Module Name: trasmiter_TB_1 - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trasmiter_TB_1 is
--  Port ( );
end trasmiter_TB_1;

architecture Behavioral of trasmiter_TB_1 is

    -- declare our component
    component transmitter
    generic(
        data_in_num     : integer := 8;
        stop_bit_num    : integer := 1;
        parity_enable   : integer := 1);
        
    port(
       data_in_p        : in STD_LOGIC_VECTOR (data_in_num - 1 downto 0);
       --clk_br           : in std_logic;
       clk              : in std_logic;
       input_data_valid : in std_logic;
       reset            : in std_logic;
       data_out_s       : out STD_LOGIC);
    end component;

signal data_in_p        : STD_LOGIC_VECTOR (8 - 1 downto 0);
--signal clk_br           : std_logic;
signal clk              : std_logic;
signal input_data_valid : std_logic;
signal reset           : std_logic;
signal data_out_s       : STD_LOGIC;
 
constant clock_period   : time := 10 ns;
constant counter        : integer:= 0;
constant clock_br_period: time := 129us;
signal stop_the_clock   : boolean:= false;

   
begin

-- instantiate from component
uut: transmitter generic map(
                    data_in_num         => 8,
                    stop_bit_num        => 1,
                    parity_enable       => 1)
                    
                 port map(
                    data_in_p           => data_in_p,
                    --clk_br              => clk_br,
                    clk                 => clk,
                    input_data_valid    => input_data_valid,
                    reset               => reset,
                    data_out_s          => data_out_s);
                    
stimulus: process
    begin
    reset <= '1';
    wait for 20ns;
    reset <= '0';
    input_data_valid <= '0';
    wait for 8ns;
    
    input_data_valid <= '1';
    data_in_p <= "01010111";
    
    wait for clock_period ;
    wait for 3ns;
    input_data_valid <= '0';  
    
    wait for 25ns;
    
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
                
--baud_rate: process
--    begin
--        while not stop_the_clock loop
--            clk_br <= '0', '1' after clock_br_period/2 ;
--            wait for clock_br_period;
--        end loop;
--        wait;
--    end process; 

               
end Behavioral;
