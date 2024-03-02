----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2024 03:34:31 PM
-- Design Name: 
-- Module Name: EvenOdd - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EvenOdd is
    generic(data_length : integer := 8);
    Port   (data_in     : in STD_LOGIC_VECTOR (data_length - 1 downto 0);
            clk         : in std_logic;
            new_data    : in std_logic;
            ready_out  : out std_logic := '0';
            is_odd     : out STD_LOGIC);
end EvenOdd;

architecture Behavioral of EvenOdd is
--signal temp : std_logic_vector(1 downto 0):="00"; 
signal count_enable: std_logic := '0'; 
signal data_ready  : std_logic := '0'; 
signal counter : integer range 0 to data_length ;--:= 0
signal bit_number : integer range 0 to data_length ;--:= 0
  
begin
    
    process (clk)
--    variable count  : integer range 0 to data_length := 0;
--    variable bit_num: integer range 0 to data_length := 0;
    variable temp : std_logic_vector(1 downto 0):="00"; -- if you change it to a register
    -- be carefull with the last bit
    
    begin
        if rising_edge(clk) then
            if new_data = '1' then
                count_enable <= '1';
                counter <= 0;
                
            elsif bit_number = 8 then
                count_enable <= '0';
                --counter <= count;
                data_ready <= '1';
                temp := "00";
                bit_number <= 0;
                   
            elsif count_enable = '1' then
                temp := '0' & ('0' xor data_in(bit_number));
                counter <= counter + to_integer(unsigned(temp));
                bit_number <= bit_number + 1;
                
            
                --count   := 0;
                --end if;
                
            else
                data_ready <= '0';
                      
            end if;
        end if;    
    end process;

process(data_ready)
begin
    if data_ready = '1' then    
       --is_even <= '0' when counter mod 2 = 0 else '1';
       ready_out <= '1';
       if counter mod 2 = 0 then
          is_odd <= '0';
       else
          is_odd <= '1';
       end if;
    else
        ready_out <= '0'; 
    end if;
end process;
    
end Behavioral;
