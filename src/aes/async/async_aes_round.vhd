library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity async_aes_round is
	generic (
		block_bits     : Integer := 128);
	port (
		main_clk       : in  std_logic;
		block_in       : in  std_logic_vector(block_bits - 1 downto 0);
		prev_key_in    : in  std_logic_vector(block_bits - 1 downto 0);
		block_out      : out std_logic_vector(block_bits - 1 downto 0);

		last_key_in    : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		last_block_out : out std_logic_vector(block_bits - 1 downto 0)
	);
end async_aes_round;

architecture async_aes_round_impl of async_aes_round is 

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

begin

	aenc_stage1_res  <= aenc_pipe_stage1(block_in, prev_key_in);
	aenc_stage2_res  <= aenc_pipe_stage2(aenc_stage1_res);
	aenc_stage3_res  <= aenc_pipe_stage3(aenc_stage2_res);
	aenc_stage4_res  <= aenc_pipe_stage4(aenc_stage3_res);
	aenc_stage5_res  <= aenc_pipe_stage5(aenc_stage4_res);
	aenc_stage6_res  <= aenc_pipe_stage6(aenc_stage5_res);
	aenc_stage7_res  <= aenc_pipe_stage7(aenc_stage6_res);
	aenc_stage8_res  <= aenc_pipe_stage8(aenc_stage7_res);
	aenc_stage9_res  <= aenc_pipe_stage9(aenc_stage8_res);
	aenc_stage10_res <= aenc_pipe_stage10(aenc_stage9_res);
	block_out        <= aenc_pipe_stage11(aenc_stage10_res);

	last_block_out   <= aenc_stage9_res.state xor last_key_in;

end async_aes_round_impl;