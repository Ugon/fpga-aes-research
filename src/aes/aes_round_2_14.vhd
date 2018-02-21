library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity aes_round_2_14 is
	generic (
		block_bits             : Integer               := 128;
		round_number           : Integer range 1 to 13 := 1);
	port (
		main_clk                : in  std_logic;
		--current_key             : in  std_logic_vector(block_bits - 1 downto 0);
		--next_key_in             : in  std_logic_vector(block_bits - 1 downto 0);
		block_in                : in  std_logic_vector(block_bits - 1 downto 0);
		corresponding_round_key : in  std_logic_vector(block_bits - 1 downto 0);
		
		--next_key_out            : out std_logic_vector(block_bits - 1 downto 0);
		--next_next_key           : out std_logic_vector(block_bits - 1 downto 0);
		block_out               : out std_logic_vector(block_bits - 1 downto 0)
	);
end aes_round_2_14;

architecture aes_round_2_14_impl of aes_round_2_14 is 

	signal aenc_stage1_res: aenc_pipe_1res;
	signal aenc_stage2_res: aenc_pipe_2res;
	signal aenc_stage3_res: aenc_pipe_3res;
	signal aenc_stage4_res: aenc_pipe_4res;
	signal aenc_stage5_res: aenc_pipe_5res;
	signal aenc_stage6_res: aenc_pipe_6res;
	signal aenc_stage7_res: aenc_pipe_7res;
	signal aenc_stage8_res: aenc_pipe_8res;
	signal aenc_stage9_res: aenc_pipe_9res;
	signal aenc_stage10_res: aenc_pipe_10res;
	signal aenc_result:     std_logic_vector(127 downto 0);

	--signal ake_stage1_res: ake_pipe_1res;
	--signal ake_stage2_res: ake_pipe_2res;
	--signal ake_stage3_res: ake_pipe_3res;
	--signal ake_stage4_res: ake_pipe_4res;
	--signal ake_stage5_res: ake_pipe_5res;
	--signal ake_result:     ake_pipe_result;

begin

	block_out     <= aenc_result;
	--block_out     <= ake_result.current_key xor aenc_result;
	--next_key_out  <= ake_result.next_key;
	--next_next_key <= ake_result.next_next_key;
	
	process(main_clk) begin
		if(rising_edge(main_clk)) then
			--ake_stage1_res <= ake_pipe_stage1(current_key, next_key_in, round_number + 2);
			--ake_stage2_res <= ake_pipe_stage2(ake_stage1_res, round_number + 2);
			--ake_stage3_res <= ake_pipe_stage3(ake_stage2_res, round_number + 2);
			--ake_stage4_res <= ake_pipe_stage4(ake_stage3_res, round_number + 2);
			--ake_stage5_res <= ake_pipe_stage5(ake_stage4_res, round_number + 2);
			--ake_result     <= ake_pipe_stage6(ake_stage5_res, round_number + 2);

			aenc_stage1_res <= aenc_pipe_stage1(block_in);
			aenc_stage2_res <= aenc_pipe_stage2(aenc_stage1_res);
			aenc_stage3_res <= aenc_pipe_stage3(aenc_stage2_res);
			aenc_stage4_res <= aenc_pipe_stage4(aenc_stage3_res);
			aenc_stage5_res <= aenc_pipe_stage5(aenc_stage4_res);
			aenc_stage6_res <= aenc_pipe_stage6(aenc_stage5_res);
			aenc_stage7_res <= aenc_pipe_stage7(aenc_stage6_res);
			aenc_stage8_res <= aenc_pipe_stage8(aenc_stage7_res);
			aenc_stage9_res <= aenc_pipe_stage9(aenc_stage8_res);
			aenc_stage10_res <= aenc_pipe_stage10(aenc_stage9_res);
			aenc_result     <= aenc_pipe_stage11(aenc_stage10_res, corresponding_round_key);
		end if;
	end process;

end aes_round_2_14_impl;