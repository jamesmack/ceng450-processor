----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:29:29 02/16/2015 
-- Design Name: 
-- Module Name:    cpu - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu is
    Port ( in_port : in  STD_LOGIC_VECTOR (7 downto 0);
           out_port : out  STD_LOGIC_VECTOR (7 downto 0);
           clock : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end cpu;

architecture Behavioral of cpu is

component alu
	Port ( rst : in  STD_LOGIC;
				  in1 : in  SIGNED (7 downto 0);
				  in2 : in  SIGNED (7 downto 0);
				  alu_mode : in  STD_LOGIC_VECTOR (2 downto 0);
				  result : out  SIGNED (7 downto 0);
				  z_flag : out  STD_LOGIC;
				  n_flag : out  STD_LOGIC);
end component;

component ROM_VHDL
    port(
         clk      : in  std_logic;
         addr     : in  std_logic_vector (6 downto 0);
         data     : out std_logic_vector (7 downto 0)
         );
end component;

component register_file
	port(rst : in std_logic;
		clk: in std_logic;
		--read signals
		rd_index1: in std_logic_vector(1 downto 0);
		rd_index2: in std_logic_vector(1 downto 0);
		rd_data1: out std_logic_vector(7 downto 0);
		rd_data2: out std_logic_vector(7 downto 0);
		--write signals
		wr_index: in std_logic_vector(1 downto 0);
		wr_data: in std_logic_vector(7 downto 0);
		wr_enable: in std_logic);
end component;

-- Control lines
signal reset: std_logic := '1';
signal control_reset: std_logic := '1';
signal PC: std_logic_vector(6 downto 0) := "0000000";

signal reg_write: std_logic;
signal reg_write_pulse: std_logic;
signal reg_data: std_logic_vector(7 downto 0);
signal reg_addr: std_logic_vector(1 downto 0);
signal reg_out1: std_logic_vector(7 downto 0);
signal reg_out2: std_logic_vector(7 downto 0);
signal reg_in1: std_logic_vector(1 downto 0);
signal reg_in2: std_logic_vector(1 downto 0);

signal alu_mode: std_logic_vector(2 downto 0);
signal alu_in1: SIGNED(7 downto 0);
signal alu_in2: SIGNED(7 downto 0);
signal alu_result: SIGNED(7 downto 0);
signal z_flag: std_logic;
signal n_flag: std_logic;

-- Buffer lines
signal IFID_opcode: std_logic_vector(3 downto 0);
signal IFID_ra_addr: std_logic_vector(1 downto 0);
signal IFID_rb_addr: std_logic_vector(1 downto 0);

signal IDEX_ra: std_logic_vector(7 downto 0);
signal IDEX_rb: std_logic_vector(7 downto 0);
signal IDEX_ra_addr: std_logic_vector(1 downto 0);
signal IDEX_opcode: std_logic_vector(3 downto 0);

signal EXMEM_ra: std_logic_vector(7 downto 0);
signal EXMEM_opcode: std_logic_vector(3 downto 0);
signal EXMEM_ra_addr: std_logic_vector(1 downto 0);

signal MEMWB_ra: std_logic_vector(7 downto 0);
signal MEMWB_opcode: std_logic_vector(3 downto 0);
signal MEMWB_ra_addr: std_logic_vector(1 downto 0);

-- Intermediary lines
signal OP: std_logic_vector(7 downto 0); -- used in fetch

begin


ROM: ROM_VHDL port map (clk => clock, addr => PC, data => OP);
REG: register_file port map (rst => reset, clk => clock, rd_index1 => reg_in1, rd_index2 => reg_in2, rd_data1 => reg_out1, rd_data2 => reg_out2, wr_index => reg_addr, wr_data => reg_data, wr_enable => reg_write);
ALU_EXE: alu port map ( rst => reset, in1 => alu_in1, in2 => alu_in2, result => alu_result, z_flag => z_flag, n_flag => n_flag, alu_mode => alu_mode);

-- Control Section
process (rst)
	begin
		reset <= rst;
end process;

-- Fetch Section--
process (clock, reset)
	begin
		if (reset = '1') then 
			IFID_opcode <= "0000";
			IFID_ra_addr <= "00";
			IFID_rb_addr <= "00";
			PC <= "0000000";
			control_reset <= '1';
		elsif (rising_edge(clock)) then
			if (control_reset ='1') then
				control_reset <= '0';
			else 
				IFID_opcode <= OP(7 downto 4);
				IFID_ra_addr <= OP(3 downto 2);
				IFID_rb_addr <= OP(1 downto 0);
			
				PC <= std_logic_vector( unsigned(PC) + 1 );
			end if;
		end if;
end process;

-- Decode Section
process (clock)
	begin
		if (falling_edge(clock)) then
			reg_in1 <= IFID_ra_addr;
			reg_in2 <= IFID_rb_addr;
		end if;
end process;

process (clock, control_reset)
	begin
		if (control_reset = '1') then 
			IDEX_ra_addr <= "00";
			IDEX_opcode <= "0000";
		elsif (rising_edge(clock)) then
			IDEX_ra_addr <= IFID_ra_addr;
			IDEX_opcode <= IFID_opcode;
		
			IDEX_ra <= reg_out1;
			IDEX_rb <= reg_out2;
		
			case IFID_opcode(3 downto 0) is
				when "0000" =>	-- NOP
					NULL;
				when "0100" => -- ADD
					alu_mode <= "100";
				when "0101" => -- SUB
					alu_mode <= "101";
				when "0110" => -- SHL
					alu_mode <= "111";
				when "0111" => -- SHR
					alu_mode <= "000";
				when "1000" => -- NAND
					alu_mode <= "110";
				when "1011" => -- IN
					NULL;
				when "1100" => -- OUT
					NULL;
				when "1101" => -- MOV
					NULL;
				when others => NULL;
			end case;
		end if;
end process;

-- Execute Section
process (clock)
	begin
		if (falling_edge(clock)) then
			case IDEX_opcode(3 downto 0) is
				when "0000" =>	-- NOP
					NULL;
				when "0100" => -- ADD
					alu_in1 <= SIGNED(IDEX_ra);
					alu_in2 <= SIGNED(IDEX_rb);
				when "0101" => -- SUB
					alu_in1 <= SIGNED(IDEX_ra);
					alu_in2 <= SIGNED(IDEX_rb);
				when "0110" => -- SHL
					alu_in1 <= SIGNED(IDEX_ra);
				when "0111" => -- SHR
					alu_in1 <= SIGNED(IDEX_ra);
				when "1000" => -- NAND
					alu_in1 <= SIGNED(IDEX_ra);
					alu_in2 <= SIGNED(IDEX_rb);
				when "1011" => -- IN
					NULL;
				when "1100" => -- OUT
					NULL;
				when "1101" => -- MOV
					NULL;
				when others => NULL;
			end case;
		end if;
end process;

process (clock, control_reset)
	begin
		if (control_reset = '1') then 
			EXMEM_opcode <= "0000";
			EXMEM_ra_addr <= "00";
			EXMEM_ra <= "00000000";
		elsif (rising_edge(clock)) then
			EXMEM_opcode <= IDEX_opcode;
			EXMEM_ra_addr <= IDEX_ra_addr;
			EXMEM_ra <= IDEX_ra;
		
			case IDEX_opcode(3 downto 0) is
				when "0000" =>	-- NOP
					NULL;
				when "0100" => -- ADD
					EXMEM_ra <= std_logic_vector(alu_result);
				when "0101" => -- SUB
					EXMEM_ra <= std_logic_vector(alu_result);
				when "0110" => -- SHL
					EXMEM_ra <= std_logic_vector(alu_result);
				when "0111" => -- SHR
					EXMEM_ra <= std_logic_vector(alu_result);
				when "1000" => -- NAND
					EXMEM_ra <= std_logic_vector(alu_result);
				when "1011" => -- IN
					NULL;
				when "1100" => -- OUT
					NULL;
				when "1101" => -- MOV
					EXMEM_ra <= IDEX_rb;
				when others => NULL;
			end case;
		end if;
end process;

-- Memory Section
process (clock, control_reset)
	begin
		if (control_reset = '1') then 
			MEMWB_opcode <= "0000";
			MEMWB_ra_addr <= "00";
			MEMWB_ra <= "00000000";
		elsif (rising_edge(clock)) then	
			MEMWB_opcode <= EXMEM_opcode;
			MEMWB_ra_addr <= EXMEM_ra_addr;
			MEMWB_ra <= EXMEM_ra;
		
			case EXMEM_opcode(3 downto 0) is
				when "0000" =>	-- NOP
					NULL;
				when "0100" => -- ADD
					NULL;
				when "0101" => -- SUB
					NULL;
				when "0110" => -- SHL
					NULL;
				when "0111" => -- SHR
					NULL;
				when "1000" => -- NAND
					NULL;
				when "1011" => -- IN
					MEMWB_ra <= in_port;
				when "1100" => -- OUT
					out_port <= EXMEM_ra;
				when "1101" => -- MOV
					NULL;
				when others => NULL;
			end case;	
		end if;
end process;

-- Write Back Section
process (clock, control_reset)
	begin
		if (control_reset = '1') then
			reg_write_pulse <= '0';
			reg_data <= "00000000";
			reg_addr <= "00";
		elsif (rising_edge(clock)) then	
			if (reg_write_pulse = '1') then
				reg_write_pulse <= '0';
			end if;
			
			case MEMWB_opcode(3 downto 0) is
				when "0000" =>	-- NOP
					NULL;
				when "0100" => -- ADD
					reg_data <= MEMWB_ra;
					reg_addr <= MEMWB_ra_addr;
					reg_write_pulse <= '1';
				when "0101" => -- SUB
					reg_data <= MEMWB_ra;
					reg_addr <= MEMWB_ra_addr;
					reg_write_pulse <= '1';
				when "0110" => -- SHL
					reg_data <= MEMWB_ra;
					reg_addr <= MEMWB_ra_addr;
					reg_write_pulse <= '1';
				when "0111" => -- SHR
					reg_data <= MEMWB_ra;
					reg_addr <= MEMWB_ra_addr;
					reg_write_pulse <= '1';
				when "1000" => -- NAND
					reg_data <= MEMWB_ra;
					reg_addr <= MEMWB_ra_addr;
					reg_write_pulse <= '1';
				when "1011" => -- IN
					reg_data <= MEMWB_ra;
					reg_addr <= MEMWB_ra_addr;
					reg_write_pulse <= '1';
				when "1100" => -- OUT
					NULL;
				when "1101" => -- MOV
					reg_data <= MEMWB_ra;
					reg_addr <= MEMWB_ra_addr;
					reg_write_pulse <= '1';
				when others => NULL;
			end case;
		end if;
end process;

reg_write <= reg_write_pulse and clock;

end Behavioral;

