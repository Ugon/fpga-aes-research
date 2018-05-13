library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity hs_aes_round is
	generic (
		block_bits          : Integer := 128);
	port (
		main_clk            : in  std_logic;
		block_in            : in  std_logic_vector(block_bits - 1 downto 0);
		prev_key_in         : in  std_logic_vector(block_bits - 1 downto 0);
		block_out           : out std_logic_vector(block_bits - 1 downto 0);

		last_key_in         : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		last_block_out      : out std_logic_vector(block_bits - 1 downto 0);
		last_block_fast_out : out std_logic_vector(block_bits - 1 downto 0)
	);
end hs_aes_round;

architecture hs_aes_round_impl of hs_aes_round is 

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

	signal blk_lst_out_buf: std_logic_vector(127 downto 0);

begin
	
	process(main_clk) 
		variable aenc_stage9_res_temp: aenc_pipe_9res;
		variable blk_lst_out: std_logic_vector(127 downto 0);
	begin
		if(rising_edge(main_clk)) then
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
			
			blk_lst_out         := aenc_stage9_res.state xor last_key_in;
			last_block_fast_out <= blk_lst_out;
			blk_lst_out_buf     <= blk_lst_out;
			last_block_out      <= blk_lst_out_buf;

		end if;
	end process;

end hs_aes_round_impl;