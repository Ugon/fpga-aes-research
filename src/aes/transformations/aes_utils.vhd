library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;

package aes_utils is
	 
	function idx (constant row: Integer; constant column: Integer) return std_logic_vector;

end aes_utils;

package body aes_utils is

	function l (constant row: Integer; constant column: Integer) return Integer is begin
		return ((3 - row) + 4 * (3 - column) + 1) * 8 - 1;
	end function;
	

	function r (constant row: Integer; constant column: Integer) return Integer is begin
		return ((3 - row) + 4 * (3 - column)) * 8;
	end function;


	function idx (constant row: Integer; constant column: Integer)  return std_logic_vector is 
		variable rang: std_logic_vector(l(row, column) downto r(row, column)) := (others => '0');
	begin
		return rang;
	end function;

end aes_utils;