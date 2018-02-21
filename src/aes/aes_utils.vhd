library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;

package aes_utils is
	
--	function key_expansion256 (constant key : std_logic_vector) return std_logic_vector;
    
	function reverse_byte_order (inp : std_logic_vector) return std_logic_vector;
	function reverse_bit_order (inp : std_logic_vector) return std_logic_vector;
	
	function and_with_bit (v : std_logic_vector; b : std_logic) return std_logic_vector;

	function idx (constant row: Integer; constant column: Integer) return std_logic_vector;

end aes_utils;

package body aes_utils is

	/*
	function key_expansion256 (constant key : std_logic_vector) return std_logic_vector is
		constant word_length : Integer := 4 * 8;
		constant byte_bits   : Integer := 8;
		constant Nk          : Integer := 8;

		variable tmp         : std_logic_vector(word_length - 1 downto 0);
		variable tmp2        : std_logic_vector(word_length - 1 downto 0);
		variable rcon        : std_logic_vector(word_length - 1 downto 0);
		variable result      : std_logic_vector(60 * word_length - 1 downto 0);
	begin
		result(word_length * Nk - 1 downto 0) := reverse_byte_order(key);
		for i in Nk to 59 loop
			tmp := result(word_length * i - 1 downto word_length * (i - 1));
			
			if (i mod Nk = 0) then
				--RotWord
				tmp2 := tmp;
				tmp(word_length - 1 downto word_length - byte_bits) := tmp2(byte_bits - 1 downto 0);
				tmp(word_length - byte_bits - 1 downto 0) := tmp2(word_length - 1 downto byte_bits);

				--SubWord
				for j in 0 to 3 loop
					tmp((j + 1) * byte_bits - 1 downto j * byte_bits) := sub_byte_calc(tmp((j + 1) * byte_bits - 1 downto j * byte_bits));
				end loop;

				--Rcon XOR
				tmp(byte_bits - 1 downto 0) := tmp(byte_bits - 1 downto 0) xor std_logic_vector(to_unsigned(2 ** (i / Nk - 1), byte_bits));

			elsif (i mod Nk = 4) then
				--SubWord
				for j in 0 to 3 loop
					tmp((j + 1) * byte_bits - 1 downto j * byte_bits) := sub_byte_calc(tmp((j + 1) * byte_bits - 1 downto j * byte_bits));
				end loop;

			end if;
			
			result(word_length * (i + 1) - 1 downto word_length * i) := 
				tmp xor result(word_length * (i - Nk + 1) - 1 downto word_length * (i - Nk));
		end loop;

		return result;
	end function;
	*/

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