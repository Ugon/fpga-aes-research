library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_utils.all;
use work.aes_sub_bytes.all;

package aes_transformations is

	--input indexes are normal, not reversed like in NIST.

    /*    input/output array     */
	/* ------------------------- */
	/* | i15 | i11 | i7  | i3  | */
	/* ------------------------- */
	/* | i14 | i10 | i6  | i2  | */
	/* ------------------------- */
	/* | i13 | i9  | i5  | i1  | */
	/* ------------------------- */
	/* | i12 | i8  | i4  | i0  | */
	/* ------------------------- */
	
	/* | i15 | i14 | i13 | i12 | i11 | i10 | i9  | i8  | i7  | i6  | i5  | i4  | i3  | i2  | i1  | i0  | */


    --numbering compliant with NIST
	/*        state array        */
	/* ------------------------- */
	/* | s00 | s01 | s02 | s03 | */
	/* ------------------------- */
	/* | s10 | s11 | s12 | s13 | */
	/* ------------------------- */
	/* | s20 | s21 | s22 | s23 | */
	/* ------------------------- */
	/* | s30 | s31 | s32 | s33 | */
	/* ------------------------- */
	
	/* | s00 | s10 | s20 | s30 | s01 | s11 | s21 | s31 | s02 | s12 | s22 | s32 | s03 | s13 | s23 | s33 | */

	--indexing
	function l   (constant row: Integer; constant column: Integer) return Integer;
	function r   (constant row: Integer; constant column: Integer) return Integer;
	function idx (constant row: Integer; constant column: Integer) return std_logic_vector;

	--transformations
	function add_round_key (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector; constant round_number : Integer) return std_logic_vector;

	function shift_rows (constant state_in : std_logic_vector) return std_logic_vector;

	function mix_columns (constant state_in : std_logic_vector) return std_logic_vector;

	function round_0 (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector) return std_logic_vector;
	
	function round_n (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector; constant n : Integer) return std_logic_vector;

	function round_last (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector) return std_logic_vector;
	
	function encode256 (constant plaintext : std_logic_vector; constant key_expansion : std_logic_vector) return std_logic_vector;
	
	

end aes_transformations;

package body aes_transformations is

	
	function shift_rows (constant state_in : std_logic_vector) return std_logic_vector is
	 	variable state_out : std_logic_vector(127 downto 0);
	begin
		for r in 0 to 3 loop
			for c in 0 to 3 loop
				state_out(idx(r, c)'range) := state_in(idx(r, (c + r) mod 4)'range);
			end loop;
		end loop;
		
		return state_out;
	end function;


	function mix_columns (constant state_in : std_logic_vector) return std_logic_vector is
	 	variable state_out : std_logic_vector(127 downto 0);

		variable w0x1 : std_logic_vector(7 downto 0);
		variable w1x1 : std_logic_vector(7 downto 0);
		variable w2x1 : std_logic_vector(7 downto 0);
		variable w3x1 : std_logic_vector(7 downto 0);
		
		variable w0x2 : std_logic_vector(7 downto 0);
		variable w1x2 : std_logic_vector(7 downto 0);
		variable w2x2 : std_logic_vector(7 downto 0);
		variable w3x2 : std_logic_vector(7 downto 0);

		variable w0x3 : std_logic_vector(7 downto 0);
		variable w1x3 : std_logic_vector(7 downto 0);
		variable w2x3 : std_logic_vector(7 downto 0);
		variable w3x3 : std_logic_vector(7 downto 0);
	begin
		for c in 0 to 3 loop
			w0x1 := state_in(idx(0, c)'range);
			w1x1 := state_in(idx(1, c)'range);
			w2x1 := state_in(idx(2, c)'range);
			w3x1 := state_in(idx(3, c)'range);

			w0x2 := gf_mul2(w0x1);
			w1x2 := gf_mul2(w1x1);
			w2x2 := gf_mul2(w2x1);
			w3x2 := gf_mul2(w3x1);

			w0x3 := w0x1 xor w0x2;
			w1x3 := w1x1 xor w1x2;
			w2x3 := w2x1 xor w2x2;
			w3x3 := w3x1 xor w3x2;

			state_out(idx(0, c)'range) := w0x2 xor w1x3 xor w2x1 xor w3x1;
			state_out(idx(1, c)'range) := w0x1 xor w1x2 xor w2x3 xor w3x1;
			state_out(idx(2, c)'range) := w0x1 xor w1x1 xor w2x2 xor w3x3;
			state_out(idx(3, c)'range) := w0x3 xor w1x1 xor w2x1 xor w3x2;
		end loop;

		return state_out;
	end;


	function add_round_key (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector; constant round_number : Integer) return std_logic_vector is
		variable key_schedule: std_logic_vector(127 downto 0);
	 	variable state_out   : std_logic_vector(127 downto 0);
	begin
		key_schedule := key_expansion(128 * (round_number + 1) - 1 downto 128 * round_number);
		state_out := state_in xor reverse_byte_order(key_schedule);

		return state_out;
	end function;


	function round_0 (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector) return std_logic_vector is begin
		return add_round_key(state_in, key_expansion, 0);
	end function;


	function round_n (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector; constant n : Integer) return std_logic_vector is
		variable state : std_logic_vector(127 downto 0);
	begin
		state := state_in;
		state := sub_bytes_calc(state);
		state := shift_rows(state);
		state := mix_columns(state);
		state := add_round_key(state, key_expansion, n);

		return state;
	end function;


	function round_last (constant state_in : std_logic_vector; constant key_expansion : std_logic_vector) return std_logic_vector is
		variable state : std_logic_vector(127 downto 0);
	begin
		state := state_in;
		state := sub_bytes_calc(state);
		state := shift_rows(state);
		state := add_round_key(state, key_expansion, 14);

		return state;
	end function;


	function encode256 (constant plaintext : std_logic_vector; constant key_expansion : std_logic_vector) return std_logic_vector is
		variable state : std_logic_vector(127 downto 0);
	begin

		state := round_0(state, key_expansion);

		for i in 1 to 13 loop
			state := round_n(state, key_expansion, i);
		end loop;

		state := round_last(state, key_expansion);

		return state;
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


end aes_transformations;