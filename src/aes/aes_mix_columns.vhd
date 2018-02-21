library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_utils.all;

package aes_mix_columns is

	type mix_colums_intermediate is record 
		to_double: std_logic_vector(127 downto 0);
		side_xor : std_logic_vector(127 downto 0);
	end record;

	function mix_columns_a(state_in: std_logic_vector) return mix_colums_intermediate;	
	function mix_columns_b(state_in: mix_colums_intermediate) return std_logic_vector;	

	--8 => 8; multiplication by {02}_16 in GF(2^8) 
	function double(inp: std_logic_vector) return std_logic_vector;

end aes_mix_columns;

package body aes_mix_columns is

	function double(inp: std_logic_vector) return std_logic_vector is
		constant x0: std_logic := inp(inp'low + 0);
		constant x1: std_logic := inp(inp'low + 1);
		constant x2: std_logic := inp(inp'low + 2);
		constant x3: std_logic := inp(inp'low + 3);
		constant x4: std_logic := inp(inp'low + 4);
		constant x5: std_logic := inp(inp'low + 5);
		constant x6: std_logic := inp(inp'low + 6);
		constant x7: std_logic := inp(inp'low + 7);
		
		constant result: std_logic_vector(7 downto 0) := (x6, x5, x4, x3 xor x7, x2 xor x7, x1, x0 xor x7, x7);
	begin
		return result;
	end function;

	function mix_columns_a(state_in: std_logic_vector) return mix_colums_intermediate is
		variable b0: std_logic_vector(7 downto 0);
		variable b1: std_logic_vector(7 downto 0);
		variable b2: std_logic_vector(7 downto 0);
		variable b3: std_logic_vector(7 downto 0);

		variable b0b1: std_logic_vector(7 downto 0);
		variable b1b2: std_logic_vector(7 downto 0);
		variable b2b3: std_logic_vector(7 downto 0);
		variable b3b0: std_logic_vector(7 downto 0);

	 	variable state_out : mix_colums_intermediate;
	begin
		for c in 0 to 3 loop
			b0 := state_in(idx(0, c)'range);
			b1 := state_in(idx(1, c)'range);
			b2 := state_in(idx(2, c)'range);
			b3 := state_in(idx(3, c)'range);

			state_out.to_double(idx(0, c)'range) := b0 xor b1;
			state_out.to_double(idx(1, c)'range) := b1 xor b2;
			state_out.to_double(idx(2, c)'range) := b2 xor b3;
			state_out.to_double(idx(3, c)'range) := b3 xor b0;

			state_out.side_xor(idx(0, c)'range) := b1 xor b2 xor b3;
			state_out.side_xor(idx(1, c)'range) := b2 xor b3 xor b0;
			state_out.side_xor(idx(2, c)'range) := b3 xor b0 xor b1;
			state_out.side_xor(idx(3, c)'range) := b0 xor b1 xor b2;

			--b0b1 := b0 xor b1;
			--b1b2 := b1 xor b2;
			--b2b3 := b2 xor b3;
			--b3b0 := b3 xor b0;

			--state_out(idx(0, c)'range) := double(b0b1) xor b2b3 xor b1;
			--state_out(idx(1, c)'range) := double(b1b2) xor b3b0 xor b2;
			--state_out(idx(2, c)'range) := double(b2b3) xor b0b1 xor b3;
			--state_out(idx(3, c)'range) := double(b3b0) xor b1b2 xor b0;
		end loop;
		return state_out;
	end function;

	function mix_columns_b(state_in: mix_colums_intermediate) return std_logic_vector is
		--variable b0: std_logic_vector(7 downto 0);
		--variable b1: std_logic_vector(7 downto 0);
		--variable b2: std_logic_vector(7 downto 0);
		--variable b3: std_logic_vector(7 downto 0);
--
		--variable b0b1: std_logic_vector(7 downto 0);
		--variable b1b2: std_logic_vector(7 downto 0);
		--variable b2b3: std_logic_vector(7 downto 0);
		--variable b3b0: std_logic_vector(7 downto 0);

	 	variable state_out : std_logic_vector(127 downto 0);
	begin
		for c in 0 to 3 loop
			--b0 := state_in(idx(0, c)'range);
			--b1 := state_in(idx(1, c)'range);
			--b2 := state_in(idx(2, c)'range);
			--b3 := state_in(idx(3, c)'range);

			--b0b1 := b0 xor b1;
			--b1b2 := b1 xor b2;
			--b2b3 := b2 xor b3;
			--b3b0 := b3 xor b0;

			state_out(idx(0, c)'range) := double(state_in.to_double(idx(0, c)'range)) xor state_in.side_xor(idx(0, c)'range);
			state_out(idx(1, c)'range) := double(state_in.to_double(idx(1, c)'range)) xor state_in.side_xor(idx(1, c)'range);
			state_out(idx(2, c)'range) := double(state_in.to_double(idx(2, c)'range)) xor state_in.side_xor(idx(2, c)'range);
			state_out(idx(3, c)'range) := double(state_in.to_double(idx(3, c)'range)) xor state_in.side_xor(idx(3, c)'range);
		end loop;
		return state_out;
	end function;

end aes_mix_columns;