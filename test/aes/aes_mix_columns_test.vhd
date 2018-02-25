library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_mix_columns.all;
use work.aes_utils.all;


entity aes_mix_columns_test is
port (
	inp:       in  std_logic_vector(127 downto 0);
	expe:      in  std_logic_vector(127 downto 0);
	outp:      out std_logic_vector(127 downto 0);
	eq:        out std_logic
);
end entity aes_mix_columns_test;

architecture rtl of aes_mix_columns_test is
	signal result:   std_logic_vector(127 downto 0);
begin
	result <= mix_columns_b(mix_columns_a(inp));
	outp <= result;

	process (expe, result) begin
		if (expe = result) then
			eq <= '1';
		else
			eq <= '0';
		end if;
	end process;
	
end architecture rtl;
