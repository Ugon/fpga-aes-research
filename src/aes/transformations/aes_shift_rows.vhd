library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_utils.all;

package aes_shift_rows is

	function shift_rows(state_in: std_logic_vector) return std_logic_vector;	

end aes_shift_rows;

package body aes_shift_rows is

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


end aes_shift_rows;


