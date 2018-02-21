library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_transformations.all;
use work.aes_sub_bytes_5pipe.all;
use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;


entity aes256enc is
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
		cyphertext    : out std_logic_vector(block_bits - 1 downto 0);
		

		dbg_block1    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_block2    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_block3    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_block4    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_block5    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_block6    : out std_logic_vector(block_bits - 1 downto 0);

		dbg_key1    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_key2    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_key3    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_key4    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_key5    : out std_logic_vector(block_bits - 1 downto 0);
		dbg_key6    : out std_logic_vector(block_bits - 1 downto 0)




		);
end aes256enc;

architecture aes256enc_impl of aes256enc is 

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

dbg_block1 <= connections(1).block_out;
dbg_block2 <= connections(2).block_out;
dbg_block3 <= connections(3).block_out;
dbg_block4 <= connections(4).block_out;
dbg_block5 <= connections(5).block_out;
dbg_block6 <= connections(6).block_out;
dbg_key1 <= connections(1).corresponding_key;
dbg_key2 <= connections(2).corresponding_key;
dbg_key3 <= connections(3).corresponding_key;
dbg_key4 <= connections(4).corresponding_key;
dbg_key5 <= connections(5).corresponding_key;
dbg_key6 <= connections(6).corresponding_key;

	cyphertext <= connections(15).block_out;

	connections(1).current_key <= key(255 downto 128);
	connections(1).next_key_in <= key(127 downto 0);
	connections(1).block_in    <= plaintext;

	GEN_CONNECTIONS: for i in 2 to 15 generate
		--process(main_clk, plaintext) begin
			--if(rising_edge(main_clk)) then
				connections(i).current_key <= connections(i - 1).next_key_out;
				connections(i).next_key_in <= connections(i - 1).next_next_key;
				connections(i).block_in    <= connections(i - 1).block_out;
			--end if;
		--end process;
	end generate GEN_CONNECTIONS; 

	--GEN_ROUNDS: for i in 1 to 14 generate
		--connections(i).current_key <= connections(i - 1).next_key_out;
		--connections(i).next_key_in <= connections(i - 1).next_next_key;
		--connections(i).block_in <= connections(i - 1).block_out;
	--end generate GEN_ROUNDS;


	round1_inst: entity work.aes_round_1
    	port map (
    		main_clk      => main_clk,
			corresponding_round_key => connections(1).corresponding_key,
			--current_key   => connections(1).current_key,
			--next_key_in   => connections(1).next_key_in,
			block_in      => connections(1).block_in,
			--next_key_out  => connections(1).next_key_out,
			--next_next_key => connections(1).next_next_key,
			block_out     => connections(1).block_out
		);

	key1_inst: entity work.aes_key_expansion_1_13
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
		roundX_inst: entity work.aes_round_2_14
			generic map (round_number => i)
    		port map (
    			main_clk      => main_clk,
				corresponding_round_key => connections(i).corresponding_key,
				--current_key   => c_key1,
				--next_key_in   => connections(i).next_key_in,
				block_in      => connections(i).block_in,
				--next_key_out  => connections(i).next_key_out,
				--next_next_key => connections(i).next_next_key,
				block_out     => connections(i).block_out
			);

		keyX_inst: entity work.aes_key_expansion_1_13
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

	round14_inst: entity work.aes_round_2_14
    	port map (
    		main_clk      => main_clk,
			corresponding_round_key => connections(14).corresponding_key,
			block_in      => connections(14).block_in,
			block_out     => connections(14).block_out
		);

	key14_inst: entity work.aes_key_expansion_14
    	port map (
    		main_clk                => main_clk,
			current_key             => connections(14).current_key,
			next_key_in             => connections(14).next_key_in,
			next_key_out            => connections(14).next_key_out,
			corresponding_round_key => connections(14).corresponding_key
		);	

	round15_inst: entity work.aes_round_15
    	port map (
    		main_clk      => main_clk,
			block_in      => connections(15).block_in,
			block_out     => connections(15).block_out,
			corresponding_round_key => connections(15).corresponding_key
		);

	key15_inst: entity work.aes_key_expansion_15
    	port map (
    		main_clk                => main_clk,
			current_key             => connections(15).current_key,
			corresponding_round_key => connections(15).corresponding_key
		);	

	process(main_clk, plaintext) begin
		if(rising_edge(main_clk)) then
	
		end if;
	end process;
 

end aes256enc_impl;