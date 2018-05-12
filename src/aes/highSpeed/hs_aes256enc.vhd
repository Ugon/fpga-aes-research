library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity hs_aes256enc is
	generic (
		block_bits         : Integer := 128);
	port (
		main_clk      : in  std_logic;
		key           : in  std_logic_vector(2 * block_bits - 1 downto 0);
		plaintext     : in  std_logic_vector(block_bits - 1 downto 0);
		cyphertext    : out std_logic_vector(block_bits - 1 downto 0)
	);
end hs_aes256enc;

architecture hs_aes256enc_impl of hs_aes256enc is 

	type round_connection is record
		current_key       : std_logic_vector(block_bits - 1 downto 0);
		next_key_in       : std_logic_vector(block_bits - 1 downto 0);
		block_in          : std_logic_vector(block_bits - 1 downto 0);
		next_key_out      : std_logic_vector(block_bits - 1 downto 0);
		next_next_key     : std_logic_vector(block_bits - 1 downto 0);
		block_out         : std_logic_vector(block_bits - 1 downto 0);
		corresponding_key : std_logic_vector(block_bits - 1 downto 0);
	end record;

	type round_connections is array (1 to 15) of round_connection;

	signal connections: round_connections;

begin

	connections(1).current_key <= key(255 downto 128);
	connections(1).next_key_in <= key(127 downto 0);
	connections(1).block_in    <= plaintext;
	
	cyphertext <= connections(15).block_out;

	GEN_CONNECTIONS: for i in 2 to 15 generate
		connections(i).current_key <= connections(i - 1).next_key_out;
		connections(i).next_key_in <= connections(i - 1).next_next_key;
		connections(i).block_in    <= connections(i - 1).block_out;
	end generate GEN_CONNECTIONS; 

	round1_inst: entity work.hs_aes_round_1
    	port map (
    		main_clk                => main_clk,
			block_in                => connections(1).block_in,
			block_out               => connections(1).block_out,
			corresponding_round_key => connections(1).corresponding_key
		);

	key1_inst: entity work.hs_aes_key_expansion_1_13
		generic map (corresponding_round_number => 1)
    	port map (
    		main_clk                => main_clk,
			current_key             => connections(1).current_key,
			next_key_in             => connections(1).next_key_in,
			next_key_out            => connections(1).next_key_out,
			next_next_key           => connections(1).next_next_key,
			corresponding_round_key => connections(1).corresponding_key
		);

    GEN_ROUNDS: for i in 2 to 13 generate
		roundX_inst: entity work.hs_aes_round_2_14
			generic map (round_number => i)
    		port map (
    			main_clk                => main_clk,
				corresponding_round_key => connections(i).corresponding_key,
				block_in                => connections(i).block_in,
				block_out               => connections(i).block_out
			);

		keyX_inst: entity work.hs_aes_key_expansion_1_13
			generic map (corresponding_round_number => i)
    		port map (
    			main_clk                => main_clk,
				current_key             => connections(i).current_key,
				next_key_in             => connections(i).next_key_in,
				next_key_out            => connections(i).next_key_out,
				next_next_key           => connections(i).next_next_key,
				corresponding_round_key => connections(i).corresponding_key
			);
	end generate GEN_ROUNDS;

	round14_inst: entity work.hs_aes_round_2_14
    	port map (
    		main_clk                => main_clk,
			block_in                => connections(14).block_in,
			block_out               => connections(14).block_out,
			corresponding_round_key => connections(14).corresponding_key
		);

	key14_inst: entity work.hs_aes_key_expansion_14
    	port map (
    		main_clk                => main_clk,
			current_key             => connections(14).current_key,
			next_key_in             => connections(14).next_key_in,
			next_key_out            => connections(14).next_key_out,
			corresponding_round_key => connections(14).corresponding_key
		);	

	round15_inst: entity work.hs_aes_round_15
    	port map (
    		main_clk                => main_clk,
			block_in                => connections(15).block_in,
			block_out               => connections(15).block_out,
			corresponding_round_key => connections(15).corresponding_key
		);

	key15_inst: entity work.hs_aes_key_expansion_15
    	port map (
    		main_clk                => main_clk,
			current_key             => connections(15).current_key,
			corresponding_round_key => connections(15).corresponding_key
		);	

end hs_aes256enc_impl;