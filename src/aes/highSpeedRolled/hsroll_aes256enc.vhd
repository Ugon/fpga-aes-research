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
		cyphertext    : out std_logic_vector(block_bits - 1 downto 0);
		exchange      : out std_logic;

		dbg_block_out : out std_logic_vector(block_bits - 1 downto 0);
		dbg_current_key_in : out std_logic_vector(block_bits - 1 downto 0);
		dbg_rcon      : out std_logic_vector(7 downto 0);
		dbg_rot_word  : out std_logic;
		dbg_counter   : out std_logic_vector(31 downto 0);
		dbg_mux       : out std_logic
	);
end hsroll_aes256enc;

architecture hsroll_aes256enc_impl of hsroll_aes256enc is 

	signal block_out: std_logic_vector(127 downto 0);
	signal next_key_out: std_logic_vector(127 downto 0);
	signal next_next_key_out: std_logic_vector(127 downto 0);
	signal last_next_key_out: std_logic_vector(127 downto 0);
	
	signal current_key_in: std_logic_vector(127 downto 0);
	signal next_key_in: std_logic_vector(127 downto 0);
	signal last_next_key_in: std_logic_vector(127 downto 0);
	signal block_in: std_logic_vector(127 downto 0);

	signal mux: std_logic := '1';


	signal rcon: std_logic_vector(7 downto 0) := "00000001";
	signal rot_word: std_logic := '1';

	--signal rot_word_vect: std_logic_vector(21 downto 0) := "1111111111100000000000";
	signal rot_word_vect: std_logic := '1';
	signal rcon_vect_premute: std_logic_vector(6 downto 0) := "0000001";
	signal rcon_vect_mute: std_logic_vector(6 downto 0) := "0000001";

begin

	dbg_block_out <= block_out;
	dbg_mux <= mux;
	dbg_current_key_in <= current_key_in;
	
	dbg_mux <= mux;
	dbg_rcon <= rcon;
	dbg_rot_word <= rot_word;


	rcon <= '0' & rcon_vect_mute;
	rot_word <= rot_word_vect;
	exchange <= mux;

	process(main_clk)
		variable rcon_cnt: Integer range 0 to 21 := 0;
	begin
		if(rising_edge(main_clk)) then	
			if (rcon_cnt = 18) then
				rcon_vect_premute(6 downto 1) <= rcon_vect_premute(5 downto 0);
				rcon_vect_premute(0) <= rcon_vect_premute(6);
			end if;

			if (rcon_cnt = 7) then
				rcon_vect_mute <= rcon_vect_premute;
			elsif (rcon_cnt = 18) then
				rcon_vect_mute <= (others => '0');
			end if;

			if (rcon_cnt = 10) then
				rot_word_vect <= '0';
			elsif (rcon_cnt = 21) then 
				rot_word_vect <= '1';
			end if;

			if (rcon_cnt = 21) then
				rcon_cnt := 0;
			else
				rcon_cnt := rcon_cnt + 1;
			end if;
		end if;
	end process;

	process(main_clk)
		variable mux_cnt: Integer range 0 to 153 := 0;
	begin
		if(rising_edge(main_clk)) then	
			if (mux_cnt = 153) then 
				mux <= '1';
			elsif (mux_cnt = 10) then 
				mux <= '0';
			end if;

			if (mux_cnt = 153) then 
				mux_cnt := 0;
			else
				mux_cnt := mux_cnt + 1;
			end if;

		end if;
	end process;


	process(mux) begin
		if(mux = '1') then
			block_in <= plaintext;
			current_key_in <= key(255 downto 128);
			next_key_in <= key(127 downto 0);
		else
			block_in <= block_out;
			current_key_in <= next_key_out;
			next_key_in <= next_next_key_out;
		end if;
	end process;

	key_inst: entity work.hsroll_aes_key_expansion_1_14
   		port map (
   			main_clk                => main_clk,
			current_key             => current_key_in,
			next_key_in             => next_key_in,
			next_key_out            => next_key_out,
			next_next_key           => next_next_key_out,
			last_next_key_out       => last_next_key_out,
			rot_word                => rot_word,
			rcon                    => rcon
		);


	round_inst: entity work.hsroll_aes_round_1_14
   		port map (
   			main_clk                => main_clk,
			corresponding_round_key => current_key_in,
			block_in                => block_in,
			block_out               => block_out,
			last_block_out          => cyphertext,
			last_round_key          => last_next_key_out
		);



end hsroll_aes256enc_impl;