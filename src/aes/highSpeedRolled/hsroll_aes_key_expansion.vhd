library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.hsroll_aes_encryption_pipe.all;
use work.hsroll_aes_key_expansion_pipe.all;

entity hsroll_aes_key_expansion is
	generic (
		block_bits                 : Integer               := 128);
	port (
		main_clk                : in  std_logic;
		prev_key_in             : in  std_logic_vector(block_bits - 1 downto 0) := (others => '0');
		current_key_in          : in  std_logic_vector(block_bits - 1 downto 0);
		
		current_key_out         : out std_logic_vector(block_bits - 1 downto 0);
		next_key_out            : out std_logic_vector(block_bits - 1 downto 0);
		last_key_out            : out std_logic_vector(block_bits - 1 downto 0);

		rot_en                  : in  std_logic;
		rcon_word               : in  std_logic_vector(7 downto 0)
	);
end hsroll_aes_key_expansion;

architecture hsroll_aes_key_expansion_impl of hsroll_aes_key_expansion is 

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
			hsroll_ake_stage1_res <= hsroll_ake_pipe_stage1(prev_key_in, current_key_in, rot_en);
			hsroll_ake_stage2_res <= hsroll_ake_pipe_stage2(hsroll_ake_stage1_res);
			hsroll_ake_stage3_res <= hsroll_ake_pipe_stage3(hsroll_ake_stage2_res);
			hsroll_ake_stage4_res <= hsroll_ake_pipe_stage4(hsroll_ake_stage3_res);
			hsroll_ake_stage5_res <= hsroll_ake_pipe_stage5(hsroll_ake_stage4_res);
			hsroll_ake_stage6_res <= hsroll_ake_pipe_stage6(hsroll_ake_stage5_res);
			hsroll_ake_stage7_res <= hsroll_ake_pipe_stage7(hsroll_ake_stage6_res);
			hsroll_ake_stage8_res <= hsroll_ake_pipe_stage8(hsroll_ake_stage7_res);
			hsroll_ake_stage9_res <= hsroll_ake_pipe_stage9(hsroll_ake_stage8_res, rcon_word);
			hsroll_ake_result     <= hsroll_ake_pipe_stage10(hsroll_ake_stage9_res);
	
			current_key_out       <= hsroll_ake_result.current_key;
			next_key_out          <= hsroll_ake_result.next_key;   
			last_key_out          <= hsroll_ake_stage8_res.current_key;
	
		end if;
	end process;

end hsroll_aes_key_expansion_impl;