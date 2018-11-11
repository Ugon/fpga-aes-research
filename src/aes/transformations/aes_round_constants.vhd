library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package aes_round_constants is
	 
	type t_rot_en_array is array (1 to 14) of std_logic;
	type t_rcon_word is array (1 to 14) of std_logic_vector(7 downto 0);

	constant rot_en_array : t_rot_en_array := (
		'1',
		'0',
		'1',
		'0',
		'1',
		'0',
		'1',
		'0',
		'1',
		'0',
		'1',
		'0',
		'1',
		'0'
	);

	constant rcon_word_array : t_rcon_word := (
		"00000001",
		"00000000",
		"00000010",
		"00000000",
		"00000100",
		"00000000",
		"00001000",
		"00000000",
		"00010000",
		"00000000",
		"00100000",
		"00000000",
		"01000000",
		"00000000"
	);

end aes_round_constants;

package body aes_round_constants is

end aes_round_constants;