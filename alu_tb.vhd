--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:21:33 02/02/2015
-- Design Name:   
-- Module Name:   C:/Users/sheads/ceng450/Ceng450_Project/alu_tb.vhd
-- Project Name:  Ceng450_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         in1 : IN  SIGNED(7 downto 0);
         in2 : IN  SIGNED(7 downto 0);
         alu_mode : IN  std_logic_vector(2 downto 0);
         result : OUT  SIGNED(7 downto 0);
         z_flag : OUT  std_logic;
         n_flag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal in1 : SIGNED (7 downto 0) := (others => '0');
   signal in2 : SIGNED (7 downto 0) := (others => '0');
   signal alu_mode : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal result : SIGNED (7 downto 0);
   signal z_flag : std_logic;
   signal n_flag : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          rst => rst,
          clk => clk,
          in1 => in1,
          in2 => in2,
          alu_mode => alu_mode,
          result => result,
          z_flag => z_flag,
          n_flag => n_flag
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clk_period*10;
		
		--add no flags
		in1 <= "00100000";
		in2 <= "01000000";
		alu_mode <= "100";
		wait for 100ns;
		
		--add -1 and 1 for zero flag
		in1 <= "11111111";
		in2 <= "00000001";
		alu_mode <= "100";
		wait for 100ns;
		
		--add -50 + 25 for neg flag
		in1 <= "11001110";
		in2 <= "00011001";
		alu_mode <= "100";
		wait for 100ns;
		
		-- sub -1 and 1 for -2, n flag
		in1 <= "11111111";
		in2 <= "00000001";
		alu_mode <= "101";
		wait for 100ns;
		
		-- sub 50 - 25
		in1 <= "00110010";
		in2 <= "00011001";
		alu_mode <= "101";
		wait for 100ns;
		
		-- sub 1 - 1 for 0, z flag
		in1 <= "00000001";
		in2 <= "00000001";
		alu_mode <= "101";
		wait for 100ns;
		
		--nand no flags
		in1 <= "10101011";
		in2 <= "11011111";
		alu_mode <= "110";
		wait for 100ns;
		
		--nand z flag
		in1 <= "11111111";
		in2 <= "11111111";
		alu_mode <= "110";
		wait for 100ns;
		
		--shift right
		in1 <= "10000000";
		alu_mode <= "000";
		wait for 100ns;
		
		--shift left
		in1 <= "00000001";
		alu_mode <= "111";
		wait for 100ns;
		
		-- reset flags
		rst <= '1';
		wait for 50ns;
		rst <= '0';
		wait for 50ns;
		
		--nand n flag
		in1 <= "10101010";
		in2 <= "01011111";
		alu_mode <= "110";
		wait for 100ns;
		
		--shift left
		in1 <= "00000001";
		alu_mode <= "111";
		wait for 100ns;
		
		-- reset flags
		rst <= '1';
		wait for 50ns;
		rst <= '0';
		wait for 50ns;
		
		
		
		--
		
      wait;
   end process;

END;
