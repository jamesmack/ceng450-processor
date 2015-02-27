library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity ROM_VHDL is
    port(
         clk      : in  std_logic;
         addr     : in  std_logic_vector (6 downto 0);
         data     : out std_logic_vector (7 downto 0)
         );
end ROM_VHDL;

architecture BHV of ROM_VHDL is

    type ROM_TYPE is array (0 to 127) of std_logic_vector (7 downto 0);

    constant rom_content : ROM_TYPE := (
	 "10110000", -- in r0
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "01000001", -- add r0, r1
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "11011000", -- move r2,r0
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "01011001", -- sub r2, r1
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "11001000", -- out r2
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000", -- noop
	 "00000000" -- noop
	);
begin

p1:    process (clk)
	 variable add_in : integer := 0;
    begin
        if rising_edge(clk) then
					 add_in := conv_integer(unsigned(addr));
                data <= rom_content(add_in);
        end if;
    end process;
end BHV;


