library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity hs_aes_key_expansion_15 is
	generic (
		block_bits                 : Integer               := 128);
	port (
		main_clk                : in  std_logic;
		current_key             : in  std_logic_vector(block_bits - 1 downto 0);
		
		corresponding_round_key : out std_logic_vector(block_bits - 1 downto 0)
	);
end hs_aes_key_expansion_15;

architecture hs_aes_key_expansion_15_impl of hs_aes_key_expansion_15 is 

	signal ake_stage1_a: std_logic_vector(127 downto 0);
	signal ake_stage2_a: std_logic_vector(127 downto 0);
	signal ake_stage3_a: std_logic_vector(127 downto 0);
	signal ake_stage4_a: std_logic_vector(127 downto 0);
	signal ake_stage5_a: std_logic_vector(127 downto 0);
	signal ake_stage6_a: std_logic_vector(127 downto 0);
	signal ake_stage7_a: std_logic_vector(127 downto 0);
	signal ake_stage8_a: std_logic_vector(127 downto 0);

begin
	
	process(main_clk) begin
		if(rising_edge(main_clk)) then
			ake_stage1_a <= current_key;
			ake_stage2_a <= ake_stage1_a;
			ake_stage3_a <= ake_stage2_a;
			ake_stage4_a <= ake_stage3_a;
			ake_stage5_a <= ake_stage4_a;
			ake_stage6_a <= ake_stage5_a;
			ake_stage7_a <= ake_stage6_a;
			ake_stage8_a <= ake_stage7_a;
			corresponding_round_key <= ake_stage8_a;
		end if;
	end process;

end hs_aes_key_expansion_15_impl;