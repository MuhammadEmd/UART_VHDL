----------------------------------------------------------------------------------
-- Company: rstfn task
-- Engineer: MH_E
-- 
-- Create Date: 03/03/2024 06:46:28 PM
-- Design Name: UART
-- Module Name: UART_module - Behavioral
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
use ieee.math_real.all;
--use IEEE.std_logic_unsigned.all
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_module is
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
end UART_module;


--***************                    ***************--
--*************** start Architecture ***************--
--***************                    ***************--

architecture Behavioral of UART_module is

--========Defining components=======--
component transmitter 
    generic(
        data_in_num           : integer := 8;
        stop_bit_num          : integer := 1;
        start_bit_num         : integer := 1;
        parity_enable         : integer := 1
    );
    
    Port ( data_in_p          : in STD_LOGIC_VECTOR (data_in_num - 1 downto 0);
           clk_br             : in std_logic;--@#$^*)(*&$*&%^$change here
           clk                : in std_logic;
           input_data_valid   : in std_logic;
           reset              : in std_logic; --active high
           data_out_s         : out STD_LOGIC:= '1');
    end component;
    
       
component receiver 
    generic(data_in_num       : integer := 8;
            stop_bit_num      : integer := 1;
            start_bit_num     : integer := 1;
            parity_enable     : integer := 1);
        
    Port ( Data_in_s          : in STD_LOGIC;
           clk                : in STD_LOGIC;
           clk_br             : in std_logic;
           reset              : in STD_LOGIC;
           Data_out_p         : out STD_LOGIC_VECTOR (7 downto 0);
           data_out_valid     : out STD_LOGIC;
           error              : out STD_LOGIC);           
    end component;

component Counter
    generic(count_num         : integer := 2604 - 1;
            count_length      : integer := 11);
             
    port(   clk               : in STD_LOGIC;
            reset             : in std_logic := '0';
            Q_out             : out STD_LOGIC_vector( count_length -1 downto 0);
            Rco               : out std_logic:='0');           
    end component;


------Defining signals-------
signal clk_br : std_logic :='0';
signal Q_out : std_logic_vector(11 -1 downto 0);



--===================================--
  --======Begining Semantic=======--
--===================================--    
begin

-- instantiate Components
baud_rate : Counter generic map(
                           count_num    => 2604-1 ,
                           count_length =>  11)
                     port map(
                           clk          => clk,
                           reset        => rst,
                           Q_out        => Q_out,
                           Rco          => clk_br );
                           
TX_module : transmitter generic map(
                        data_in_num     => data_in_num,
                        stop_bit_num    => stop_bit_num,
                        start_bit_num   => start_bit_num,
                        parity_enable   => parity_enable)
    
                        Port map(
                        data_in_p        => InputData,
                        clk_br           => clk_br, 
                        clk              => clk,
                        input_data_valid => InputValid,
                        reset            => rst, --active high
                        data_out_s       => TX);
                        
RX_Module: receiver generic map(
                        data_in_num      => data_in_num,
                        stop_bit_num     => stop_bit_num,
                        start_bit_num    => start_bit_num,
                        parity_enable    => parity_enable)
        
                    Port map(
                        Data_in_s        => RX,
                        clk              => clk,
                        clk_br           => clk_br,
                        reset            => Rst,
                        Data_out_p       => OutputData,
                        data_out_valid   => OutputValid,
                        error            => Error);
end Behavioral;
