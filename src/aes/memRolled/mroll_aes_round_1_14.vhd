library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_shift_rows.all;
use work.aes_mix_columns.all;

entity mroll_aes_round_1_14 is
	generic (
		block_bits             : Integer               := 128);
	port (
		main_clk                : in  std_logic;

		block_in                : in  std_logic_vector(block_bits - 1 downto 0);
		current_key_in          : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		prev_key_in             : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');

		current_key_out         : out std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		next_key_out            : out std_logic_vector(block_bits - 1 downto 0) := (others => '0');

		block_out               : out std_logic_vector(block_bits - 1 downto 0);
		last_block_out          : out std_logic_vector(block_bits - 1 downto 0);

		supply_block            : out std_logic;
		collect_block           : out std_logic;

		rot_word                : in  std_logic;
		rcon                    : in  std_logic_vector(7 downto 0);

		dbg_key_states: out std_logic_vector(127 downto 0);
		dbg_aes_states: out std_logic_vector(127 downto 0);

		dbg_key_words0: out std_logic_vector(31 downto 0);
		dbg_key_words1: out std_logic_vector(31 downto 0);
		dbg_key_words2: out std_logic_vector(31 downto 0);
		dbg_key_words3: out std_logic_vector(31 downto 0);
		dbg_key_sbox_words: out std_logic_vector(31 downto 0);

		dbg_state: out std_logic_vector(4 downto 0);

		dbg_sbox_address: out std_logic_vector(7 downto 0);
		dbg_sbox_data: out std_logic_vector(7 downto 0)
	);
end mroll_aes_round_1_14;

architecture mroll_aes_round_1_14_impl of mroll_aes_round_1_14 is 
	type fsm is (
		state1,
		state2,
		state3,
		state4,
		state5,
		state6,
		state7,
		state8,
		state9,
		state10,
		state11,
		state12,
		state13,
		state14,
		state15,
		state16,
		state17,
		state18,
		state19,
		state20,
		state21,
		state22
		);
	signal state: fsm;

	--type block_states is array (0 to 20) of std_logic_vector(127 downto 0);
	--type words is array (0 to 20) of std_logic_vector(31 downto 0);

	signal sbox_address: std_logic_vector(7 downto 0);
	signal sbox_data:    std_logic_vector(7 downto 0);
	
	signal finishing_key: std_logic_vector(127 downto 0);
	signal finishing_aes: std_logic_vector(127 downto 0);

	signal current_key_states: std_logic_vector(127 downto 0);

	signal key_word7: std_logic_vector(31 downto 0);
	signal key_word8: std_logic_vector(31 downto 0);
	signal key_word9: std_logic_vector(31 downto 0);
	signal key_word10: std_logic_vector(31 downto 0);
	signal key_word11: std_logic_vector(31 downto 0);

	signal key_states: std_logic_vector(127 downto 0);
	signal aes_states: std_logic_vector(127 downto 0);

	signal rot_word_state: std_logic;
	signal rcon_state: std_logic_vector(7 downto 0);

begin

dbg_key_states <= key_states;
dbg_aes_states <= aes_states;

dbg_key_words0 <= key_word8;
dbg_key_words1 <= key_word9;
dbg_key_words2 <= key_word10;
dbg_key_words3 <= key_word11;
dbg_key_sbox_words <= key_word7;

dbg_sbox_address <= sbox_address;
dbg_sbox_data <= sbox_data;
	
	sbox_inst: work.sbox
    	port map (
    	    address  => sbox_address,
    	    q        => sbox_data,
    	    clock    => main_clk);

    process (state) begin
    	case state is
			--when state0 => dbg_state <= "00000";
			when state1 => dbg_state <= "00001";
			when state2 => dbg_state <= "00010";
			when state3 => dbg_state <= "00011";
			when state4 => dbg_state <= "00100";
			when state5 => dbg_state <= "00101";
			when state6 => dbg_state <= "00110";
			when state7 => dbg_state <= "00111";
			when state8 => dbg_state <= "01000";
			when state9 => dbg_state <= "01001";
			when state10 => dbg_state <= "01010";
			when state11 => dbg_state <= "01011";
			when state12 => dbg_state <= "01100";
			when state13 => dbg_state <= "01101";
			when state14 => dbg_state <= "01110";
			when state15 => dbg_state <= "01111";
			when state16 => dbg_state <= "10000";
			when state17 => dbg_state <= "10001";
			when state18 => dbg_state <= "10010";
			when state19 => dbg_state <= "10011";
			when state20 => dbg_state <= "10100";
			when state21 => dbg_state <= "10101";
			when state22 => dbg_state <= "10110";
    	end case;

    end process;

	process(main_clk, state) 
		variable w7_sub: std_logic_vector(31 downto 0);
		variable last_state_temp: std_logic_vector(127 downto 0);
	begin
		if(rising_edge(main_clk)) then
			case state is 
				--when state0 =>
					--state <= state1;
					--supply_block <= '1';
					--collect_block <= '0';

				when state1 =>
					state <= state2;
					supply_block <= '0';
					collect_block <= '0';

					--key
					current_key_states <= current_key_in;
					key_word8 <= prev_key_in(127 downto 96);
					key_word9 <= prev_key_in(95 downto 64);
					key_word10 <= prev_key_in(63 downto 32);
					key_word11 <= prev_key_in(31 downto 0);

					if (rot_word = '1') then
						key_word7(31 downto 8) <= current_key_in(23 downto 0);
						key_word7(7 downto 0)  <= current_key_in(31 downto 24);
					else 
						key_word7(31 downto 0) <= current_key_in(31 downto 0);
					end if;

					rcon_state <= rcon;

					--aes

					aes_states <= block_in xor prev_key_in;

					--mem
					if (rot_word = '1') then
						sbox_address <= current_key_in(23 downto 16);
					else
						sbox_address <= current_key_in(31 downto 24);
					end if;

				when state2 =>
					state <= state3;

					--key
					current_key_states <= current_key_states;

					key_word8 <= key_word8;
					key_word9 <= key_word9 xor key_word8;
					key_word10 <= key_word10;
					key_word11 <= key_word11;

					key_word7 <= key_word7;
						
					rcon_state <= rcon_state;
	
					--aes
					aes_states <= aes_states;

					--mem
					sbox_address <= key_word7(23 downto 16);

	
				when state3 =>
					state <= state4;
						
					--key
					current_key_states <= current_key_states;

					key_word8 <= key_word8;
					key_word9 <= key_word9;
					key_word10 <= key_word10 xor key_word9;
					key_word11 <= key_word11;
					
					key_word7(31 downto 24) <= sbox_data;
					key_word7(23 downto 0)  <= key_word7(23 downto 0);

					rcon_state <= rcon_state;
					
					--aes
					aes_states <= aes_states;

					--mem
					sbox_address <= key_word7(15 downto 8);

				when state4 =>
					state <= state5;

					--key
					current_key_states <= current_key_states;

					key_word8 <= key_word8;
					key_word9 <= key_word9;
					key_word10 <= key_word10;
					key_word11 <= key_word11 xor key_word10;

					key_word7(31 downto 24) <= key_word7(31 downto 24);
					key_word7(23 downto 16) <= sbox_data;
					key_word7(15 downto 0)  <= key_word7(15 downto 0);

					rcon_state <= rcon_state;

					--aes
					aes_states <= aes_states;					

					--mem
					sbox_address <= key_word7(7 downto 0);				

				when state5 =>
					state <= state6;

					--key
					current_key_states <= current_key_states;

					key_word8 <= key_word8;
					key_word9 <= key_word9;
					key_word10 <= key_word10;
					key_word11 <= key_word11;

					key_word7(31 downto 16) <= key_word7(31 downto 16);
					key_word7(15 downto 8)  <= sbox_data;
					key_word7(7 downto 0)   <= key_word7(7 downto 0);
					
					rcon_state <= rcon_state;

					--aes
					aes_states <= aes_states;
					
					--mem
					sbox_address <= aes_states(127 downto 120);				

				when state6 =>
					state <= state7;

					--key
					current_key_states <= current_key_states;
					
					w7_sub(31 downto 8) := key_word7(31 downto 8);
					w7_sub(7 downto 0)  := sbox_data;

					w7_sub(31 downto 24) := w7_sub(31 downto 24) xor rcon_state;

					key_states(127 downto 96) <= key_word8 xor w7_sub;
					key_states(95 downto 64)  <= key_word9 xor w7_sub;
					key_states(63 downto 32)  <= key_word10 xor w7_sub;
					key_states(31 downto 0)   <= key_word11 xor w7_sub;

					--aes
					
					
					--mem
					sbox_address <= aes_states(119 downto 112);
					
				when state7 =>
					state <= state8;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 120) <= sbox_data;
					aes_states(119 downto 0)   <= aes_states(119 downto 0);
					
					--mem
					sbox_address <= aes_states(111 downto 104);

				when state8 =>
					state <= state9;

					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 120) <= aes_states(127 downto 120);
					aes_states(119 downto 112) <= sbox_data;
					aes_states(111 downto 0)   <= aes_states(111 downto 0);
					
					--mem
					sbox_address <= aes_states(103 downto 96);


				when state9 =>
					state <= state10;

					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 112) <= aes_states(127 downto 112);
					aes_states(111 downto 104) <= sbox_data;
					aes_states(103 downto 0)   <= aes_states(103 downto 0);					

					--mem
					sbox_address <= aes_states(95 downto 88);

				when state10 =>
					state <= state11;

					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 104) <= aes_states(127 downto 104);
					aes_states(103 downto 96) <= sbox_data;
					aes_states(95 downto 0)   <= aes_states(95 downto 0);
					
					--mem
					sbox_address <= aes_states(87 downto 80);
	
				when state11 =>
					state <= state12;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 96) <= aes_states(127 downto 96);
					aes_states(95 downto 88)  <= sbox_data;
					aes_states(87 downto 0)   <= aes_states(87 downto 0);
					
					--mem
					sbox_address <= aes_states(79 downto 72);

				when state12 =>
					state <= state13;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 88) <= aes_states(127 downto 88);
					aes_states(87 downto 80)  <= sbox_data;
					aes_states(79 downto 0)   <= aes_states(79 downto 0);
					
					--mem
					sbox_address <= aes_states(71 downto 64);

				when state13 =>
					state <= state14;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 80) <= aes_states(127 downto 80);
					aes_states(79 downto 72)  <= sbox_data;
					aes_states(71 downto 0)   <= aes_states(71 downto 0);
					
					--mem
					sbox_address <= aes_states(63 downto 56);

				when state14 =>
					state <= state15;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 72) <= aes_states(127 downto 72);
					aes_states(71 downto 64)  <= sbox_data;
					aes_states(63 downto 0)   <= aes_states(63 downto 0);
					
					--mem
					sbox_address <= aes_states(55 downto 48);

				when state15 =>
					state <= state16;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 64) <= aes_states(127 downto 64);
					aes_states(63 downto 56)  <= sbox_data;
					aes_states(55 downto 0)   <= aes_states(55 downto 0);
					
					--mem
					sbox_address <= aes_states(47 downto 40);

				when state16 =>
					state <= state17;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 56) <= aes_states(127 downto 56);
					aes_states(55 downto 48)  <= sbox_data;
					aes_states(47 downto 0)   <= aes_states(47 downto 0);					

					--mem
					sbox_address <= aes_states(39 downto 32);

				when state17 =>
					state <= state18;
					
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 48) <= aes_states(127 downto 48);
					aes_states(47 downto 40)  <= sbox_data;
					aes_states(39 downto 0)   <= aes_states(39 downto 0);
					
					--mem
					sbox_address <= aes_states(31 downto 24);
						
				when state18 =>
					state <= state19;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 40) <= aes_states(127 downto 40);
					aes_states(39 downto 32)  <= sbox_data;
					aes_states(31 downto 0)   <= aes_states(31 downto 0);
					
					--mem
					sbox_address <= aes_states(23 downto 16);
					
				when state19 =>
					state <= state20;

					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 32) <= aes_states(127 downto 32);
					aes_states(31 downto 24)  <= sbox_data;
					aes_states(23 downto 0)   <= aes_states(23 downto 0);
					
					--mem
					sbox_address <= aes_states(15 downto 8);

				when state20 =>
					state <= state21;
					supply_block <= '1';
					collect_block <= '0';

					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 24) <= aes_states(127 downto 24);
					aes_states(23 downto 16)  <= sbox_data;
					aes_states(15 downto 0)   <= aes_states(15 downto 0);
					
					--mem
					sbox_address <= aes_states(7 downto 0);
					
	
				when state21 =>
					state <= state22;
	
					--key
					current_key_states <= current_key_states;
					key_states <= key_states;

					--aes
					aes_states(127 downto 16) <= aes_states(127 downto 16);
					aes_states(15 downto 8)  <= sbox_data;
					aes_states(7 downto 0)   <= aes_states(7 downto 0);
					
					--mem


				when state22 =>
					state <= state1;
	
					--key
					current_key_out <= current_key_states;
					next_key_out <= key_states;

					--aes
					last_state_temp(127 downto 8) := aes_states(127 downto 8);
					last_state_temp(7 downto 0)   := sbox_data;
					last_state_temp := shift_rows(last_state_temp);
					last_block_out  <= last_state_temp xor current_key_states;
					last_state_temp := mix_columns_b(mix_columns_a(last_state_temp));
					block_out       <= last_state_temp;
					
					--mem
	
			end case;
		end if;
	end process; 


end mroll_aes_round_1_14_impl;