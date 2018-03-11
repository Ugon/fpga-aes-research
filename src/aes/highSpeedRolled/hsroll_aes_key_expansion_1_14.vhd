library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.hsroll_aes_encryption_pipe.all;
use work.hsroll_aes_key_expansion_pipe.all;

entity hsroll_aes_key_expansion_1_14 is
	generic (
		block_bits                 : Integer               := 128;
		corresponding_round_number : Integer range 1 to 13 := 1);
	port (
		main_clk                : in  std_logic;
		current_key             : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		next_key_in             : in  std_logic_vector(block_bits - 1 downto 0);
		
		next_key_out            : out std_logic_vector(block_bits - 1 downto 0);
		next_next_key           : out std_logic_vector(block_bits - 1 downto 0);
		last_next_key_out       : out std_logic_vector(block_bits - 1 downto 0)
	);
end hsroll_aes_key_expansion_1_14;

architecture hsroll_aes_key_expansion_1_14_impl of hsroll_aes_key_expansion_1_14 is 

	signal hsroll_ake_stage1_res: hsroll_ake_pipe_1res;
	signal hsroll_ake_stage2_res: hsroll_ake_pipe_2res;
	signal hsroll_ake_stage3_res: hsroll_ake_pipe_3res;
	signal hsroll_ake_stage4_res: hsroll_ake_pipe_4res;
	signal hsroll_ake_stage5_res: hsroll_ake_pipe_5res;
	signal hsroll_ake_stage6_res: hsroll_ake_pipe_6res;
	signal hsroll_ake_stage7_res: hsroll_ake_pipe_7res;
	signal hsroll_ake_stage8_res: hsroll_ake_pipe_8res;
	signal hsroll_ake_stage9_res: hsroll_ake_pipe_9res;
	signal hsroll_ake_result:     hsroll_ake_pipe_result;

	signal aes_pre_key_result: std_logic_vector(127 downto 0);

begin

	process(main_clk) begin
		if(rising_edge(main_clk)) then
			hsroll_ake_stage1_res <= hsroll_ake_pipe_stage1(current_key, next_key_in, corresponding_round_number + 2);
			hsroll_ake_stage2_res <= hsroll_ake_pipe_stage2(hsroll_ake_stage1_res, corresponding_round_number + 2);
			hsroll_ake_stage3_res <= hsroll_ake_pipe_stage3(hsroll_ake_stage2_res, corresponding_round_number + 2);
			hsroll_ake_stage4_res <= hsroll_ake_pipe_stage4(hsroll_ake_stage3_res, corresponding_round_number + 2);
			hsroll_ake_stage5_res <= hsroll_ake_pipe_stage5(hsroll_ake_stage4_res, corresponding_round_number + 2);
			hsroll_ake_stage6_res <= hsroll_ake_pipe_stage6(hsroll_ake_stage5_res, corresponding_round_number + 2);
			hsroll_ake_stage7_res <= hsroll_ake_pipe_stage7(hsroll_ake_stage6_res, corresponding_round_number + 2);
			hsroll_ake_stage8_res <= hsroll_ake_pipe_stage8(hsroll_ake_stage7_res, corresponding_round_number + 2);
			hsroll_ake_stage9_res <= hsroll_ake_pipe_stage9(hsroll_ake_stage8_res, corresponding_round_number + 2);
			hsroll_ake_result     <= hsroll_ake_pipe_stage10(hsroll_ake_stage9_res, corresponding_round_number + 2);
	
			next_key_out          <= hsroll_ake_result.next_key;
			next_next_key         <= hsroll_ake_result.next_next_key;
			last_next_key_out     <= hsroll_ake_stage8_res.next_key;
	
		end if;
	end process;

end hsroll_aes_key_expansion_1_14_impl;