----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2023 07:42:23 PM
-- Design Name: 
-- Module Name: log2 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.fixed_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity log2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           i_data : in SIGNED(23 downto 0);
           o_data : out unsigned(23 downto 0)
           );


end log2;

architecture Behavioral of log2 is

    --state signals
    type log2_state is (start, lead, fraction); --, fraction
    signal state : log2_state := start;
    
    --counter signals
    signal counter22 : unsigned(4 downto 0);
    signal counter19: std_logic_vector(4 downto 0);
    
    --lead signals
    --signal x_input: unsigned(47 downto 0);
    signal x_zero: unsigned(45 downto 0);
    signal x_calc: unsigned(45 downto 0);
    signal x_frac : unsigned(23 downto 0);
    signal l2 : unsigned(23 downto 0);
    signal f2 : unsigned(18 downto 0);
    signal l2_test : unsigned(4 downto 0);
  
    
begin
    process(clk) is
 --       --generate variables for checking the sign
  variable x_input: unsigned(45 downto 0);
        variable i_data_signed : signed(23 downto 0);
       variable i_data_unsigned : unsigned(22 downto 0);    
    begin
        if rising_edge(clk) then
            if rst = '0' then
            x_input :=(others =>'0');
            x_zero <= (others =>'0');
            l2 <= (others =>'0');
            x_calc <= (others =>'0');
            o_data <= (others=> '0');
            f2 <= (others=> '0');
           
            
            --signals 0 or whatever
            
            else
                counter22 <= "10110";
                counter19 <= "00001";
                f2(0) <= '1';
                
                case state is
                
                
                    when start =>
                   -- convert the signed to unsigned incase the input is negative
                        if i_data(23) = '1' then
                            i_data_signed := i_data;
                            i_data_unsigned := unsigned(not i_data_signed(22 downto 0) + 1);
                        else
                            i_data_unsigned := unsigned(i_data(22 downto 0));
                        end if;
                        
                    --end of the convertion 
                    --decide if the data is valid for calculation
                        x_input := (45 downto i_data_unsigned'length => '0') & i_data_unsigned;
                        
                        if x_input > 0 then
                            x_calc <= x_input;
                            state <= lead; --go to calculate the lead
                        elsif x_input = x_zero then
                           state <= lead; --wait for valid data
                        end if;
                      
                      when lead =>
                      
                        if (x_calc(45 downto 22) = 0) then
                           x_calc(45 downto 0) <= x_calc(44 downto 0) & '0';
                          counter22 <= counter22 -1;
                           state <= lead;
                        else
                            l2(23 downto 19)<= counter22;
                            l2_test <= counter22;
                            x_frac <= x_calc(23 downto 0);                            
                            state <= fraction;
                            counter22 <= "10110"; --do we need this here? not sure
                        end if;
                      
                      
                      
                      when fraction =>
                             x_frac <= unsigned("*"(unsigned(x_frac), unsigned(x_frac))(45 downto 22));

                            if counter19 < "10011" then
                                
                                if x_frac(23 downto 22) >= "10" then
                                    f2 <= f2(17 downto 0) & '0';
                                    l2(18 downto 0) <= l2(18 downto 0) + f2;
                                    x_frac <= '0' & x_frac(23 downto 1);
                                    counter19 <= counter19 + 1;
                                    state <= fraction;
                                    
                                else
                                    counter19 <= counter19 + 1;
                                    state <= fraction;
                                end if;
                                
                             else
                            o_data <= l2; 
                           state <= start;  
                            end if;
                                  
               
            
            end case;              
            end if;
          
        end if;

    end process;

end Behavioral;
