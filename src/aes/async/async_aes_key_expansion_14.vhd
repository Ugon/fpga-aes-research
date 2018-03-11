library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity async_aes_key_expansion_14 is
	generic (
		block_bits                 : Integer               := 128);
	port (
		main_clk                : in  std_logic;
		current_key             : in  std_logic_vector(block_bits - 1 downto 0);
		next_key_in             : in  std_logic_vector(block_bits - 1 downto 0);
		
		corresponding_round_key : out std_logic_vector(block_bits - 1 downto 0);
		next_key_out            : out std_logic_vector(block_bits - 1 downto 0)
	);
end async_aes_key_expansion_14;

architecture async_aes_key_expansion_14_impl of async_aes_key_expansion_14 is 

begin
	
	corresponding_round_key <= current_key;
	next_key_out <= next_key_in;

end async_aes_key_expansion_14_impl;