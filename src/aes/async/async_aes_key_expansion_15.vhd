library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity async_aes_key_expansion_15 is
	generic (
		block_bits                 : Integer               := 128);
	port (
		main_clk                : in  std_logic;
		current_key             : in  std_logic_vector(block_bits - 1 downto 0);
		
		corresponding_round_key : out std_logic_vector(block_bits - 1 downto 0)
	);
end async_aes_key_expansion_15;

architecture async_aes_key_expansion_15_impl of async_aes_key_expansion_15 is 

begin
	
	corresponding_round_key <= current_key;

end async_aes_key_expansion_15_impl;