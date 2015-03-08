----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:01:27 02/02/2015 
-- Design Name: 
-- Module Name:    alu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( rst : in  STD_LOGIC;
           in1 : in  SIGNED (7 downto 0);
           in2 : in  SIGNED (7 downto 0);
           alu_mode : in  STD_LOGIC_VECTOR (2 downto 0);
           result : out  SIGNED (7 downto 0);
           z_flag : out  STD_LOGIC;
           n_flag : out  STD_LOGIC);
end alu;

architecture Behavioral of alu is


begin
process (alu_mode, in1, in2, rst)
	variable int_result : SIGNED (7 downto 0);

	begin
		
		case alu_mode(2 downto 0) is
			when "100" => --add
				int_result := in1 + in2;
				
				if (int_result = 0) then
					z_flag <= '1';
				else 
					z_flag <= '0';
				end if;
				
				if (int_result < 0) then
					n_flag <= '1';
				else
					n_flag <= '0';
				end if;
			when "101" => -- subtract
				int_result := in1 - in2;
				
				if (int_result = 0) then
					z_flag <= '1';
				else 
					z_flag <= '0';
				end if;
				
				if (int_result < 0) then
					n_flag <= '1';
				else
					n_flag <= '0';
				end if;
			when "110" => -- nand
				int_result := in1 nand in2;
				
				if (int_result = 0) then
					z_flag <= '1';
				else 
					z_flag <= '0';
				end if;
				
				if (int_result < 0) then
					n_flag <= '1';
				else
					n_flag <= '0';
				end if;
			when "111" => -- shift left logical
				int_result(7 downto 1) := in1(6 downto 0);
				int_result(0) := '0';
				z_flag <= in1(7);
				n_flag <= '0';
			when "000" => -- shift right logical
				int_result(6 downto 0) := in1(7 downto 1);
				int_result(7) := '0';
				z_flag <= in1(0);
				n_flag <= '0';
			when others => -- Default output
				int_result := "00000000";
				z_flag <= '0';
				n_flag <= '0';
		end case;
		
		result <= int_result;
		
		if (rst='1') then
			z_flag <= '0';
			n_flag <= '0';
			result <= "00000000";
		end if;	
end process;
	
end Behavioral;

