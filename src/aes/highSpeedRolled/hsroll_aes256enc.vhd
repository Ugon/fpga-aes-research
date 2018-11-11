library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hsroll_aes256enc is
	generic (
		block_bits         : Integer := 128);
	port (
		main_clk      : in  std_logic;
		key           : in  std_logic_vector(2 * block_bits - 1 downto 0);
		plaintext     : in  std_logic_vector(block_bits - 1 downto 0);
		cyphertext    : out std_logic_vector(block_bits - 1 downto 0);
		exchange      : out std_logic);
end hsroll_aes256enc;

architecture hsroll_aes256enc_impl of hsroll_aes256enc is 

	signal block_out       : std_logic_vector(127 downto 0);
	signal current_key_out : std_logic_vector(127 downto 0);
	signal next_key_out    : std_logic_vector(127 downto 0);
	signal last_key_out    : std_logic_vector(127 downto 0);
	
	signal block_in        : std_logic_vector(127 downto 0);
	signal prev_key_in     : std_logic_vector(127 downto 0);
	signal current_key_in  : std_logic_vector(127 downto 0);

	signal rot_en          : std_logic := '1';
	signal rcon_word       : std_logic_vector(7 downto 0) := "00000001";

	signal rcon_vect       : std_logic_vector(6 downto 0) := "0000001";
	signal rcon_vect_temp  : std_logic_vector(6 downto 0) := "0000001";
	
	signal loop_n          : std_logic := '1';

begin

	rcon_word <= '0' & rcon_vect;
	exchange <= loop_n;

	process(main_clk)
		variable rcon_cnt: Integer range 0 to 21 := 0;
	begin
		if(rising_edge(main_clk)) then	
			if (rcon_cnt = 18) then
				rcon_vect_temp(6 downto 1) <= rcon_vect_temp(5 downto 0);
				rcon_vect_temp(0) <= rcon_vect_temp(6);
			end if;

			if (rcon_cnt = 7) then
				rcon_vect <= rcon_vect_temp;
			elsif (rcon_cnt = 18) then
				rcon_vect <= (others => '0');
			end if;

			if (rcon_cnt = 10) then
				rot_en <= '0';
			elsif (rcon_cnt = 21) then 
				rot_en <= '1';
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
				loop_n <= '1';
			elsif (mux_cnt = 10) then 
				loop_n <= '0';
			end if;

			if (mux_cnt = 153) then 
				mux_cnt := 0;
			else
				mux_cnt := mux_cnt + 1;
			end if;

		end if;
	end process;


	process(loop_n) begin
		if(loop_n = '1') then
			block_in <= plaintext;
			prev_key_in <= key(255 downto 128);
			current_key_in <= key(127 downto 0);
		else
			block_in <= block_out;
			prev_key_in <= current_key_out;
			current_key_in <= next_key_out;
		end if;
	end process;

	key_inst: entity work.hs_aes_key_expansion
   		port map (
   			main_clk                => main_clk,
			prev_key_in             => prev_key_in,
			current_key_in          => current_key_in,
			current_key_out         => current_key_out,
			next_key_out            => next_key_out,
			last_key_out            => last_key_out,
			rot_en                  => rot_en,
			rcon_word               => rcon_word
		);


	round_inst: entity work.hs_aes_round
   		port map (
   			main_clk                => main_clk,
			block_in                => block_in,
			prev_key_in             => prev_key_in,
			block_out               => block_out,
			last_key_in             => last_key_out,
			last_block_out          => cyphertext
		);



end hsroll_aes256enc_impl;