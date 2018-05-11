library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mroll_aes256enc is
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
		next_plain    : out std_logic;
		prev_cypher   : out std_logic;

		dbg_block_out : out std_logic_vector(block_bits - 1 downto 0);
		dbg_rcon      : out std_logic_vector(7 downto 0);
		dbg_rot_word  : out std_logic;
		dbg_counter   : out std_logic_vector(31 downto 0);
		dbg_mux       : out std_logic;
		dbg_state     : out std_logic_vector(4 downto 0);

		dbg_current_key_in: out std_logic_vector(127 downto 0);
		dbg_prev_key_in: out std_logic_vector(127 downto 0)
	);
end mroll_aes256enc;

architecture mroll_aes256enc_impl of mroll_aes256enc is 

	signal block_out: std_logic_vector(127 downto 0);
	signal current_key_out: std_logic_vector(127 downto 0);
	signal next_key_out: std_logic_vector(127 downto 0);
	--signal last_current_key_out: std_logic_vector(127 downto 0);
	
	signal prev_key_in: std_logic_vector(127 downto 0);
	signal current_key_in: std_logic_vector(127 downto 0);
	--signal last_current_key_in: std_logic_vector(127 downto 0);
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
	--dbg_prev_key_in <= prev_key_in;
	
	dbg_mux <= mux;
	dbg_rcon <= rcon;
	dbg_rot_word <= rot_word;

	dbg_current_key_in <= current_key_in;
	dbg_prev_key_in <= prev_key_in;


	rcon <= '0' & rcon_vect_mute;
	rot_word <= rot_word_vect;

	process(main_clk)
		variable rcon_cnt: Integer range 0 to 43 := 0;
	begin
		dbg_counter <= std_logic_vector(to_unsigned(rcon_cnt, dbg_counter'length));
		if(rising_edge(main_clk)) then	
			if (rcon_cnt = 21) then
				rcon_vect_premute(6 downto 1) <= rcon_vect_premute(5 downto 0);
				rcon_vect_premute(0) <= rcon_vect_premute(6);
			end if;

			if (rcon_cnt = 42) then
				rcon_vect_mute <= rcon_vect_premute;
			elsif (rcon_cnt = 20) then
				rcon_vect_mute <= (others => '0');
			end if;

			if (rcon_cnt = 20) then
				rot_word_vect <= '0';
			elsif (rcon_cnt = 42) then 
				rot_word_vect <= '1';
			end if;

			if (rcon_cnt = 43) then
				rcon_cnt := 0;
			else
				rcon_cnt := rcon_cnt + 1;
			end if;
		end if;
	end process;

	process(main_clk)
		variable mux_cnt: Integer range 0 to 307 := 0;
	begin
		if(rising_edge(main_clk)) then	
			if (mux_cnt = 307) then 
				mux <= '1';
			elsif (mux_cnt = 21) then
				mux <= '0';
			end if;

			if (mux_cnt = 307) then 
				mux_cnt := 0;
			else
				mux_cnt := mux_cnt + 1;
			end if;

			if (mux_cnt = 307) then 
				next_plain <= '1';
			else 
				next_plain <= '0';
			end if;

			if (mux_cnt = 0) then 
				prev_cypher <= '1';
			else 
				prev_cypher <= '0';
			end if;

		end if;
	end process;


	process(mux) begin
		if(mux = '1') then
			block_in <= plaintext;
			prev_key_in <= key(255 downto 128);
			current_key_in <= key(127 downto 0);
		else
			block_in <= block_out;
			prev_key_in <= current_key_out;
			current_key_in <= next_key_out;
		end if;
	end process;

	round_inst: entity work.mroll_aes_round_1_14
   		port map (
   			main_clk                => main_clk,
			block_in                => block_in,
			current_key_in          => current_key_in,
			prev_key_in             => prev_key_in,

			current_key_out         => current_key_out,
			next_key_out            => next_key_out,

			block_out               => block_out,
			last_block_out          => cyphertext,
			rot_word                => rot_word,
			rcon                    => rcon,

			dbg_state => dbg_state
		);



end mroll_aes256enc_impl;