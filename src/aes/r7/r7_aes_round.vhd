library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity r7_aes_round is
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
end r7_aes_round;

architecture r7_aes_round_impl of r7_aes_round is 

	signal aenc_stage1_res: aenc_pipe_2res;
	signal aenc_stage2_res: aenc_pipe_4res;
	signal aenc_stage3_res: aenc_pipe_5res;
	signal aenc_stage4_res: aenc_pipe_7res;
	signal aenc_stage5_res: aenc_pipe_9res;

begin

	process(main_clk) begin
		if(rising_edge(main_clk)) then
			aenc_stage1_res <= aenc_pipe_stage2(aenc_pipe_stage1(block_in, prev_key_in));
			aenc_stage2_res <= aenc_pipe_stage4(aenc_pipe_stage3(aenc_stage1_res));
			aenc_stage3_res <= aenc_pipe_stage5(aenc_stage2_res);
			aenc_stage4_res <= aenc_pipe_stage7(aenc_pipe_stage6(aenc_stage3_res));
			aenc_stage5_res <= aenc_pipe_stage9(aenc_pipe_stage8(aenc_stage4_res));
			block_out       <= aenc_pipe_stage11(aenc_pipe_stage10(aenc_stage5_res));

			last_block_out  <= aenc_stage5_res.state xor last_key_in;
		end if;
	end process;

end r7_aes_round_impl;