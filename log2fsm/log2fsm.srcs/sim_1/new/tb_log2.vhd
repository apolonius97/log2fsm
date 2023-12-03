----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2023 08:58:00 PM
-- Design Name: 
-- Module Name: tb_log2 - Behavioral
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
use IEEE.numeric_std.unsigned;
use ieee.fixed_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_log2 is
--  Port ( );
end tb_log2;

architecture Behavioral of tb_log2 is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal i_data : SIGNED(23 downto 0);
    signal o_data : unsigned(23 downto 0);

begin
    clk <= not clk after 5ns;
      rst <= '0', '1' after 50 ns;
    dut: entity work.log2(Behavioral)
        port map(
            clk => clk,
            rst => rst,
            i_data => i_data,
            o_data => o_data
        );
    
    stimulus:
    process begin
       
      wait until (rst = '1');
      --i_data <= "000000000000001110000001";
    --  wait for 300ns;

     -- wait for 30ns;
        i_data <= "000000000000000001111000";

        wait for 300ns;

 
      --  i_data <= "000011110000000001111000";

      --  wait for 300ns;
--        i_data <= "001000000000000001111000";


--        wait for 30ns;

--      --wait for 30ns;
--        i_data <= "000011110000000001111000";
--        wait for 30ns;
--        i_data <= "011000000000000001111000";

   wait for 30ns;

    end process stimulus;


end Behavioral;
