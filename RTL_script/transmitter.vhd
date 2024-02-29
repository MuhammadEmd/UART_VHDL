----------------------------------------------------------------------------------
-- Company: R(task)
-- Engineer: MuhammadH Emd
-- 
-- Create Date: 02/29/2024 4:35:55 PM
-- Design Name: transmitter module
-- Module Name: transmitter - Behavioral
-- Project Name: UART
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

entity transmitter is
    generic(
        data_in_num     : integer := 8;
        stop_bit_num    : integer := 1;
        start_bit_num   : integer := 1;
        parity_enable   : integer := 1
    );
    
    Port ( data_in_p        : in STD_LOGIC_VECTOR (data_in_num - 1 downto 0);
           clk_br           : in std_logic;
           clk              : in std_logic;
           input_data_valid : in std_logic;
           reset            : in std_logic; --active high
           data_out_s       : out STD_LOGIC:= '1');
           
end transmitter;

architecture Behavioral of transmitter is
constant frame_length    : integer:= data_in_num + parity_enable + stop_bit_num;--1

signal out_reg           : std_logic_vector ( frame_length - 1 downto 0):="1111111111";
signal stop_bit          : std_logic_vector (stop_bit_num - 1 downto 0);
signal parity_bit        : std_logic_vector (parity_enable - 1 downto 0); -- change here later --_vector (parity_enable - 1 downto 0)
signal start_bit         : std_logic_vector (start_bit_num - 1 downto 0); --:= '0'
signal init_value_VCC    : std_logic_vector(frame_length - 1 downto 0);
signal init_stop_bit     : std_logic_vector(stop_bit_num - 1 downto 0);
signal init_start_bit    : std_logic_vector(start_bit_num - 1 downto 0);
signal init_parity_bit   : std_logic_vector(parity_enable - 1 downto 0);
signal Data_reg          : std_logic_vector(data_in_num -1 downto 0);

signal new_data : std_logic := '0';
-- define counter component and later use it
begin

-- in such cases you don't know the length of the array and
-- want to give inintial value!
init_value_VCC  <= std_logic_vector(to_unsigned(2**(frame_length)-1, frame_length));-- this is wrong!!!
init_stop_bit   <= std_logic_vector(to_unsigned(0, stop_bit_num)); -- it must change
init_start_bit  <= std_logic_vector(to_unsigned(0, start_bit_num));
init_parity_bit <= std_logic_vector(to_unsigned(0, parity_enable));
stop_bit        <= init_stop_bit; --omit here later
start_bit       <= init_start_bit;
parity_bit      <= init_parity_bit;

-- new code decleration    
    process(clk, clk_br, reset)
    begin
        if reset = '1' then
            out_reg <= init_value_VCC;
            
        elsif rising_edge(clk) then
            if input_data_valid = '1' then
                Data_reg <= data_in_p;
                new_data <= '1';  
                -- add data_ready here later after counting the number of parity
                -- and defining stop_bit ether
                -- then use data_ready in order to send data in first clk_br after got ready
                -- u can add checking whethere last data is sent or not then access data_ready
            end if;
            
        elsif rising_edge(clk_br) then
            if new_data = '1' then
                out_reg <= stop_bit & parity_bit & Data_reg & start_bit(start_bit_num -1 downto 1) ;--& start_bit
                new_data <= '0';
            else
                out_reg(frame_length-1 downto 0) <= '1' & out_reg(frame_length-1 downto 1);
            end if;
        end if;
    end process;
    
    process(clk_br)
    begin 
        if rising_edge(clk_br) then
            if new_data = '1' then --data_ready
                data_out_s <= start_bit(0);
            else    -- don't forget the frame_length and all other related(omit start bit from them)
                data_out_s <= out_reg(0);
            end if;
        end if;
    end process;
    


end Behavioral;
