library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity r7_aes_key_expansion is
	generic (
		block_bits      : Integer := 128);
	port (
		main_clk        : in  std_logic;
		prev_key_in     : in  std_logic_vector(block_bits - 1 downto 0);
		current_key_in  : in  std_logic_vector(block_bits - 1 downto 0);
		
		current_key_out : out std_logic_vector(block_bits - 1 downto 0);
		next_key_out    : out std_logic_vector(block_bits - 1 downto 0);
		last_key_out    : out std_logic_vector(block_bits - 1 downto 0);

		rot_en          : in  std_logic;
		rcon_word       : in  std_logic_vector(7 downto 0)
	);
end r7_aes_key_expansion;

architecture r7_aes_key_expansion_impl of r7_aes_key_expansion is 

	signal ake_stage1_res: ake_pipe_2res;
	signal ake_stage2_res: ake_pipe_4res;
	signal ake_stage3_res: ake_pipe_5res;
	signal ake_stage4_res: ake_pipe_7res;
	signal ake_stage5_res: ake_pipe_9res;

begin

	process(main_clk) 
		variable ake_result: ake_pipe_result;
	begin
		if(rising_edge(main_clk)) then
			ake_stage1_res <= ake_pipe_stage2(ake_pipe_stage1(prev_key_in, current_key_in, rot_en));
			ake_stage2_res <= ake_pipe_stage4(ake_pipe_stage3(ake_stage1_res));
			ake_stage3_res <= ake_pipe_stage5(ake_stage2_res);
			ake_stage4_res <= ake_pipe_stage7(ake_pipe_stage6(ake_stage3_res));
			
			last_key_out   <= ake_stage4_res.current_key;
			ake_stage5_res <= ake_pipe_stage9(ake_pipe_stage8(ake_stage4_res), rcon_word);
			
			ake_result      := ake_pipe_stage10(ake_stage5_res);
			current_key_out <= ake_result.current_key;
			next_key_out    <= ake_result.next_key;

		end if;
	end process;

end r7_aes_key_expansion_impl;