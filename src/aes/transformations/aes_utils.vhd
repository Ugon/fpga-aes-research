library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;

package aes_utils is
	 
	function reverse_byte_order (inp : std_logic_vector) return std_logic_vector;
	function reverse_bit_order (inp : std_logic_vector) return std_logic_vector;
	
	function and_with_bit (v : std_logic_vector; b : std_logic) return std_logic_vector;

	function idx (constant row: Integer; constant column: Integer) return std_logic_vector;

end aes_utils;

package body aes_utils is

	function reverse_byte_order(signal inp : std_logic_vector) return std_logic_vector is
		constant byte_bits : Integer := 8;	
		constant inp_bytes : Integer := inp'length / byte_bits;
		
		variable result : std_logic_vector(inp'range);
	begin
		for i in 0 to inp_bytes - 1 loop
			result((inp_bytes - i) * byte_bits - 1 downto (inp_bytes - i - 1) * byte_bits) := inp((i + 1) * byte_bits - 1 downto i * byte_bits);
		end loop;

		return result;
	end function;


	function reverse_bit_order(signal inp : std_logic_vector) return std_logic_vector is
		variable result : std_logic_vector(inp'range);
	begin
		for i in inp'range loop
			result(inp'length - i - 1) := inp(i);
		end loop;

		return result;
	end function;

	function and_with_bit (v : std_logic_vector; b : std_logic) return std_logic_vector is
		variable b_expanded : std_logic_vector(v'range) := (others => b);
	begin
		return v and b_expanded;
	end function;


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