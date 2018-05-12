library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_shift_rows.all;
use work.aes_mix_columns.all;

entity mroll_aes_round_and_key is
	generic (
		block_bits            : Integer := 128);
	port (
		main_clk              : in  std_logic;

		block_in              : in  std_logic_vector(block_bits - 1 downto 0);
		current_key_in        : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		prev_key_in           : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');

		current_key_out       : out std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		next_key_out          : out std_logic_vector(block_bits - 1 downto 0) := (others => '0');

		block_out             : out std_logic_vector(block_bits - 1 downto 0);
		last_block_out        : out std_logic_vector(block_bits - 1 downto 0);

		rot_en                : in  std_logic;
		rcon_word             : in  std_logic_vector(7 downto 0);

		dbg_sbox_address      : out std_logic_vector(7 downto 0);
		dbg_sbox_data         : out std_logic_vector(7 downto 0);

		dbg_key_word7         : out std_logic_vector(31 downto 0);
		dbg_key_word8         : out std_logic_vector(31 downto 0);
		dbg_key_word9         : out std_logic_vector(31 downto 0);
		dbg_key_word10        : out std_logic_vector(31 downto 0);
		dbg_key_word11        : out std_logic_vector(31 downto 0);

		dbg_aes_state         : out std_logic_vector(127 downto 0);
		dbg_next_key_state    : out std_logic_vector(127 downto 0);
		dbg_current_key_state : out std_logic_vector(127 downto 0);

		dbg_state             : out std_logic_vector(4 downto 0));
end mroll_aes_round_and_key;

architecture mroll_aes_round_and_key_impl of mroll_aes_round_and_key is 
	signal state: Integer range 0 to 21;

	signal sbox_address : std_logic_vector(7 downto 0);
	signal sbox_data    : std_logic_vector(7 downto 0);
	
	signal key_word7  : std_logic_vector(31 downto 0);
	signal key_word8  : std_logic_vector(31 downto 0);
	signal key_word9  : std_logic_vector(31 downto 0);
	signal key_word10 : std_logic_vector(31 downto 0);
	signal key_word11 : std_logic_vector(31 downto 0);

	signal rcon_state        : std_logic_vector(7 downto 0);
	signal aes_state         : std_logic_vector(127 downto 0);
	signal next_key_state    : std_logic_vector(127 downto 0);
	signal current_key_state : std_logic_vector(127 downto 0);

begin

	dbg_sbox_address      <= sbox_address;
	dbg_sbox_data         <= sbox_data;

	dbg_key_word7         <= key_word7;
	dbg_key_word8         <= key_word8;
	dbg_key_word9         <= key_word9;
	dbg_key_word10        <= key_word10;
	dbg_key_word11        <= key_word11;

	dbg_aes_state         <= aes_state;
	dbg_next_key_state    <= next_key_state;
	dbg_current_key_state <= current_key_state;

	sbox_inst: work.sbox
    	port map (
    	    address  => sbox_address,
    	    q        => sbox_data,
    	    clock    => main_clk);

	dbg_state <= std_logic_vector(to_unsigned(state, dbg_state'length));

	process(main_clk, state) 
		variable w7_sub: std_logic_vector(31 downto 0);
		variable last_state_temp: std_logic_vector(127 downto 0);
	begin
		if(rising_edge(main_clk)) then
			if (state = 21) then
				state <= 0;
			else 
				state <= state + 1;
			end if;

			case state is
				when 0 =>
					--key
					current_key_state <= current_key_in;

					key_word8  <= prev_key_in(127 downto 96);
					key_word9  <= prev_key_in(95 downto 64);
					key_word10 <= prev_key_in(63 downto 32);
					key_word11 <= prev_key_in(31 downto 0);

					if (rot_en = '1') then
						key_word7(31 downto 8) <= current_key_in(23 downto 0);
						key_word7(7 downto 0)  <= current_key_in(31 downto 24);
					else 
						key_word7(31 downto 0) <= current_key_in(31 downto 0);
					end if;

					rcon_state <= rcon_word;

					--aes
					aes_state <= block_in xor prev_key_in;

					--mem
					if (rot_en = '1') then
						sbox_address <= current_key_in(23 downto 16);
					else
						sbox_address <= current_key_in(31 downto 24);
					end if;

				when 1 =>
					--key
					--current_key_state <= current_key_state;

					--key_word8  <= key_word8;
					key_word9  <= key_word9 xor key_word8;
					--key_word10 <= key_word10;
					--key_word11 <= key_word11;

					--key_word7 <= key_word7;
						
					--rcon_state <= rcon_state;
	
					--aes
					--aes_state <= aes_state;

					--mem
					sbox_address <= key_word7(23 downto 16);

				when 2 =>
					--key
					--current_key_state <= current_key_state;

					--key_word8  <= key_word8;
					--key_word9  <= key_word9;
					key_word10 <= key_word10 xor key_word9;
					--key_word11 <= key_word11;
					
					key_word7(31 downto 24) <= sbox_data;
					--key_word7(23 downto 0)  <= key_word7(23 downto 0);

					--rcon_state <= rcon_state;
					
					--aes
					--aes_state <= aes_state;

					--mem
					sbox_address <= key_word7(15 downto 8);

				when 3 =>
					--key
					--current_key_state <= current_key_state;

					--key_word8  <= key_word8;
					--key_word9  <= key_word9;
					--key_word10 <= key_word10;
					key_word11 <= key_word11 xor key_word10;

					--key_word7(31 downto 24) <= key_word7(31 downto 24);
					key_word7(23 downto 16) <= sbox_data;
					--key_word7(15 downto 0)  <= key_word7(15 downto 0);

					--rcon_state <= rcon_state;

					--aes
					--aes_state <= aes_state;					

					--mem
					sbox_address <= key_word7(7 downto 0);				

				when 4 =>
					--key
					--current_key_state <= current_key_state;

					--key_word8  <= key_word8;
					--key_word9  <= key_word9;
					--key_word10 <= key_word10;
					--key_word11 <= key_word11;

					--key_word7(31 downto 16) <= key_word7(31 downto 16);
					key_word7(15 downto 8)  <= sbox_data;
					--key_word7(7 downto 0)   <= key_word7(7 downto 0);
					
					--rcon_state <= rcon_state;

					--aes
					--aes_state <= aes_state;
					
					--mem
					sbox_address <= aes_state(127 downto 120);				

				when 5 =>
					--key
					--current_key_state <= current_key_state;
					
					w7_sub(31 downto 8) := key_word7(31 downto 8);
					w7_sub(7 downto 0)  := sbox_data;

					w7_sub(31 downto 24) := w7_sub(31 downto 24) xor rcon_state;

					next_key_state(127 downto 96) <= key_word8 xor w7_sub;
					next_key_state(95 downto 64)  <= key_word9 xor w7_sub;
					next_key_state(63 downto 32)  <= key_word10 xor w7_sub;
					next_key_state(31 downto 0)   <= key_word11 xor w7_sub;

					--aes
					
					--mem
					sbox_address <= aes_state(119 downto 112);
					
				when 6 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					aes_state(127 downto 120) <= sbox_data;
					--aes_state(119 downto 0)   <= aes_state(119 downto 0);
					
					--mem
					sbox_address <= aes_state(111 downto 104);

				when 7 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 120) <= aes_state(127 downto 120);
					aes_state(119 downto 112) <= sbox_data;
					--aes_state(111 downto 0)   <= aes_state(111 downto 0);
					
					--mem
					sbox_address <= aes_state(103 downto 96);


				when 8 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 112) <= aes_state(127 downto 112);
					aes_state(111 downto 104) <= sbox_data;
					--aes_state(103 downto 0)   <= aes_state(103 downto 0);					

					--mem
					sbox_address <= aes_state(95 downto 88);

				when 9 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 104) <= aes_state(127 downto 104);
					aes_state(103 downto 96) <= sbox_data;
					--aes_state(95 downto 0)   <= aes_state(95 downto 0);
					
					--mem
					sbox_address <= aes_state(87 downto 80);
	
				when 10 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 96) <= aes_state(127 downto 96);
					aes_state(95 downto 88)  <= sbox_data;
					--aes_state(87 downto 0)   <= aes_state(87 downto 0);
					
					--mem
					sbox_address <= aes_state(79 downto 72);

				when 11 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 88) <= aes_state(127 downto 88);
					aes_state(87 downto 80)  <= sbox_data;
					--aes_state(79 downto 0)   <= aes_state(79 downto 0);
					
					--mem
					sbox_address <= aes_state(71 downto 64);

				when 12 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 80) <= aes_state(127 downto 80);
					aes_state(79 downto 72)  <= sbox_data;
					--aes_state(71 downto 0)   <= aes_state(71 downto 0);
					
					--mem
					sbox_address <= aes_state(63 downto 56);

				when 13 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 72) <= aes_state(127 downto 72);
					aes_state(71 downto 64)  <= sbox_data;
					--aes_state(63 downto 0)   <= aes_state(63 downto 0);
					
					--mem
					sbox_address <= aes_state(55 downto 48);

				when 14 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 64) <= aes_state(127 downto 64);
					aes_state(63 downto 56)  <= sbox_data;
					--aes_state(55 downto 0)   <= aes_state(55 downto 0);
					
					--mem
					sbox_address <= aes_state(47 downto 40);

				when 15 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 56) <= aes_state(127 downto 56);
					aes_state(55 downto 48)  <= sbox_data;
					--aes_state(47 downto 0)   <= aes_state(47 downto 0);					

					--mem
					sbox_address <= aes_state(39 downto 32);

				when 16 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 48) <= aes_state(127 downto 48);
					aes_state(47 downto 40)  <= sbox_data;
					--aes_state(39 downto 0)   <= aes_state(39 downto 0);
					
					--mem
					sbox_address <= aes_state(31 downto 24);
						
				when 17 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 40) <= aes_state(127 downto 40);
					aes_state(39 downto 32)  <= sbox_data;
					--aes_state(31 downto 0)   <= aes_state(31 downto 0);
					
					--mem
					sbox_address <= aes_state(23 downto 16);
					
				when 18 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 32) <= aes_state(127 downto 32);
					aes_state(31 downto 24)  <= sbox_data;
					--aes_state(23 downto 0)   <= aes_state(23 downto 0);
					
					--mem
					sbox_address <= aes_state(15 downto 8);

				when 19 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 24) <= aes_state(127 downto 24);
					aes_state(23 downto 16)  <= sbox_data;
					--aes_state(15 downto 0)   <= aes_state(15 downto 0);
					
					--mem
					sbox_address <= aes_state(7 downto 0);
					
				when 20 =>
					--key
					--current_key_state <= current_key_state;
					--next_key_state <= next_key_state;

					--aes
					--aes_state(127 downto 16) <= aes_state(127 downto 16);
					aes_state(15 downto 8)  <= sbox_data;
					--aes_state(7 downto 0)   <= aes_state(7 downto 0);
					
					--mem

				when 21 =>
					--key
					current_key_out <= current_key_state;
					next_key_out <= next_key_state;

					--aes
					last_state_temp(127 downto 8) := aes_state(127 downto 8);
					last_state_temp(7 downto 0)   := sbox_data;
					last_state_temp := shift_rows(last_state_temp);
					last_block_out  <= last_state_temp xor current_key_state;
					last_state_temp := mix_columns_b(mix_columns_a(last_state_temp));
					block_out       <= last_state_temp;
					
					--mem
	
			end case;
		end if;
	end process; 


end mroll_aes_round_and_key_impl;