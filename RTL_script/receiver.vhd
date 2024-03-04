----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2024 09:53:07 AM
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver is
    generic(data_in_num   : integer := 8;
        stop_bit_num      : integer := 1;
        start_bit_num     : integer := 1;
        parity_enable     : integer := 1);
        
    Port ( Data_in_s      : in STD_LOGIC;
           clk            : in STD_LOGIC;
           clk_br         : in std_logic;
           reset          : in STD_LOGIC;
           Data_out_p     : out STD_LOGIC_VECTOR (7 downto 0);
           data_out_valid : out STD_LOGIC;
           error          : out STD_LOGIC);
           
end receiver;



--***************                    ***************--
--*************** start Architecture ***************--
--***************                    ***************--

architecture Behavioral of receiver is

--========Defining components=======--
component EvenOdd is
    generic(data_length  : integer := 8);
    Port   (data_in      : in STD_LOGIC_VECTOR (data_length - 1 downto 0);
            clk          : in std_logic;
            new_data     : in std_logic;
            ready_out    : out std_logic := '0';
            is_odd       : out STD_LOGIC);
end component;

------Defining Constants-------
constant frame_length    : integer:= start_bit_num + data_in_num + parity_enable + stop_bit_num;--1


------Defining signals-------
signal data_ld_enb  : std_logic := '0';
signal Frame        : std_logic_vector(frame_length -1 downto 0);
signal frme_comp    : std_logic := '0';
signal trigger      : std_logic := '0';
signal init_GND     : std_logic_vector(data_in_num -1 downto 0) ;

------
signal stop_bit          : std_logic_vector (stop_bit_num - 1 downto 0);
signal parity_bit        : std_logic;--_vector (parity_enable - 1 downto 0);--_vector (parity_enable - 1 downto 0); -- change here later --_vector (parity_enable - 1 downto 0)
signal start_bit         : std_logic_vector (start_bit_num - 1 downto 0);
signal Data_reg          : std_logic_vector(data_in_num -1 downto 0);

------
signal parity_flg        : std_logic :='0';
signal is_odd : std_logic := '0';
signal seprt_flg  : std_logic := '0';

signal count : integer range 0 to frame_length:= 0;

--===================================--
  --======Begining Semantic=======--
--===================================--
begin
-- constant wires & regs
init_GND <= std_logic_vector(to_unsigned(0, data_in_num));

-- instantiate Components 
p_b_checker: EvenOdd generic map(data_length => data_in_num ) --parity_bit_maker
                   Port map   (data_in     => data_reg,
                               clk         => clk,
                               new_data    => seprt_flg,
                               ready_out   => parity_flg,
                               is_odd      => is_odd);
                               
                               
-- reciving Data Frame
loading_data: process(clk_br, reset)
--variable count : integer range 0 to frame_length:= 0;
    begin
    if rising_edge(clk_br) then 
        if data_ld_enb = '0' then
            if data_in_s = '0' then
                Frame(count) <= data_in_s;
                --count := count + 1;
                count <= count + 1;
                data_ld_enb <= '1';
            end if;
            
        elsif data_ld_enb = '1' then
            Frame(count) <= data_in_s;
            --count := count + 1;
            count <= count + 1;
            
            if count = frame_length - 1 then -- -1
                --count := 0;
                count <= 0;
                data_ld_enb <= '0';
                frme_comp <= not frme_comp;--'1';
            end if;
            
        end if;
        
    end if;  
    end process;
  
-- seprate data, parity(s), start_bit(s), stop_bit(s) from frame      
sep_data : process(clk)
    begin       
        if rising_edge(clk) then
            if frme_comp /= trigger then --'1' 
                start_bit  <= Frame(start_bit_num - 1 downto 0);
                Data_reg   <= Frame(data_in_num + start_bit_num - 1 downto start_bit_num);
                parity_bit <= Frame(parity_enable + data_in_num + start_bit_num -1);-- downto (data_in_num + start_bit_num));
                stop_bit   <= Frame(stop_bit_num + parity_enable + data_in_num + start_bit_num -1 downto parity_enable + data_in_num + start_bit_num);
                seprt_flg  <= '1';
                trigger <= not trigger;
            else
                seprt_flg <= '0';
            end if;
        end if;      
    end process;    

-- check whether data is valid or not then sen it
data_valid: process(clk)
    begin
        if rising_edge(clk)then
            if parity_flg = '1' then
                if parity_bit /= is_odd then
                    error <= '1';
                    data_out_valid <= '0';  
                else
                    data_out_p <= Data_reg;
                    data_out_valid <= '1';        
                end if;
            else
                data_out_p <= init_GND; -- ground as null
                data_out_valid <= '0';
                error <= '0';
            end if;
        end if;
    end process;
    

end Behavioral;
