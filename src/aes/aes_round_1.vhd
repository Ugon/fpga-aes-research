library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity aes_round_1 is
	generic (
		block_bits             : Integer               := 128;
		next_next_round_number : Integer range 3 to 15 := 3);
	port (
		main_clk      : in  std_logic;
		current_key   : in  std_logic_vector(block_bits - 1 downto 0);
		next_key_in   : in  std_logic_vector(block_bits - 1 downto 0);
		block_in      : in  std_logic_vector(block_bits - 1 downto 0);
		
		next_key_out  : out std_logic_vector(block_bits - 1 downto 0);
		next_next_key : out std_logic_vector(block_bits - 1 downto 0);
		block_out     : out std_logic_vector(block_bits - 1 downto 0)
	);
end aes_round_1;

architecture aes_round_1_impl of aes_round_1 is 
	signal round_stage1_res: std_logic_vector(127 downto 0);
	signal round_stage2_res: std_logic_vector(127 downto 0);
	signal round_stage3_res: std_logic_vector(127 downto 0);
	signal round_stage4_res: std_logic_vector(127 downto 0);
	signal round_stage5_res: std_logic_vector(127 downto 0);
	signal round_result:     std_logic_vector(127 downto 0);

	signal ake_stage1_res: ake_pipe_1res;
	signal ake_stage2_res: ake_pipe_2res;
	signal ake_stage3_res: ake_pipe_3res;
	signal ake_stage4_res: ake_pipe_4res;
	signal ake_stage5_res: ake_pipe_5res;
	signal ake_result:     ake_pipe_result;

	signal aes_pre_key_result: std_logic_vector(127 downto 0);


begin

	block_out     <= round_result;
	next_key_out  <= ake_result.next_key;
	next_next_key <= ake_result.next_next_key;
	
	process(main_clk) begin
		if(rising_edge(main_clk)) then
			ake_stage1_res <= ake_pipe_stage1(current_key, next_key_in, next_next_round_number);
			ake_stage2_res <= ake_pipe_stage2(ake_stage1_res, next_next_round_number);
			ake_stage3_res <= ake_pipe_stage3(ake_stage2_res, next_next_round_number);
			ake_stage4_res <= ake_pipe_stage4(ake_stage3_res, next_next_round_number);
			ake_stage5_res <= ake_pipe_stage5(ake_stage4_res, next_next_round_number);
			ake_result     <= ake_pipe_stage6(ake_stage5_res, next_next_round_number);

			round_stage1_res <= block_in;
			round_stage2_res <= round_stage1_res;
			round_stage3_res <= round_stage2_res;
			round_stage4_res <= round_stage3_res xor ake_stage3_res.current_key;
			round_stage5_res <= round_stage4_res;
			round_result     <= round_stage5_res;
		end if;
	end process;

end aes_round_1_impl;