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
		cyphertext    : out std_logic_vector(block_bits - 1 downto 0));
end aes256enc;

architecture aes256enc_impl of aes256enc is 
	signal aes_stage_1: aenc_pipe_1res;
	signal aes_stage_2: aenc_pipe_2res;
	signal aes_stage_3: aenc_pipe_3res;
	signal aes_stage_4: aenc_pipe_4res;
	signal aes_stage_5: aenc_pipe_5res;
	signal aes_result: std_logic_vector(127 downto 0);
	--signal stage_test: aenc_pipe_test_res;


	signal ake_stage_1: ake_pipe_1res;
	signal ake_stage_2: ake_pipe_2res;
	signal ake_stage_3: ake_pipe_3res;
	signal ake_stage_4: ake_pipe_4res;
	signal ake_stage_5: ake_pipe_5res;
	signal ake_result: ake_pipe_result;

	--signal key_1: std_logic_vector(127 downto 0);
	--signal key_2: std_logic_vector(127 downto 0);
	--signal key_3: std_logic_vector(127 downto 0);
	--signal key_4: std_logic_vector(127 downto 0);
	--signal key_5: std_logic_vector(127 downto 0);
	--signal key_6: std_logic_vector(127 downto 0);

begin

	--cyphertext <= aes_result;
	cyphertext <= aes_result xor ake_result.current_key;
	
			--stage_test    <= aenc_pipe_stage_test(aes_stage_5);
			--key_6 <= key_5;
	process(main_clk, plaintext) begin
		if(rising_edge(main_clk)) then
	
			--aes_stage_1 <= asb_5pipe_stage1(plaintext);
			--aes_stage_2 <= asb_5pipe_stage2(aes_stage_1);
			--aes_stage_3 <= asb_5pipe_stage3(aes_stage_2);
			--aes_stage_4 <= asb_5pipe_stage4(aes_stage_3);
			--cyphertext <= asb_5pipe_stage5(aes_stage_4);

			aes_stage_1    <= aenc_pipe_stage1(plaintext);
    		aes_stage_2    <= aenc_pipe_stage2(aes_stage_1);
			aes_stage_3    <= aenc_pipe_stage3(aes_stage_2);
			aes_stage_4    <= aenc_pipe_stage4(aes_stage_3);
			aes_stage_5    <= aenc_pipe_stage5(aes_stage_4);
			--cyphertext  <= aenc_pipe_stage5(aes_stage_4).state;

			ake_stage_1    <= ake_pipe_stage1(key(255 downto 128), key(127 downto 0), 3);
    		ake_stage_2    <= ake_pipe_stage2(ake_stage_1, 3);
			ake_stage_3    <= ake_pipe_stage3(ake_stage_2, 3);
			ake_stage_4    <= ake_pipe_stage4(ake_stage_3, 3);
			ake_stage_5    <= ake_pipe_stage5(ake_stage_4, 3);
			
	aes_result     <= aenc_pipe_stage6(aes_stage_5);--, ake_stage_5.current_key);
	ake_result     <= ake_pipe_stage6(ake_stage_5, 3);



			--key_1 <= key;
			--key_2 <= key_1;
			--key_3 <= key_2;
			--key_4 <= key_3;
			--key_5 <= key_4;

		end if;
	end process;
 
--	cyphertext <= encode256(plaintext, key_expansion);
--	cyphertext <= plaintext;

end aes256enc_impl;