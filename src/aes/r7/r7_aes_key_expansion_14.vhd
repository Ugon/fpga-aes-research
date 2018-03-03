library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity r7_aes_key_expansion_14 is
	generic (
		block_bits                 : Integer               := 128);
	port (
		main_clk                : in  std_logic;
		current_key             : in  std_logic_vector(block_bits - 1 downto 0);
		next_key_in             : in  std_logic_vector(block_bits - 1 downto 0);
		
		corresponding_round_key : out std_logic_vector(block_bits - 1 downto 0);
		next_key_out            : out std_logic_vector(block_bits - 1 downto 0)
	);
end r7_aes_key_expansion_14;

architecture r7_aes_key_expansion_14_impl of r7_aes_key_expansion_14 is 

	signal ake_stage1_a: std_logic_vector(127 downto 0);
	signal ake_stage2_a: std_logic_vector(127 downto 0);
	signal ake_stage3_a: std_logic_vector(127 downto 0);
	signal ake_stage4_a: std_logic_vector(127 downto 0);

	signal ake_stage1_b: std_logic_vector(127 downto 0);
	signal ake_stage2_b: std_logic_vector(127 downto 0);
	signal ake_stage3_b: std_logic_vector(127 downto 0);
	signal ake_stage4_b: std_logic_vector(127 downto 0);
	signal ake_stage5_b: std_logic_vector(127 downto 0);

begin
	
	process(main_clk) begin
		if(rising_edge(main_clk)) then
			ake_stage1_a <= current_key;
			ake_stage2_a <= ake_stage1_a;
			ake_stage3_a <= ake_stage2_a;
			ake_stage4_a <= ake_stage3_a;
			corresponding_round_key <= ake_stage4_a;

			ake_stage1_b <= next_key_in;
			ake_stage2_b <= ake_stage1_b;
			ake_stage3_b <= ake_stage2_b;
			ake_stage4_b <= ake_stage3_b;
			ake_stage5_b <= ake_stage4_b;
			next_key_out <= ake_stage5_b;

		end if;
	end process;

end r7_aes_key_expansion_14_impl;