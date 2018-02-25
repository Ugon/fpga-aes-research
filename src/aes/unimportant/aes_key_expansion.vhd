library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;

package aes_key_expansion is
/*	function rot_words(key_in: std_logic_vector) return std_logic_vector;
	function rcon(key_in: std_logic_vector, round_number: Integer range 1 to 15) return std_logic_vector;
*/
	procedure expand_round_rsr(
		signal current_key            : in  std_logic_vector(127 downto 0);
		signal next_key               : in  std_logic_vector(127 downto 0);
		signal next_next_key          : out std_logic_vector(127 downto 0);
		constant next_next_round_numer: in  Integer range 3 to 15
	);

	procedure expand_round_s(
		signal current_key  : in  std_logic_vector(127 downto 0);
		signal next_key     : in  std_logic_vector(127 downto 0);
		signal next_next_key: out std_logic_vector(127 downto 0)
	);

end aes_key_expansion;

package body aes_key_expansion is
/*
	function rot_words(key_in: std_logic_vector) return std_logic_vector is
		constant w0: std_logic_vector(31 downto 0) := key_in(127 downto 96);
		constant w1: std_logic_vector(31 downto 0) := key_in(95 downto 64);
		constant w2: std_logic_vector(31 downto 0) := key_in(63 downto 32);
		constant w3: std_logic_vector(31 downto 0) := key_in(31 downto 0);

		variable w7:     std_logic_vector(31 downto 0);
		variable w7_rot: std_logic_vector(31 downto 0);
	begin

		w7_rot(31 downto 8) := w7(23 downto 0);
		w7_rot(7 downto 0) := w7(31 downto 24);
	end function;


	function rcon(key_in: std_logic_vector, round_number: Integer range 1 to 15) return std_logic_vector is
	begin

	end function;
*/

	procedure expand_round_rsr(
		signal current_key             : in  std_logic_vector(127 downto 0);
		signal next_key                : in  std_logic_vector(127 downto 0);
		signal next_next_key           : out std_logic_vector(127 downto 0);
		constant next_next_round_numer : in  Integer range 3 to 15
	) is
		constant w0: std_logic_vector(31 downto 0) := current_key(127 downto 96);
		constant w1: std_logic_vector(31 downto 0) := current_key(95 downto 64);
		constant w2: std_logic_vector(31 downto 0) := current_key(63 downto 32);
		constant w3: std_logic_vector(31 downto 0) := current_key(31 downto 0);

		constant w7: std_logic_vector(31 downto 0) := next_key(31 downto 0);
		
		variable w7_rot:  std_logic_vector(31 downto 0);
		variable w7_sub:  std_logic_vector(31 downto 0);
		variable w7_rcon: std_logic_vector(31 downto 0);

		variable w8: std_logic_vector(31 downto 0);
		variable w9: std_logic_vector(31 downto 0);
		variable w10: std_logic_vector(31 downto 0);
		variable w11: std_logic_vector(31 downto 0);
	
	begin
		--RotWord
		w7_rot(31 downto 8) := w7(23 downto 0);
		w7_rot(7 downto 0) := w7(31 downto 24);

		--SubWord
		for i in 0 to 3 loop
			w7_sub(8 * (i + 1) - 1 downto 8 * i) := sub_byte_calc(w7_rot(8 * (i + 1) - 1 downto 8 * i));
		end loop;

		--Rcon XOR
		w7_rcon(31 downto 24) := w7_sub(31 downto 24) xor std_logic_vector(to_unsigned(2 ** (next_next_round_numer / 2 - 1), 8));
		w7_rcon(23 downto 0) := w7_sub(23 downto 0);

		w8  := w0 xor w7_rcon;
		w9  := w1 xor w8;
		w10 := w2 xor w9;
		w11 := w3 xor w10;

		next_next_key(127 downto 96) <= w8;
		next_next_key(95 downto 64)  <= w9;
		next_next_key(63 downto 32)  <= w10;
		next_next_key(31 downto 0)   <= w11;
	end procedure;


	procedure expand_round_s(
		signal current_key             : in  std_logic_vector(127 downto 0);
		signal next_key                : in  std_logic_vector(127 downto 0);
		signal next_next_key           : out std_logic_vector(127 downto 0)
	) is
		constant w0: std_logic_vector(31 downto 0) := current_key(127 downto 96);
		constant w1: std_logic_vector(31 downto 0) := current_key(95 downto 64);
		constant w2: std_logic_vector(31 downto 0) := current_key(63 downto 32);
		constant w3: std_logic_vector(31 downto 0) := current_key(31 downto 0);

		constant w7: std_logic_vector(31 downto 0) := next_key(31 downto 0);
		
		variable w7_sub:  std_logic_vector(31 downto 0);

		variable w8: std_logic_vector(31 downto 0);
		variable w9: std_logic_vector(31 downto 0);
		variable w10: std_logic_vector(31 downto 0);
		variable w11: std_logic_vector(31 downto 0);
	
	begin
		--SubWord
		for i in 0 to 3 loop
			w7_sub(8 * (i + 1) - 1 downto 8 * i) := sub_byte_calc(w7(8 * (i + 1) - 1 downto 8 * i));
		end loop;

		w8  := w0 xor w7_sub;
		w9  := w1 xor w8;
		w10 := w2 xor w9;
		w11 := w3 xor w10;

		next_next_key(127 downto 96) <= w8;
		next_next_key(95 downto 64)  <= w9;
		next_next_key(63 downto 32)  <= w10;
		next_next_key(31 downto 0)   <= w11;
	end procedure;
end aes_key_expansion;