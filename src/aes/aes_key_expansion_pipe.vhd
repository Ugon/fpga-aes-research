library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;

package aes_key_expansion_pipe is

	type ake_halfbytes is array (0 to 3) of std_logic_vector(3 downto 0);
	
	type ake_pipe_1res is record
		current_key: std_logic_vector(127 downto 0);
		next_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);	
		w1: std_logic_vector(31 downto 0);
		w2: std_logic_vector(31 downto 0);
		w3: std_logic_vector(31 downto 0);
		
		w7_a: ake_halfbytes;
		w7_b: ake_halfbytes;
		w7_d: ake_halfbytes;
	end record;

	type ake_pipe_2res is record
		current_key: std_logic_vector(127 downto 0);
		next_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w2: std_logic_vector(31 downto 0);
		w3: std_logic_vector(31 downto 0);
		
		w7_a: ake_halfbytes;
		w7_d: ake_halfbytes;
		w7_g: ake_halfbytes;
	end record;

	type ake_pipe_3res is record
		current_key: std_logic_vector(127 downto 0);
		next_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w3: std_logic_vector(31 downto 0);
		
		w7_a: ake_halfbytes;
		w7_d: ake_halfbytes;
		w7_h: ake_halfbytes;
	end record;

	type ake_pipe_4res is record
		current_key: std_logic_vector(127 downto 0);
		next_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w11_init: std_logic_vector(31 downto 0);
		
		w7_i: ake_halfbytes;
		w7_j: ake_halfbytes;
	end record;

	type ake_pipe_5res is record
		current_key: std_logic_vector(127 downto 0);
		next_key: std_logic_vector(127 downto 0);
		w8_init: std_logic_vector(31 downto 0);
		w9_init: std_logic_vector(31 downto 0);
		w10_init: std_logic_vector(31 downto 0);
		w11_init: std_logic_vector(31 downto 0);
		
		w7_done: std_logic_vector(31 downto 0);
	end record;

	type ake_pipe_6res is record
		current_key  : std_logic_vector(127 downto 0);
		next_key     : std_logic_vector(127 downto 0);
		next_next_key: std_logic_vector(127 downto 0);
	end record;

	function ake_pipe_stage1 (
		current_key          : std_logic_vector(127 downto 0);
		next_key             : std_logic_vector(127 downto 0);
		next_next_round_numer: Integer range 3 to 15) return ake_pipe_1res;

    function ake_pipe_stage2 (
    	state_in             : ake_pipe_1res;
    	next_next_round_numer: Integer range 3 to 15) return ake_pipe_2res;

	function ake_pipe_stage3 (
		state_in             : ake_pipe_2res;    
		next_next_round_numer: Integer range 3 to 15) return ake_pipe_3res;

	function ake_pipe_stage4 (
		state_in             : ake_pipe_3res;    
		next_next_round_numer: Integer range 3 to 15) return ake_pipe_4res;

	function ake_pipe_stage5 (
		state_in             : ake_pipe_4res;    
		next_next_round_numer: Integer range 3 to 15) return ake_pipe_5res;

	function ake_pipe_stage6 (
		state_in             : ake_pipe_5res;    
		next_next_round_numer: Integer range 3 to 15) return ake_pipe_6res;


end aes_key_expansion_pipe;

package body aes_key_expansion_pipe is

	function ake_pipe_stage1 (
		current_key          : std_logic_vector(127 downto 0);
		next_key             : std_logic_vector(127 downto 0);
		next_next_round_numer: Integer range 3 to 15
	) return ake_pipe_1res is
		variable w7    : std_logic_vector(31 downto 0);
		variable w7_rot: std_logic_vector(31 downto 0);
		variable inp   : std_logic_vector(7 downto 0);
		variable inp_h : std_logic_vector(3 downto 0);
		variable inp_l : std_logic_vector(3 downto 0);
		variable result: ake_pipe_1res;
	begin
		result.next_key    := next_key;
		result.current_key := current_key;

		result.w8_init := current_key(127 downto 96);
		result.w1      := current_key(95 downto 64);
		result.w2      := current_key(63 downto 32);
		result.w3      := current_key(31 downto 0);
		
		w7 := next_key(31 downto 0);
		if (next_next_round_numer mod 2 = 1) then
			w7_rot(31 downto 8) := w7(23 downto 0);
			w7_rot(7 downto 0) := w7(31 downto 24);
		else 
			w7_rot := w7;
		end if;

		for i in 0 to 3 loop
			inp := mul_delta_8(w7_rot((i + 1) * 8 - 1 downto i * 8));
			inp_h := inp(7 downto 4);
			inp_l := inp(3 downto 0);
			result.w7_a(i) := inp_h;
			result.w7_b(i) := inp_l;
			result.w7_d(i) := inp_h xor inp_l;
		end loop;
		return result;
	end function;


    function ake_pipe_stage2 (
    	state_in             : ake_pipe_1res;    
    	next_next_round_numer: Integer range 3 to 15
    ) return ake_pipe_2res is
    	variable c: std_logic_vector(3 downto 0);
		variable e: std_logic_vector(3 downto 0);
		variable f: std_logic_vector(3 downto 0);
		variable result: ake_pipe_2res;
    begin
		result.next_key    := state_in.next_key;
		result.current_key := state_in.current_key;

		result.w8_init := state_in.w8_init;
		result.w9_init := state_in.w1 xor state_in.w8_init;
		result.w2      := state_in.w2;
		result.w3      := state_in.w3;
		
		for i in 0 to 3 loop
			c := sq_4(state_in.w7_a(i));
			e := mul_lam_4(c);
			f := mul_4(state_in.w7_b(i), state_in.w7_d(i));
			result.w7_a(i) := state_in.w7_a(i);
			result.w7_d(i) := state_in.w7_d(i);
			result.w7_g(i) := e xor f;
		end loop;
		return result;
    end function;


	function ake_pipe_stage3 (
		state_in             : ake_pipe_2res;    
		next_next_round_numer: Integer range 3 to 15
	) return ake_pipe_3res is
		variable result: ake_pipe_3res;
	begin
		result.next_key    := state_in.next_key;
		result.current_key := state_in.current_key;
		
		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w2 xor state_in.w9_init;
		result.w3       := state_in.w3;

		for i in 0 to 3 loop
			result.w7_a(i) := state_in.w7_a(i);
			result.w7_d(i) := state_in.w7_d(i);
			result.w7_h(i) := inv_4(state_in.w7_g(i));
		end loop;
		return result;
	end function;


	function ake_pipe_stage4 (
		state_in             : ake_pipe_3res;    
		next_next_round_numer: Integer range 3 to 15
	) return ake_pipe_4res is
		variable result: ake_pipe_4res;
	begin
		result.next_key    := state_in.next_key;
		result.current_key := state_in.current_key;

		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w10_init;
		result.w11_init := state_in.w3 xor state_in.w10_init;

		for i in 0 to 3 loop
			result.w7_i(i) := mul_4(state_in.w7_a(i), state_in.w7_h(i));
			result.w7_j(i) := mul_4(state_in.w7_d(i), state_in.w7_h(i));
		end loop;
		return result;
	end function;


	function ake_pipe_stage5 (
		state_in             : ake_pipe_4res;    
		next_next_round_numer: Integer range 3 to 15
	) return ake_pipe_5res is
		variable bte   : std_logic_vector(7 downto 0);
		variable w7_sub: std_logic_vector(31 downto 0);
		variable w7_rcon: std_logic_vector(31 downto 0);
		variable result: ake_pipe_5res;
	begin
		result.next_key    := state_in.next_key;
		result.current_key := state_in.current_key;
		
		result.w8_init  := state_in.w8_init;
		result.w9_init  := state_in.w9_init;
		result.w10_init := state_in.w10_init;
		result.w11_init := state_in.w11_init;

		for i in 0 to 3 loop
			bte(7 downto 4) := state_in.w7_i(i);
			bte(3 downto 0) := state_in.w7_j(i);
			w7_sub((i + 1) * 8 - 1 downto i * 8) := mul_deltainv_affine_8(bte);
		end loop;

		w7_rcon := w7_sub;
		if (next_next_round_numer mod 2 = 1) then
			w7_rcon(31 downto 24) := w7_rcon(31 downto 24) xor std_logic_vector(to_unsigned(2 ** (next_next_round_numer / 2 - 1), 8));
		end if;

		result.w7_done := w7_rcon;

		return result;
	end function;


	function ake_pipe_stage6 (
		state_in             : ake_pipe_5res;    
		next_next_round_numer: Integer range 3 to 15
	) return ake_pipe_6res is
		variable w8: std_logic_vector(31 downto 0);
		variable w9: std_logic_vector(31 downto 0);
		variable w10: std_logic_vector(31 downto 0);
		variable w11: std_logic_vector(31 downto 0);
		variable result: ake_pipe_6res;
	begin
		w8  := state_in.w8_init xor state_in.w7_done;
		w9  := state_in.w9_init xor state_in.w7_done;
		w10 := state_in.w10_init xor state_in.w7_done;
		w11 := state_in.w11_init xor state_in.w7_done;

		result.next_key                     := state_in.next_key;
		result.current_key                  := state_in.current_key;
		result.next_next_key(127 downto 96) := w8;
		result.next_next_key(95 downto 64)  := w9;
		result.next_next_key(63 downto 32)  := w10;
		result.next_next_key(31 downto 0)   := w11;

		return result;
	end function;

end aes_key_expansion_pipe;