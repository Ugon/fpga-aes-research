library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity aes_round_14 is
	generic (
		block_bits             : Integer               := 128);
	port (
		main_clk      : in  std_logic;
		current_key   : in  std_logic_vector(block_bits - 1 downto 0);
		next_key_in   : in  std_logic_vector(block_bits - 1 downto 0);
		block_in      : in  std_logic_vector(block_bits - 1 downto 0);
		
		next_key_out  : out std_logic_vector(block_bits - 1 downto 0);
		block_out     : out std_logic_vector(block_bits - 1 downto 0)
	);
end aes_round_14;

architecture aes_round_14_impl of aes_round_14 is 

	signal aenc_stage1_res: aenc_pipe_1res;
	signal aenc_stage2_res: aenc_pipe_2res;
	signal aenc_stage3_res: aenc_pipe_3res;
	signal aenc_stage4_res: aenc_pipe_4res;
	signal aenc_stage5_res: aenc_pipe_5res;
	signal aenc_result:     std_logic_vector(127 downto 0);

	signal current_key_stage1: std_logic_vector(127 downto 0);
	signal current_key_stage2: std_logic_vector(127 downto 0);
	signal current_key_stage3: std_logic_vector(127 downto 0);
	signal current_key_stage4: std_logic_vector(127 downto 0);
	signal current_key_stage5: std_logic_vector(127 downto 0);
	signal current_key_result: std_logic_vector(127 downto 0);

	signal next_key_stage1: std_logic_vector(127 downto 0);
	signal next_key_stage2: std_logic_vector(127 downto 0);
	signal next_key_stage3: std_logic_vector(127 downto 0);
	signal next_key_stage4: std_logic_vector(127 downto 0);
	signal next_key_stage5: std_logic_vector(127 downto 0);
	signal next_key_result: std_logic_vector(127 downto 0);

begin

	block_out     <= current_key_result xor aenc_result;
	next_key_out  <= next_key_result;
	
	process(main_clk) begin
		if(rising_edge(main_clk)) then
			current_key_stage1 <= current_key;
			current_key_stage2 <= current_key_stage1;
			current_key_stage3 <= current_key_stage2;
			current_key_stage4 <= current_key_stage3;
			current_key_stage5 <= current_key_stage4;
			current_key_result <= current_key_stage5;

			next_key_stage1 <= next_key_in;
			next_key_stage2 <= next_key_stage1;
			next_key_stage3 <= next_key_stage2;
			next_key_stage4 <= next_key_stage3;
			next_key_stage5 <= next_key_stage4;
			next_key_result <= next_key_stage5;

			aenc_stage1_res <= aenc_pipe_stage1(block_in);
			aenc_stage2_res <= aenc_pipe_stage2(aenc_stage1_res);
			aenc_stage3_res <= aenc_pipe_stage3(aenc_stage2_res);
			aenc_stage4_res <= aenc_pipe_stage4(aenc_stage3_res);
			aenc_stage5_res <= aenc_pipe_stage5(aenc_stage4_res);
			aenc_result     <= aenc_pipe_stage6(aenc_stage5_res);
		end if;
	end process;

end aes_round_14_impl;