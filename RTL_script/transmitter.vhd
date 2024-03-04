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

--component Counter
--    generic( count_num : integer := 1354-1;
--             count_length: integer := 9);
             
--    port( clk   : in STD_LOGIC;
--           reset : in std_logic := '0';
--           Q_out : out STD_LOGIC_vector( count_length -1 downto 0);
--           Rco   : out std_logic:='0');           
--    end component;
    
component EvenOdd is
    generic(data_length  : integer := 8);
            
    Port   (data_in      : in STD_LOGIC_VECTOR (data_length - 1 downto 0);
            clk          : in std_logic;
            new_data     : in std_logic;
            ready_out    : out std_logic := '0';
            is_odd       : out STD_LOGIC);
end component;

----------- signals and constants and variables
signal Q_out : STD_LOGIC_vector( 9 -1 downto 0);
--signal clk_br   : std_logic:='0';

constant frame_length    : integer:= data_in_num + parity_enable + stop_bit_num;--1

signal out_reg           : std_logic_vector ( frame_length - 1 downto 0):="1111111111";
signal stop_bit          : std_logic_vector (stop_bit_num - 1 downto 0);
signal parity_bit        : std_logic;--_vector (parity_enable - 1 downto 0); -- change here later --_vector (parity_enable - 1 downto 0)
signal start_bit         : std_logic_vector (start_bit_num - 1 downto 0); --:= '0'
-- init_value_GND    : std_logic_vector(data_in_num - 1 downto 0);
signal init_value_VCC    : std_logic_vector(frame_length - 1 downto 0);
signal init_stop_bit     : std_logic_vector(stop_bit_num - 1 downto 0);
signal init_start_bit    : std_logic_vector(start_bit_num - 1 downto 0);
signal init_parity_bit   : std_logic_vector(parity_enable - 1 downto 0);
signal Data_reg          : std_logic_vector(data_in_num -1 downto 0);

signal new_data         : std_logic := '0';
--signal is_odd           : STD_LOGIC;
signal parity_ready     : STD_LOGIC;
signal temp_data        : STD_LOGIC_vector(data_in_num + parity_enable + start_bit_num -1 -1 downto 0);
signal temp_data_full   : STD_LOGIC_vector( stop_bit_num + data_in_num + parity_enable + start_bit_num -1 -1 downto 0);
signal ready_to_send    : std_logic := '0';
signal enable_f_data    : std_logic := '0';
signal trigger          : std_logic := '0';
-----------------------------------------

begin

--instantiate counter
--baud_rate  : Counter generic map(
--                           count_num    => 1354-1 ,
--                           count_length =>  9)
--                     port map(
--                           clk          => clk,
--                           reset        => reset,
--                           Q_out        => Q_out,
--                           Rco          => clk_br );

p_b_maker: EvenOdd generic map(data_length => 8 ) --parity_bit_maker
                   Port map   (data_in     => data_reg,
                               clk         => clk,
                               new_data    => new_data,
                               ready_out   => parity_ready,
                               is_odd      => parity_bit);

-- in such cases you don't know the length of the array and
-- want to give inintial value! --to_unsigned(2**(frame_length)-1
--init_value_GND  <= std_logic_vector(to_unsigned(0, data_in_num));-- this is wrong!!!
init_value_VCC  <= std_logic_vector(to_unsigned(2**(frame_length)-1, frame_length));-- this is wrong!!!
init_start_bit  <= std_logic_vector(to_unsigned(0, start_bit_num));
start_bit       <= init_start_bit;


-- new code decleration    
crt_frm_bits: process(clk, reset)
    begin
        if reset = '1' then
            --Data_reg <= init_value_GND;
            new_data <= '0';
            
        elsif rising_edge(clk) then
            if input_data_valid = '1' then
                Data_reg <= data_in_p;
                new_data <= '1';
              
            elsif parity_ready = '1' then
                temp_data <= parity_bit & Data_reg & start_bit(start_bit_num -1 downto 1); 
                enable_f_data <= '1';
                
            elsif enable_f_data = '1' then
                temp_data_full <= not(temp_data(frame_length-1-1)) & temp_data(frame_length -1 -1 downto 0);
                ready_to_send  <= not ready_to_send; --'1';
                enable_f_data <= '0';
                
            else
                new_data <= '0';
                
            end if;
        end if;
    end process;
    
conc_fram: process(clk_br, reset)
    begin
        if reset = '1' then
            out_reg <= init_value_VCC;
                          
        elsif rising_edge(clk_br) then
            if ready_to_send /= trigger then
                out_reg <= temp_data_full;-- stop_bit & parity_bit & Data_reg & start_bit(start_bit_num -1 downto 1) ;--& start_bit
                trigger <= not trigger;
            else
                out_reg(frame_length-1 downto 0) <= '1' & out_reg(frame_length-1 downto 1);
            end if;
        end if;
    end process;
 
    
sending_out: process(clk_br)
    begin 
        if rising_edge(clk_br) then
            if ready_to_send /= trigger then --data_ready
                data_out_s <= start_bit(0);
            else    -- don't forget the frame_length and all other related(omit start bit from them)
                data_out_s <= out_reg(0);
            end if;
        end if;
    end process;
    


end Behavioral;
