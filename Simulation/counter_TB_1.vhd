----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2024 10:43:53 AM
-- Design Name: 
-- Module Name: counter_TB_1 - Behavioral
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

entity counter_TB_1 is
--  Port ( );
end counter_TB_1;

architecture Behavioral of counter_TB_1 is

-- declare our component
    component Counter
    generic( count_num : integer := 11;
             count_length: integer := 4);
             
    port( clk   : in STD_LOGIC;
           reset : in std_logic := '0';
           Q_out : out STD_LOGIC_vector( count_length -1 downto 0);
           Rco   : out std_logic:='0');           
    end component;
 
signal clk   : STD_LOGIC;
signal reset : std_logic := '0';
signal Q_out : STD_LOGIC_vector( 4 -1 downto 0);
signal Rco   : std_logic:='0'; 

constant clock_period : time := 10 ns;
signal stop_the_clock   : boolean:= false;
   
begin
    uut: Counter generic map(
                       count_num    => 11 ,
                       count_length =>  4)
                 port map(
                       clk          => clk,
                       reset        => reset,
                       Q_out        => Q_out,
                       Rco          => Rco );
stimulus: process  
    begin                       
    reset <= '1';
    wait for 20ns;
    reset <= '0';
    
    
    
    wait for 2000ms;
    stop_the_clock <=true;
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
