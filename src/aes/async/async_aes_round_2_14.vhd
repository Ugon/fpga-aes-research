library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity async_aes_round_2_14 is
	generic (
		block_bits             : Integer               := 128;
		round_number           : Integer range 1 to 13 := 1);
	port (
		main_clk                : in  std_logic;
		block_in                : in  std_logic_vector(block_bits - 1 downto 0);
		corresponding_round_key : in  std_logic_vector(block_bits - 1 downto 0);
		block_out               : out std_logic_vector(block_bits - 1 downto 0)
	);
end async_aes_round_2_14;

architecture async_aes_round_2_14_impl of async_aes_round_2_14 is 

	signal aenc_stage1_res: aenc_pipe_2res;
	signal aenc_stage2_res: aenc_pipe_4res;
	signal aenc_stage3_res: aenc_pipe_5res;
	signal aenc_stage4_res: aenc_pipe_7res;
	signal aenc_stage5_res: aenc_pipe_9res;
	signal aenc_result:     std_logic_vector(127 downto 0);

begin

	aenc_stage1_res <= aenc_pipe_stage2(aenc_pipe_stage1(block_in));
	aenc_stage2_res <= aenc_pipe_stage4(aenc_pipe_stage3(aenc_stage1_res));
	aenc_stage3_res <= aenc_pipe_stage5(aenc_stage2_res);
	aenc_stage4_res <= aenc_pipe_stage7(aenc_pipe_stage6(aenc_stage3_res));
	aenc_stage5_res <= aenc_pipe_stage9(aenc_pipe_stage8(aenc_stage4_res));
	aenc_result     <= aenc_pipe_stage11(aenc_pipe_stage10(aenc_stage5_res), corresponding_round_key);

	block_out <= aenc_result;

end async_aes_round_2_14_impl;