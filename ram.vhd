----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:57:34 03/15/2015 
-- Design Name: 
-- Module Name:    ram - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity RAM_VHDL is
    port(
         clk      : in  std_logic;
         addr     : in  std_logic_vector (6 downto 0);
         data     : out std_logic_vector (7 downto 0);
			wr_data	: in std_logic_vector (7 downto 0);
			wr_addr	: in  std_logic_vector (6 downto 0);
			wr_en			: in std_logic
         );
end RAM_VHDL;

architecture BHV of RAM_VHDL is

    type RAM_TYPE is array (0 to 127) of std_logic_vector (7 downto 0);

signal ram_content : RAM_TYPE := (
	others =>	x"00"
);

begin

proc_read:	process (ram_content, addr)
	variable addr_in : integer := 0;

   begin
			addr_in := conv_integer(unsigned(addr));
			data <= ram_content(addr_in);
   end process;
	 
proc_write:	process (clk)
	variable wr_addr_in : integer := 0;

	begin
		if falling_edge(clk) then
			if (wr_en = '1') then
				wr_addr_in := conv_integer(unsigned(wr_addr));
				ram_content(wr_addr_in) <= wr_data;
			end if;
		end if;
	end process;
end BHV;


