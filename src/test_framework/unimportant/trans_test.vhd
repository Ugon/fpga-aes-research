library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_transformations.all;
use work.aes_utils.all;


entity trans_test is
port (
	inp: in std_logic_vector(127 downto 0);
	outp: out std_logic_vector(127 downto 0);
	expe: out std_logic_vector(7 downto 0)
);
end entity trans_test;

architecture rtl of trans_test is

begin
	--outp <= mix_columns(inp);
	--outp(7 downto 0) <= calc_sub(inp(7 downto 0));
	--expe <= lookup_sub(inp(7 downto 0));
end architecture rtl;
