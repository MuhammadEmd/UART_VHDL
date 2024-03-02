----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2024 09:55:13 AM
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the fol lowing library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.




entity Counter is
    generic( count_num : integer := 11;
             count_length: integer := 4);
    
    Port ( clk   : in STD_LOGIC;
           reset : in std_logic := '0';
           Q_out : out STD_LOGIC_vector( count_length -1 downto 0);
           Rco   : out std_logic:='0');
           
end Counter;

architecture Behavioral of Counter is
signal final_value : std_logic_vector(count_length - 1 downto 0);
signal output      : std_logic :='0';

begin               
-- in a fix situation you can use generic and define it here it's value
final_value <= std_logic_vector(to_unsigned(count_num, count_length));

process(clk)
variable count : integer range 0 to count_num := 0;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count := 0;
                output <= '0';
            -- you can add start zone here 
            elsif count = count_num then
                output <= not output;
                count := 0;
            else 
                count := count + 1;
                --output <= '0';                               
            end if;
        end if;
    end process;
    
rco <= output;

end Behavioral;
