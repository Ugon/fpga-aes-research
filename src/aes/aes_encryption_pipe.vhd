library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;
use work.aes_mix_columns.all;
use work.aes_transformations.all;

package aes_encryption_pipe is

	type asb_halfbytes is array (0 to 15) of std_logic_vector(3 downto 0);
	
	type aenc_pipe_1res is record
		a: asb_halfbytes;
		b: asb_halfbytes;
		d: asb_halfbytes;
	end record;

	type aenc_pipe_2res is record
		a: asb_halfbytes;
		d: asb_halfbytes;
		g: asb_halfbytes;
	end record;

	type aenc_pipe_3res is record
		a: asb_halfbytes;
		d: asb_halfbytes;
		h: asb_halfbytes;
	end record;

	type aenc_pipe_4res is record
		i: asb_halfbytes;
		j: asb_halfbytes;
	end record;

	type aenc_pipe_5res is record
		state: std_logic_vector(127 downto 0);
	end record;

	type aenc_pipe_test_res is record
		state: std_logic_vector(127 downto 0);
	end record;


	function aenc_pipe_stage1 (state_in: std_logic_vector) return aenc_pipe_1res;
    function aenc_pipe_stage2 (state_in: aenc_pipe_1res) return aenc_pipe_2res;
	function aenc_pipe_stage3 (state_in: aenc_pipe_2res) return aenc_pipe_3res;
	function aenc_pipe_stage4 (state_in: aenc_pipe_3res) return aenc_pipe_4res;

	function aenc_pipe_stage5 (state_in: aenc_pipe_4res) return aenc_pipe_5res;

	--function aenc_pipe_stage_test (state_in: aenc_pipe_5res) return aenc_pipe_test_res;
	
	function aenc_pipe_stage6 (state_in: aenc_pipe_5res) return std_logic_vector;

end aes_encryption_pipe;

package body aes_encryption_pipe is

	function aenc_pipe_stage1 (state_in: std_logic_vector) return aenc_pipe_1res is
		variable inp: std_logic_vector(7 downto 0);
		variable inp_h: std_logic_vector(3 downto 0);
		variable inp_l: std_logic_vector(3 downto 0);
		variable result: aenc_pipe_1res;
	begin
		for i in 0 to 15 loop
			inp := mul_delta_8(state_in((i + 1) * 8 - 1 downto i * 8));
			inp_h := inp(7 downto 4);
			inp_l := inp(3 downto 0);
			result.a(i) := inp_h;
			result.b(i) := inp_l;
			result.d(i) := inp_h xor inp_l;
		end loop;
		return result;
	end function;


	function aenc_pipe_stage2 (state_in: aenc_pipe_1res) return aenc_pipe_2res is
		variable c: std_logic_vector(3 downto 0);
		variable e: std_logic_vector(3 downto 0);
		variable f: std_logic_vector(3 downto 0);
		variable result: aenc_pipe_2res;
	begin
		for i in 0 to 15 loop
			c := sq_4(state_in.a(i));
			e := mul_lam_4(c);
			f := mul_4(state_in.b(i), state_in.d(i));
			result.a(i) := state_in.a(i);
			result.d(i) := state_in.d(i);
			result.g(i) := e xor f;
		end loop;
		return result;
	end function;


	function aenc_pipe_stage3 (state_in: aenc_pipe_2res) return aenc_pipe_3res is
		variable result: aenc_pipe_3res;
	begin
		for i in 0 to 15 loop
			result.a(i) := state_in.a(i);
			result.d(i) := state_in.d(i);
			result.h(i) := inv_4(state_in.g(i));
		end loop;
		return result;
	end function;


	function aenc_pipe_stage4 (state_in: aenc_pipe_3res) return aenc_pipe_4res is
		variable result: aenc_pipe_4res;
	begin
		for x in 0 to 15 loop
			result.i(x) := mul_4(state_in.a(x), state_in.h(x));
			result.j(x) := mul_4(state_in.d(x), state_in.h(x));
		end loop;
		return result;
	end function;


	function aenc_pipe_stage5 (state_in: aenc_pipe_4res) return aenc_pipe_5res is
		variable bte   : std_logic_vector(7 downto 0);
		variable state_buf: std_logic_vector(127 downto 0);
		variable result: aenc_pipe_5res;
	begin
		for x in 0 to 15 loop
			bte(7 downto 4) := state_in.i(x);
			bte(3 downto 0) := state_in.j(x);
			state_buf((x + 1) * 8 - 1 downto x * 8) := mul_deltainv_affine_8(bte);
		end loop;
		result.state := shift_rows(state_buf);
		--result.state := state_buf;
		return result;
	end function;

	--function aenc_pipe_stage_test (state_in: aenc_pipe_5res) return aenc_pipe_test_res is
		--variable result: aenc_pipe_test_res;
	--begin
		--result.state := mix_columns(state_in.state);
		--result.state := state_in.state;
		--return result;	
	--end function;

	function aenc_pipe_stage6 (state_in: aenc_pipe_5res) return std_logic_vector is
	begin
		return mix_columns(state_in.state);-- xor round_key;	
		--return state_in.state xor round_key;	
	end function;
	
end aes_encryption_pipe;