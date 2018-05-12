library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;

package hsroll_aes_key_expansion_pipe is

	type hsroll_ake_halfbytes is array (0 to 3) of std_logic_vector(3 downto 0);
	type hsroll_ake_bytes     is array (0 to 3) of std_logic_vector(7 downto 0);
	type hsroll_ake_nines     is array (0 to 3) of std_logic_vector(8 downto 0);
	type hsroll_ake_elevens   is array (0 to 3) of std_logic_vector(10 downto 0);
	
	type hsroll_ake_pipe_1res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);

		w8_init: std_logic_vector(31 downto 0);	
		w1: std_logic_vector(31 downto 0);
		w2: std_logic_vector(31 downto 0);
		w3: std_logic_vector(31 downto 0);
		
		w7_elevens: hsroll_ake_elevens;
	end record;

	type hsroll_ake_pipe_2res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w2: std_logic_vector(31 downto 0);
		w3: std_logic_vector(31 downto 0);
		
		w7_a: hsroll_ake_halfbytes;
		w7_b: hsroll_ake_halfbytes;
		w7_d: hsroll_ake_halfbytes;
	end record;

	type hsroll_ake_pipe_3res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w3: std_logic_vector(31 downto 0);
		
		w7_a: hsroll_ake_halfbytes;
		w7_e: hsroll_ake_halfbytes;
		w7_d: hsroll_ake_halfbytes;
		w7_da: hsroll_ake_bytes;
	end record;

	type hsroll_ake_pipe_4res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w11_init: std_logic_vector(31 downto 0);
		
		w7_a: hsroll_ake_halfbytes;
		w7_d: hsroll_ake_halfbytes;
		w7_g: hsroll_ake_halfbytes;
	end record;

	type hsroll_ake_pipe_5res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w11_init: std_logic_vector(31 downto 0);
		
		w7_a: hsroll_ake_halfbytes;
		w7_d: hsroll_ake_halfbytes;
		w7_h: hsroll_ake_halfbytes;
	end record;

	type hsroll_ake_pipe_6res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w11_init: std_logic_vector(31 downto 0);
		
		w7_i: hsroll_ake_bytes;
		w7_j: hsroll_ake_bytes;
	end record;

	type hsroll_ake_pipe_7res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w11_init: std_logic_vector(31 downto 0);
		
		w7_i: hsroll_ake_halfbytes;
		w7_j: hsroll_ake_halfbytes;
	end record;

	type hsroll_ake_pipe_8res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w11_init: std_logic_vector(31 downto 0);
		
		w7_delta_mul_inter: hsroll_ake_nines;
	end record;

	type hsroll_ake_pipe_9res is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		next_key: std_logic_vector(127 downto 0);
	end record;

	type hsroll_ake_pipe_result is record
		prev_key: std_logic_vector(127 downto 0);
		current_key: std_logic_vector(127 downto 0);
		next_key: std_logic_vector(127 downto 0);
	end record;

	function hsroll_ake_pipe_stage1 (
		prev_key    : std_logic_vector(127 downto 0);
		current_key : std_logic_vector(127 downto 0);
		rot_word    : std_logic) return hsroll_ake_pipe_1res;

	function hsroll_ake_pipe_stage2 (
		state_in : hsroll_ake_pipe_1res) return hsroll_ake_pipe_2res;

    function hsroll_ake_pipe_stage3 (
    	state_in : hsroll_ake_pipe_2res) return hsroll_ake_pipe_3res;

	function hsroll_ake_pipe_stage4 (
		state_in : hsroll_ake_pipe_3res) return hsroll_ake_pipe_4res;

	function hsroll_ake_pipe_stage5 (
		state_in : hsroll_ake_pipe_4res) return hsroll_ake_pipe_5res;

	function hsroll_ake_pipe_stage6 (
		state_in : hsroll_ake_pipe_5res) return hsroll_ake_pipe_6res;

	function hsroll_ake_pipe_stage7 (
		state_in : hsroll_ake_pipe_6res) return hsroll_ake_pipe_7res;

	function hsroll_ake_pipe_stage8 (
		state_in : hsroll_ake_pipe_7res) return hsroll_ake_pipe_8res;

	function hsroll_ake_pipe_stage9 (
		state_in : hsroll_ake_pipe_8res; 
		rcon     : std_logic_vector) return hsroll_ake_pipe_9res;

	function hsroll_ake_pipe_stage10 (state_in : hsroll_ake_pipe_9res) return hsroll_ake_pipe_result;


end hsroll_aes_key_expansion_pipe;

package body hsroll_aes_key_expansion_pipe is

	function hsroll_ake_pipe_stage1 (
		prev_key    : std_logic_vector(127 downto 0);
		current_key : std_logic_vector(127 downto 0);
		rot_word    : std_logic
	) return hsroll_ake_pipe_1res is
		variable w7    : std_logic_vector(31 downto 0);
		variable w7_rot: std_logic_vector(31 downto 0);
		variable inp   : std_logic_vector(7 downto 0);
		variable inp_h : std_logic_vector(3 downto 0);
		variable inp_l : std_logic_vector(3 downto 0);
		variable result: hsroll_ake_pipe_1res;
	begin
		result.current_key := current_key;
		result.prev_key    := prev_key;

		result.w8_init := prev_key(127 downto 96);
		result.w1      := prev_key(95 downto 64);
		result.w2      := prev_key(63 downto 32);
		result.w3      := prev_key(31 downto 0);
		
		w7 := current_key(31 downto 0);

		if (rot_word = '1') then
			w7_rot(31 downto 8) := w7(23 downto 0);
			w7_rot(7 downto 0) := w7(31 downto 24);
		else 
			w7_rot := w7;
		end if;

		for i in 0 to 3 loop
			result.w7_elevens(i) := mul_delta_8a(w7_rot((i + 1) * 8 - 1 downto i * 8));
		end loop;
		return result;
	end function;


	function hsroll_ake_pipe_stage2 (
    	state_in             : hsroll_ake_pipe_1res
	) return hsroll_ake_pipe_2res is
		variable w7    : std_logic_vector(31 downto 0);
		variable w7_rot: std_logic_vector(31 downto 0);
		variable inp   : std_logic_vector(7 downto 0);
		variable inp_h : std_logic_vector(3 downto 0);
		variable inp_l : std_logic_vector(3 downto 0);
		variable result: hsroll_ake_pipe_2res;
	begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;

		result.w8_init := state_in.w8_init;
		result.w9_init := state_in.w1 xor state_in.w8_init;
		result.w2      := state_in.w2;
		result.w3      := state_in.w3;
		
		for i in 0 to 3 loop
			inp := mul_delta_8b(state_in.w7_elevens(i));
			inp_h := inp(7 downto 4);
			inp_l := inp(3 downto 0);
			result.w7_a(i) := inp_h;
			result.w7_b(i) := inp_l;
			result.w7_d(i) := mul_delta_8b_xored(state_in.w7_elevens(i));
		end loop;
		return result;
	end function;


    function hsroll_ake_pipe_stage3 (
    	state_in             : hsroll_ake_pipe_2res
    ) return hsroll_ake_pipe_3res is
    	variable c: std_logic_vector(3 downto 0);
		variable result: hsroll_ake_pipe_3res;
    begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;

		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w2 xor state_in.w9_init;
		result.w3       := state_in.w3;
		
		for i in 0 to 3 loop
			c := sq_4(state_in.w7_a(i));
			result.w7_a(i) := state_in.w7_a(i);
			result.w7_d(i) := state_in.w7_d(i);
			result.w7_e(i) := mul_lam_4(c);
			result.w7_da(i) := mul_4a(state_in.w7_b(i), state_in.w7_d(i));
		end loop;
		return result;
    end function;


	function hsroll_ake_pipe_stage4 (
    	state_in             : hsroll_ake_pipe_3res
    ) return hsroll_ake_pipe_4res is
		variable f: std_logic_vector(3 downto 0);
		variable result: hsroll_ake_pipe_4res;
    begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;

		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w10_init;
		result.w11_init := state_in.w3 xor state_in.w10_init;
		
		for i in 0 to 3 loop
			f := mul_4b(state_in.w7_da(i));
			result.w7_a(i) := state_in.w7_a(i);
			result.w7_d(i) := state_in.w7_d(i);
			result.w7_g(i) := state_in.w7_e(i) xor f;
		end loop;
		return result;
    end function;


	function hsroll_ake_pipe_stage5 (
		state_in             : hsroll_ake_pipe_4res
	) return hsroll_ake_pipe_5res is
		variable result: hsroll_ake_pipe_5res;
	begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;
		
		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w10_init;
		result.w11_init := state_in.w11_init;

		for i in 0 to 3 loop
			result.w7_a(i) := state_in.w7_a(i);
			result.w7_d(i) := state_in.w7_d(i);
			result.w7_h(i) := inv_4(state_in.w7_g(i));
		end loop;
		return result;
	end function;


	function hsroll_ake_pipe_stage6 (
		state_in             : hsroll_ake_pipe_5res
	) return hsroll_ake_pipe_6res is
		variable result: hsroll_ake_pipe_6res;
	begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;

		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w10_init;
		result.w11_init := state_in.w11_init;

		for i in 0 to 3 loop
			result.w7_i(i) := mul_4a(state_in.w7_a(i), state_in.w7_h(i));
			result.w7_j(i) := mul_4a(state_in.w7_d(i), state_in.w7_h(i));
		end loop;
		return result;
	end function;


	function hsroll_ake_pipe_stage7 (
		state_in             : hsroll_ake_pipe_6res
	) return hsroll_ake_pipe_7res is
		variable result: hsroll_ake_pipe_7res;
	begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;

		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w10_init;
		result.w11_init := state_in.w11_init;

		for i in 0 to 3 loop
			result.w7_i(i) := mul_4b(state_in.w7_i(i));
			result.w7_j(i) := mul_4b(state_in.w7_j(i));
		end loop;
		return result;
	end function;

	function hsroll_ake_pipe_stage8 (
		state_in             : hsroll_ake_pipe_7res
	) return hsroll_ake_pipe_8res is
		variable bte   : std_logic_vector(7 downto 0);
		variable result: hsroll_ake_pipe_8res;
	begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;
		
		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w10_init;
		result.w11_init := state_in.w11_init;

		for i in 0 to 3 loop
			bte(7 downto 4) := state_in.w7_i(i);
			bte(3 downto 0) := state_in.w7_j(i);
			result.w7_delta_mul_inter(i) := mul_deltainv_affine_8a(bte);
		end loop;

		return result;
	end function;

	function hsroll_ake_pipe_stage9 (
		state_in             : hsroll_ake_pipe_8res;
		rcon                 : std_logic_vector
	) return hsroll_ake_pipe_9res is
		variable bte   : std_logic_vector(7 downto 0);
		variable w7_sub: std_logic_vector(31 downto 0);
		variable w7_rcon: std_logic_vector(31 downto 0);

		variable w8: std_logic_vector(31 downto 0);
		variable w9: std_logic_vector(31 downto 0);
		variable w10: std_logic_vector(31 downto 0);
		variable w11: std_logic_vector(31 downto 0);
		
		variable result: hsroll_ake_pipe_9res;
	begin
		result.current_key    := state_in.current_key;
		result.prev_key := state_in.prev_key;
		
		for i in 0 to 3 loop
			w7_sub((i + 1) * 8 - 1 downto i * 8) := mul_deltainv_affine_8b(state_in.w7_delta_mul_inter(i));
		end loop;

		w7_rcon := w7_sub;
		w7_rcon(31 downto 24) := w7_rcon(31 downto 24) xor rcon;

		w8  := state_in.w8_init  xor w7_rcon;
		w9  := state_in.w9_init  xor w7_rcon;
		w10 := state_in.w10_init xor w7_rcon;
		w11 := state_in.w11_init xor w7_rcon;

		result.next_key(127 downto 96) := w8;
		result.next_key(95 downto 64)  := w9;
		result.next_key(63 downto 32)  := w10;
		result.next_key(31 downto 0)   := w11;

		return result;
	end function;

	function hsroll_ake_pipe_stage10 (
		state_in             : hsroll_ake_pipe_9res
	) return hsroll_ake_pipe_result is
		variable result: hsroll_ake_pipe_result;
	begin
		result.current_key      := state_in.current_key;
		result.prev_key   := state_in.prev_key;
		result.next_key := state_in.next_key;
		return result;
	end function;

end hsroll_aes_key_expansion_pipe;