library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;
use work.aes_utils.all;


entity aes_sub_byte_test is
port (
	inp:    in  std_logic_vector(7 downto 0);
	calc:   out std_logic_vector(7 downto 0);
	lookup: out std_logic_vector(7 downto 0);
	eq:     out std_logic
);
end entity aes_sub_byte_test;

architecture rtl of aes_sub_byte_test is
	signal result_calc: std_logic_vector(7 downto 0);
	signal result_lookup: std_logic_vector(7 downto 0);
begin
	result_calc <= sub_byte_calc(inp);
	result_lookup <= sub_byte_lookup(inp);
	calc <= result_calc;
	lookup <= result_lookup;

	process (result_calc, result_lookup) begin
		if (result_calc = result_lookup) then
			eq <= '1';
		else
			eq <= '0';
		end if;
	end process;
	
end architecture rtl;
