library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_shift_rows.all;
use work.aes_utils.all;


entity aes_shift_rows_test is
port (
	inp:       in  std_logic_vector(127 downto 0);
	expe:      in  std_logic_vector(127 downto 0);
	outp:      out std_logic_vector(127 downto 0);
	eq:        out std_logic
);
end entity aes_shift_rows_test;

architecture rtl of aes_shift_rows_test is
	signal result:   std_logic_vector(127 downto 0);
begin
	result <= shift_rows(inp);
	outp <= result;

	process (expe, result) begin
		if (expe = result) then
			eq <= '1';
		else
			eq <= '0';
		end if;
	end process;
	
end architecture rtl;
