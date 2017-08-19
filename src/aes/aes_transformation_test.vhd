library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_transformations.all;
use work.aes_utils.all;

entity aes_transformation_test is
	generic (
		key_bits           : Integer := 256;
		key_expansion_bits : Integer := 15 * 128;
		byte_bits          : Integer := 8;
		block_bytes        : Integer := 16;
		block_bits         : Integer := 128);
	port (
		key          : in  std_logic_vector(key_bits   - 1 downto 0);
		in_data      : in  std_logic_vector(block_bits - 1 downto 0);
		expected     : in  std_logic_vector(block_bits - 1 downto 0);
		out_data     : out std_logic_vector(block_bits - 1 downto 0);
		key_exp      : out std_logic_vector(key_expansion_bits - 1 downto 0);
		pass         : out std_logic);
end aes_transformation_test;

architecture aes256enc_impl of aes_transformation_test is 
	
begin
	
	process (key, in_data, expected)
		variable key_exp_internal  : std_logic_vector(key_expansion_bits - 1 downto 0);
		variable out_data_internal : std_logic_vector(block_bits - 1 downto 0);
	begin
		key_exp_internal  := key_expansion256(key);
	
		out_data_internal := add_round_key(in_data, key_exp_internal, 13);
		--out_data_internal := sub_bytes(in_data);
		--out_data_internal := shift_rows(in_data);
		--out_data_internal := mix_columns(in_data);

		key_exp           <= key_exp_internal;
		out_data          <= out_data_internal;

		if (out_data_internal = expected) then 
			pass <= '1';
		else 
			pass <= '0';
		end if;

	end process;


end aes256enc_impl;