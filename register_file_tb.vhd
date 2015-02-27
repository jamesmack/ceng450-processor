--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:45:31 02/02/2015
-- Design Name:   
-- Module Name:   C:/Users/sheads/ceng450/Ceng450_Project/register_file_tb.vhd
-- Project Name:  Ceng450_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity test_alu is
end test_alu;

architecture behavioural of test_alu is

component register_file
	port(rst : in std_logic;
		clk: in std_logic;
		rd_index1: in std_logic_vector(1 downto 0);
		rd_index2: in std_logic_vector(1 downto 0);
		rd_data1: out std_logic_vector(7 downto 0);
		rd_data2: out std_logic_vector(7 downto 0);
		wr_index: in std_logic_vector(1 downto 0);
		wr_data: in std_logic_vector(7 downto 0);
		wr_enable: in std_logic);
end component;

signal rst : std_logic;
signal clk : std_logic;
signal rd_index1 : std_logic_vector(1 downto 0);
signal rd_index2 : std_logic_vector(1 downto 0);
signal rd_data1 : std_logic_vector(7 downto 0);
signal rd_data2 : std_logic_vector(7 downto 0);

signal wr_index : std_logic_vector(1 downto 0);
signal wr_data : std_logic_vector(7 downto 0);
signal wr_enable : std_logic;

begin
u0:register_file port map(rst, clk, rd_index1, rd_index2, rd_data1, rd_data2, wr_index, wr_data, wr_enable);

process
begin
clk <= '0';
wait for 10 us;
clk <= '1';
wait for 10 us;
end process;

process
begin
rst <= '1';
rd_index1 <= "00";
rd_index2 <= "00";
wr_enable <= '0';
wr_index <= "00";
wr_data <= "00000000";

wait until (clk='0' and clk'event);
wait until (clk='1' and clk'event);
wait until (clk='1' and clk'event);

rst <= '0';

wait until (clk='1' and clk'event);
wr_enable <= '1';
wr_data <= X"2a";

wait until (clk='1' and clk'event);
wr_index <= "01";
wr_data <= X"37";

wait until (clk='1' and clk'event);
wr_index <= "10";
wr_data <= X"8b";

wait until (clk='1' and clk'event);
wr_index <= "11";
wr_data <= X"fd";

wait until (clk='1' and clk'event);
wr_enable <= '0';

wait until (clk='1' and clk'event);
rd_index2 <= "01";

wait until (clk='1' and clk'event);
rd_index1 <= "10";
rd_index2 <= "11";

wait;
end process;

end behavioural;