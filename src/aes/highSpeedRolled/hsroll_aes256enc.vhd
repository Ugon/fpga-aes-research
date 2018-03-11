library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.hsroll_aes_encryption_pipe.all;
use work.hsroll_aes_key_expansion_pipe.all;

entity hsroll_aes256enc is
	generic (
		byte_bits          : Integer := 8;
		block_bytes        : Integer := 16;
		block_bits         : Integer := 128;
		key_bytes          : Integer := 32;
		key_expansion_bits : Integer := 15 * 128);
	port (
		main_clk      : in  std_logic;
		key           : in  std_logic_vector(2 * block_bits - 1 downto 0);
		plaintext     : in  std_logic_vector(block_bits - 1 downto 0);
		cyphertext    : out std_logic_vector(block_bits - 1 downto 0)
	);
end hsroll_aes256enc;

architecture hsroll_aes256enc_impl of hsroll_aes256enc is 

	type round_connection is record
		current_key       : std_logic_vector(block_bits - 1 downto 0);
		next_key_in       : std_logic_vector(block_bits - 1 downto 0);
		block_in          : std_logic_vector(block_bits - 1 downto 0);
		next_key_out      : std_logic_vector(block_bits - 1 downto 0);
		next_next_key     : std_logic_vector(block_bits - 1 downto 0);
		block_out         : std_logic_vector(block_bits - 1 downto 0);
		--corresponding_key : std_logic_vector(block_bits - 1 downto 0);
	end record;

	type round_connections is array (1 to 15) of round_connection;

	signal connections: round_connections;

begin

	connections(1).current_key <= key(255 downto 128);
	connections(1).next_key_in <= key(127 downto 0);
	connections(1).block_in    <= plaintext;
	
	cyphertext <= connections(14).block_out;

	GEN_CONNECTIONS: for i in 2 to 15 generate
		connections(i).current_key <= connections(i - 1).next_key_out;
		connections(i).next_key_in <= connections(i - 1).next_next_key;
		connections(i).block_in    <= connections(i - 1).block_out;
	end generate GEN_CONNECTIONS; 

    GEN_ROUNDS: for i in 1 to 13 generate
		roundX_inst: entity work.hsroll_aes_round_1_14
			generic map (round_number => i)
    		port map (
    			main_clk                => main_clk,
				corresponding_round_key => connections(i).current_key,
				block_in                => connections(i).block_in,
				block_out               => connections(i).block_out
			);

		keyX_inst: entity work.hsroll_aes_key_expansion_1_14
			generic map (corresponding_round_number => i)
    		port map (
    			main_clk                => main_clk,
				current_key             => connections(i).current_key,
				next_key_in             => connections(i).next_key_in,
				next_key_out            => connections(i).next_key_out,
				next_next_key           => connections(i).next_next_key
			);
	end generate GEN_ROUNDS;

	round14_inst: entity work.hsroll_aes_round_1_14
    	port map (
    		main_clk                => main_clk,
			block_in                => connections(14).block_in,
			corresponding_round_key => connections(14).current_key,

			last_round_key          => connections(14).next_key_out,
			last_block_out          => connections(14).block_out
		);

	key14_inst: entity work.hsroll_aes_key_expansion_1_14
    	port map (
    		main_clk                => main_clk,
			next_key_in             => connections(14).next_key_in,
			last_next_key_out       => connections(14).next_key_out
		);	

end hsroll_aes256enc_impl;