library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;

package aes_utils is
	
	--function multiply (constant left : std_logic_vector(7 downto 0); constant right : std_logic_vector(7 downto 0)) return std_logic_vector;

	--function gf_mul2 (constant a : std_logic_vector(7 downto 0)) return std_logic_vector;

	--function gf_mul3 (constant a : std_logic_vector(7 downto 0)) return std_logic_vector;

    -- order of key bytes      | k31 | ... | k1  | k0  | --normal order - reversed from NIST
    -- order of words          | w59 | ... | w1  | w0  | --numbering compliant with NIST
	-- order of bytes in word  | b3  | b2  | b1  | b0  | 
	function key_expansion256 (constant key : std_logic_vector) return std_logic_vector;
    
	function reverse_byte_order (inp : std_logic_vector) return std_logic_vector;
	function reverse_bit_order (inp : std_logic_vector) return std_logic_vector;
	
	function and_with_bit (v : std_logic_vector; b : std_logic) return std_logic_vector;

	function idx (constant row: Integer; constant column: Integer) return std_logic_vector;


end aes_utils;

package body aes_utils is
/*
	function multiply (constant left : std_logic_vector(7 downto 0); constant right : std_logic_vector(7 downto 0)) return std_logic_vector is
		constant irred_poly       : std_logic_vector(7 downto 0) := x"1b";
		variable a                : std_logic_vector(7 downto 0) := (others => '0');
		variable b                : std_logic_vector(7 downto 0) := (others => '0');
		variable p                : std_logic_vector(7 downto 0) := (others => '0');
		variable extended_b_lsb   : std_logic_vector(7 downto 0) := (others => '0');
		variable extended_a_carry : std_logic_vector(7 downto 0) := (others => '0');
	begin
		a := left;
		b := right;
		p := (others => '0');

		for i in 0 to 7 loop
			--1
			extended_b_lsb := (others => b(0));
			p := p xor (extended_b_lsb and a);

			--2
			b := '0' & b(7 downto 1);

			--3
			extended_a_carry := (others => a(7));

			--4
			a := a(6 downto 0) & '0';

			--5
			a := a xor (extended_a_carry and irred_poly);
		end loop;
		
		return p;
	end function;

	function gf_mul2 (constant a : std_logic_vector(7 downto 0)) return std_logic_vector is
		variable b : std_logic_vector(7 downto 0);
	begin
		b(0) := a(7);
		b(1) := a(0) xor a(7);
		b(2) := a(1);
		b(3) := a(2) xor a(7);
		b(4) := a(3) xor a(7);
		b(5) := a(4);
		b(6) := a(5);
		b(7) := a(6);

		return b;
	end function;

	function gf_mul3 (constant a : std_logic_vector(7 downto 0)) return std_logic_vector is
		variable b : std_logic_vector(7 downto 0);
	begin
		b(0) := b(0) xor a(7);
		b(1) := b(1) xor a(0) xor a(7);
		b(2) := b(2) xor a(1);
		b(3) := b(3) xor a(2) xor a(7);
		b(4) := b(4) xor a(3) xor a(7);
		b(5) := b(5) xor a(4);
		b(6) := b(6) xor a(5);
		b(7) := b(7) xor a(6);

		return b;
	end function;
*/
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