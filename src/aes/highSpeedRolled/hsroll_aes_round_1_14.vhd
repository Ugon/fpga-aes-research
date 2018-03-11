library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.hsroll_aes_encryption_pipe.all;
use work.hsroll_aes_key_expansion_pipe.all;

entity hsroll_aes_round_1_14 is
	generic (
		block_bits             : Integer               := 128;
		round_number           : Integer range 1 to 13 := 1);
	port (
		main_clk                : in  std_logic;
		block_in                : in  std_logic_vector(block_bits - 1 downto 0);
		corresponding_round_key : in  std_logic_vector(block_bits - 1 downto 0);
		block_out               : out std_logic_vector(block_bits - 1 downto 0);

		last_round_key          : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		last_block_out          : out std_logic_vector(block_bits - 1 downto 0)
	);
end hsroll_aes_round_1_14;

architecture hsroll_aes_round_1_14_impl of hsroll_aes_round_1_14 is 

	signal hsroll_aenc_stage1_res: hsroll_aenc_pipe_1res;
	signal hsroll_aenc_stage2_res: hsroll_aenc_pipe_2res;
	signal hsroll_aenc_stage3_res: hsroll_aenc_pipe_3res;
	signal hsroll_aenc_stage4_res: hsroll_aenc_pipe_4res;
	signal hsroll_aenc_stage5_res: hsroll_aenc_pipe_5res;
	signal hsroll_aenc_stage6_res: hsroll_aenc_pipe_6res;
	signal hsroll_aenc_stage7_res: hsroll_aenc_pipe_7res;
	signal hsroll_aenc_stage8_res: hsroll_aenc_pipe_8res;
	signal hsroll_aenc_stage9_res: hsroll_aenc_pipe_9res;
	signal hsroll_aenc_stage10_res: hsroll_aenc_pipe_10res;
	signal hsroll_aenc_result:     std_logic_vector(127 downto 0);

begin
	
	process(main_clk) 
		variable hsroll_aenc_stage9_res_temp: hsroll_aenc_pipe_9res;
	begin

		if(rising_edge(main_clk)) then
			hsroll_aenc_stage1_res <= hsroll_aenc_pipe_stage1(block_in, corresponding_round_key);
			hsroll_aenc_stage2_res <= hsroll_aenc_pipe_stage2(hsroll_aenc_stage1_res);
			hsroll_aenc_stage3_res <= hsroll_aenc_pipe_stage3(hsroll_aenc_stage2_res);
			hsroll_aenc_stage4_res <= hsroll_aenc_pipe_stage4(hsroll_aenc_stage3_res);
			hsroll_aenc_stage5_res <= hsroll_aenc_pipe_stage5(hsroll_aenc_stage4_res);
			hsroll_aenc_stage6_res <= hsroll_aenc_pipe_stage6(hsroll_aenc_stage5_res);
			hsroll_aenc_stage7_res <= hsroll_aenc_pipe_stage7(hsroll_aenc_stage6_res);
			hsroll_aenc_stage8_res <= hsroll_aenc_pipe_stage8(hsroll_aenc_stage7_res);
			hsroll_aenc_stage9_res <= hsroll_aenc_pipe_stage9(hsroll_aenc_stage8_res);
			hsroll_aenc_stage10_res <= hsroll_aenc_pipe_stage10(hsroll_aenc_stage9_res);
			block_out              <= hsroll_aenc_pipe_stage11(hsroll_aenc_stage10_res);
			last_block_out         <= hsroll_aenc_stage9_res.state xor last_round_key;
		end if;
	end process;

end hsroll_aes_round_1_14_impl;