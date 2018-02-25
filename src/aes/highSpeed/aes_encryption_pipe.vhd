library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_shift_rows.all;
use work.aes_sub_bytes.all;
use work.aes_mix_columns.all;

package aes_encryption_pipe is

	type asb_halfbytes is array (0 to 15) of std_logic_vector(3 downto 0);
	type asb_bytes     is array (0 to 15) of std_logic_vector(7 downto 0);
	type asb_elevens   is array (0 to 15) of std_logic_vector(10 downto 0);
	type asb_tens      is array (0 to 15) of std_logic_vector(9 downto 0);
	
	type aenc_pipe_1res is record
		elevens: asb_elevens;
	end record;

	type aenc_pipe_2res is record
		a: asb_halfbytes;
		b: asb_halfbytes;
		d: asb_halfbytes;
	end record;

	type aenc_pipe_3res is record
		a: asb_halfbytes;
		e: asb_halfbytes;
		d: asb_halfbytes;
		da: asb_bytes;
	end record;

	type aenc_pipe_4res is record
		a: asb_halfbytes;
		g: asb_halfbytes;
		d: asb_halfbytes;
	end record;

	type aenc_pipe_5res is record
		a: asb_halfbytes;
		d: asb_halfbytes;
		h: asb_halfbytes;
	end record;

	type aenc_pipe_6res is record
		i: asb_bytes;
		j: asb_bytes;
	end record;

	type aenc_pipe_7res is record
		i: asb_halfbytes;
		j: asb_halfbytes;
	end record;

	type aenc_pipe_8res is record
		delta_mul_inter: asb_bytes;
	end record;

	type aenc_pipe_9res is record
		state: std_logic_vector(127 downto 0);
	end record;

	type aenc_pipe_10res is record
		mix_inter: mix_colums_intermediate;
	end record;

	function aenc_pipe_stage1 (state_in: std_logic_vector) return aenc_pipe_1res;
    function aenc_pipe_stage2 (state_in: aenc_pipe_1res) return aenc_pipe_2res;
    function aenc_pipe_stage3 (state_in: aenc_pipe_2res) return aenc_pipe_3res;
    function aenc_pipe_stage4 (state_in: aenc_pipe_3res) return aenc_pipe_4res;
	function aenc_pipe_stage5 (state_in: aenc_pipe_4res) return aenc_pipe_5res;
	function aenc_pipe_stage6 (state_in: aenc_pipe_5res) return aenc_pipe_6res;
	function aenc_pipe_stage7 (state_in: aenc_pipe_6res) return aenc_pipe_7res;
	function aenc_pipe_stage8 (state_in: aenc_pipe_7res) return aenc_pipe_8res;
	function aenc_pipe_stage9 (state_in: aenc_pipe_8res) return aenc_pipe_9res;
	function aenc_pipe_stage10 (state_in: aenc_pipe_9res) return aenc_pipe_10res;
	function aenc_pipe_stage11 (state_in: aenc_pipe_10res; round_key: std_logic_vector) return std_logic_vector;
	function aenc_pipe_stage10_last (state_in: aenc_pipe_9res; round_key: std_logic_vector) return std_logic_vector;

end aes_encryption_pipe;

package body aes_encryption_pipe is

	function aenc_pipe_stage1 (state_in: std_logic_vector) return aenc_pipe_1res is
		variable inp: std_logic_vector(7 downto 0);
		variable inp_h: std_logic_vector(3 downto 0);
		variable inp_l: std_logic_vector(3 downto 0);
		variable result: aenc_pipe_1res;
	begin
		for i in 0 to 15 loop
			result.elevens(i) := mul_delta_8a(state_in((i + 1) * 8 - 1 downto i * 8));
		end loop;
		return result;
	end function;


	function aenc_pipe_stage2 (state_in: aenc_pipe_1res) return aenc_pipe_2res is
		variable inp: std_logic_vector(7 downto 0);
		variable inp_h: std_logic_vector(3 downto 0);
		variable inp_l: std_logic_vector(3 downto 0);
		variable result: aenc_pipe_2res;
	begin
		for i in 0 to 15 loop
			inp := mul_delta_8b(state_in.elevens(i));
			inp_h := inp(7 downto 4);
			inp_l := inp(3 downto 0);
			result.a(i) := inp_h;
			result.b(i) := inp_l;
			result.d(i) := mul_delta_8b_xored(state_in.elevens(i));
		end loop;
		return result;
	end function;


	function aenc_pipe_stage3 (state_in: aenc_pipe_2res) return aenc_pipe_3res is
		variable c: std_logic_vector(3 downto 0);
		variable result: aenc_pipe_3res;
	begin
		for i in 0 to 15 loop
			c := sq_4(state_in.a(i));

			result.a(i)  := state_in.a(i);
			result.d(i)  := state_in.d(i);
			result.e(i)  := mul_lam_4(c);
			result.da(i) := mul_4a(state_in.b(i), state_in.d(i));
		end loop;
		return result;
	end function;


	function aenc_pipe_stage4 (state_in: aenc_pipe_3res) return aenc_pipe_4res is
		variable f: std_logic_vector(3 downto 0);
		variable result: aenc_pipe_4res;
	begin
		for i in 0 to 15 loop
			f := mul_4b(state_in.da(i));

			result.a(i) := state_in.a(i);
			result.d(i) := state_in.d(i);
			result.g(i) := state_in.e(i) xor f;
		end loop;
		return result;
	end function;


	function aenc_pipe_stage5 (state_in: aenc_pipe_4res) return aenc_pipe_5res is
		variable result: aenc_pipe_5res;
	begin
		for i in 0 to 15 loop
			result.a(i) := state_in.a(i);
			result.d(i) := state_in.d(i);
			result.h(i) := inv_4(state_in.g(i));
		end loop;
		return result;
	end function;

	function aenc_pipe_stage6 (state_in: aenc_pipe_5res) return aenc_pipe_6res is
		variable result: aenc_pipe_6res;
	begin
		for x in 0 to 15 loop
			result.i(x) := mul_4a(state_in.a(x), state_in.h(x));
			result.j(x) := mul_4a(state_in.d(x), state_in.h(x));
		end loop;
		return result;
	end function;


	function aenc_pipe_stage7 (state_in: aenc_pipe_6res) return aenc_pipe_7res is
		variable result: aenc_pipe_7res;
	begin
		for x in 0 to 15 loop
			result.i(x) := mul_4b(state_in.i(x));
			result.j(x) := mul_4b(state_in.j(x));
		end loop;
		return result;
	end function;


	function aenc_pipe_stage8 (state_in: aenc_pipe_7res) return aenc_pipe_8res is
		variable bte   : std_logic_vector(7 downto 0);
		variable state_buf: std_logic_vector(127 downto 0);
		variable result: aenc_pipe_8res;
	begin
		for x in 0 to 15 loop
			bte(7 downto 4) := state_in.i(x);
			bte(3 downto 0) := state_in.j(x);
			result.delta_mul_inter(x) := mul_deltainv_affine_8a(bte);
		end loop;
		return result;
	end function;


	function aenc_pipe_stage9 (state_in: aenc_pipe_8res) return aenc_pipe_9res is
		variable bte   : std_logic_vector(7 downto 0);
		variable state_buf: std_logic_vector(127 downto 0);
		variable result: aenc_pipe_9res;
	begin
		for x in 0 to 15 loop
			state_buf((x + 1) * 8 - 1 downto x * 8) := mul_deltainv_affine_8b(state_in.delta_mul_inter(x));
		end loop;
		result.state := shift_rows(state_buf);
		return result;
	end function;


	function aenc_pipe_stage10 (state_in: aenc_pipe_9res) return aenc_pipe_10res is
		variable result: aenc_pipe_10res;
	begin
		result.mix_inter := mix_columns_a(state_in.state);	
		return result;
	end function;


	function aenc_pipe_stage11 (state_in: aenc_pipe_10res; round_key: std_logic_vector) return std_logic_vector is
	begin
		return mix_columns_b(state_in.mix_inter) xor round_key;	
	end function;


	function aenc_pipe_stage10_last (state_in: aenc_pipe_9res; round_key: std_logic_vector) return std_logic_vector is
	begin
		return state_in.state xor round_key;	
	end function;
	
end aes_encryption_pipe;