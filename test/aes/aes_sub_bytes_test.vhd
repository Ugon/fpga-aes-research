library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;
use work.aes_utils.all;


entity aes_sub_bytes_test is
port (
	inp:       in  std_logic_vector(127 downto 0);
	expe:      in  std_logic_vector(127 downto 0);
	calc:      out std_logic_vector(127 downto 0);
	lookup:    out std_logic_vector(127 downto 0);
	eq_calc:   out std_logic;
	eq_lookup: out std_logic
);
end entity aes_sub_bytes_test;

architecture rtl of aes_sub_bytes_test is
	signal result_calc:   std_logic_vector(127 downto 0);
	signal result_lookup: std_logic_vector(127 downto 0);
begin
	result_calc <= sub_bytes_calc(inp);
	result_lookup <= sub_bytes_lookup(inp);
	calc <= result_calc;
	lookup <= result_lookup;

	process (expe, result_lookup) begin
		if (expe = result_lookup) then
			eq_lookup <= '1';
		else
			eq_lookup <= '0';
		end if;
	end process;

	process (expe, result_calc) begin
		if (expe = result_calc) then
			eq_calc <= '1';
		else
			eq_calc <= '0';
		end if;
	end process;
	
end architecture rtl;
