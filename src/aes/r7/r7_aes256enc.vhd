library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity r7_aes256enc is
	generic (
		block_bits : Integer := 128);
	port (
		main_clk   : in  std_logic;
		key        : in  std_logic_vector(2 * block_bits - 1 downto 0);
		plaintext  : in  std_logic_vector(block_bits - 1 downto 0);
		cyphertext : out std_logic_vector(block_bits - 1 downto 0)

		--dbg_last_key_out : out std_logic_vector(block_bits - 1 downto 0);

		--dbg_block_out1 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out2 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out3 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out4 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out5 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out6 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out7 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out8 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out9 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out10 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out11 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out12 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out13 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_block_out14 : out std_logic_vector(block_bits - 1 downto 0);

		--dbg_next_key_out1 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out2 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out3 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out4 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out5 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out6 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out7 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out8 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out9 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out10 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out11 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out12 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out13 : out std_logic_vector(block_bits - 1 downto 0);
		--dbg_next_key_out14 : out std_logic_vector(block_bits - 1 downto 0)
	);
end r7_aes256enc;

architecture r7_aes256enc_impl of r7_aes256enc is 

	type round_connection is record
		prev_key_in       : std_logic_vector(block_bits - 1 downto 0);
		current_key_in    : std_logic_vector(block_bits - 1 downto 0);
		block_in          : std_logic_vector(block_bits - 1 downto 0);
		current_key_out   : std_logic_vector(block_bits - 1 downto 0);
		next_key_out      : std_logic_vector(block_bits - 1 downto 0);
		last_key_out      : std_logic_vector(block_bits - 1 downto 0);
		last_key_in       : std_logic_vector(block_bits - 1 downto 0);
		block_out         : std_logic_vector(block_bits - 1 downto 0);
		last_block_out    : std_logic_vector(block_bits - 1 downto 0);
		rot_en            : std_logic;
		rcon_word         : std_logic_vector(7 downto 0);
	end record;

	type round_connections is array (1 to 15) of round_connection;

	signal connections: round_connections;

begin

	--dbg_block_out1 <= connections(1).block_out;
	--dbg_block_out2 <= connections(2).block_out;
	--dbg_block_out3 <= connections(3).block_out;
	--dbg_block_out4 <= connections(4).block_out;
	--dbg_block_out5 <= connections(5).block_out;
	--dbg_block_out6 <= connections(6).block_out;
	--dbg_block_out7 <= connections(7).block_out;
	--dbg_block_out8 <= connections(8).block_out;
	--dbg_block_out9 <= connections(9).block_out;
	--dbg_block_out10 <= connections(10).block_out;
	--dbg_block_out11 <= connections(11).block_out;
	--dbg_block_out12 <= connections(12).block_out;
	--dbg_block_out13 <= connections(13).block_out;
	--dbg_block_out14 <= connections(14).block_out;

	--dbg_next_key_out1 <= connections(1).next_key_out;
	--dbg_next_key_out2 <= connections(2).next_key_out;
	--dbg_next_key_out3 <= connections(3).next_key_out;
	--dbg_next_key_out4 <= connections(4).next_key_out;
	--dbg_next_key_out5 <= connections(5).next_key_out;
	--dbg_next_key_out6 <= connections(6).next_key_out;
	--dbg_next_key_out7 <= connections(7).next_key_out;
	--dbg_next_key_out8 <= connections(8).next_key_out;
	--dbg_next_key_out9 <= connections(9).next_key_out;
	--dbg_next_key_out10 <= connections(10).next_key_out;
	--dbg_next_key_out11 <= connections(11).next_key_out;
	--dbg_next_key_out12 <= connections(12).next_key_out;
	--dbg_next_key_out13 <= connections(13).next_key_out;
	--dbg_next_key_out14 <= connections(14).next_key_out;

	--dbg_last_key_out   <= connections(14).last_key_out;

	cyphertext <= connections(14).last_block_out;

	connections(1).prev_key_in    <= key(255 downto 128);
	connections(1).current_key_in <= key(127 downto 0);
	connections(1).block_in       <= plaintext;

	connections(1).rot_en <= '1';
	connections(2).rot_en <= '0';
	connections(3).rot_en <= '1';
	connections(4).rot_en <= '0';
	connections(5).rot_en <= '1';
	connections(6).rot_en <= '0';
	connections(7).rot_en <= '1';
	connections(8).rot_en <= '0';
	connections(9).rot_en <= '1';
	connections(10).rot_en <= '0';
	connections(11).rot_en <= '1';
	connections(12).rot_en <= '0';
	connections(13).rot_en <= '1';
	connections(14).rot_en <= '0';
	
	connections(1).rcon_word <= "00000001";
	connections(2).rcon_word <= "00000000";
	connections(3).rcon_word <= "00000010";
	connections(4).rcon_word <= "00000000";
	connections(5).rcon_word <= "00000100";
	connections(6).rcon_word <= "00000000";
	connections(7).rcon_word <= "00001000";
	connections(8).rcon_word <= "00000000";
	connections(9).rcon_word <= "00010000";
	connections(10).rcon_word <= "00000000";
	connections(11).rcon_word <= "00100000";
	connections(12).rcon_word <= "00000000";
	connections(13).rcon_word <= "01000000";
	connections(14).rcon_word <= "00000000";

	GEN_CONNECTIONS: for i in 2 to 15 generate
		connections(i).prev_key_in    <= connections(i - 1).current_key_out;
		connections(i).current_key_in <= connections(i - 1).next_key_out;
		connections(i).block_in       <= connections(i - 1).block_out;
	end generate GEN_CONNECTIONS; 
	connections(14).last_key_in       <= connections(14).last_key_out;

    GEN_ROUNDS: for i in 1 to 14 generate
		roundX_inst: entity work.r7_aes_round
    		port map (
    			main_clk       => main_clk,
				block_in       => connections(i).block_in,
				block_out      => connections(i).block_out,
				last_block_out => connections(i).last_block_out,
				prev_key_in    => connections(i).prev_key_in,
				last_key_in    => connections(i).last_key_in
			);

		keyX_inst: entity work.r7_aes_key_expansion
    		port map (
    			main_clk          => main_clk,
				prev_key_in       => connections(i).prev_key_in,
				current_key_in    => connections(i).current_key_in,
				current_key_out   => connections(i).current_key_out,
				next_key_out      => connections(i).next_key_out,
				last_key_out      => connections(i).last_key_out,
				rot_en            => connections(i).rot_en,
				rcon_word         => connections(i).rcon_word
			);
	end generate GEN_ROUNDS;

end r7_aes256enc_impl;