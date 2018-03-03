library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_encryption_pipe.all;
use work.aes_key_expansion_pipe.all;

entity r7_aes_round_1 is
	generic (
		block_bits             : Integer               := 128);
	port (
		main_clk                : in  std_logic;
		block_in                : in  std_logic_vector(block_bits - 1 downto 0);
		corresponding_round_key : in  std_logic_vector(block_bits - 1 downto 0);
		block_out               : out std_logic_vector(block_bits - 1 downto 0)
	);
end r7_aes_round_1;

architecture r7_aes_round_1_impl of r7_aes_round_1 is 
	
	signal round_stage1_res: std_logic_vector(127 downto 0);
	signal round_stage2_res: std_logic_vector(127 downto 0);
	signal round_stage3_res: std_logic_vector(127 downto 0);
	signal round_stage4_res: std_logic_vector(127 downto 0);
	signal round_stage5_res: std_logic_vector(127 downto 0);
	signal round_result:     std_logic_vector(127 downto 0);

begin

	block_out <= round_result;

	process(main_clk) begin
		if(rising_edge(main_clk)) then
			round_stage1_res <= block_in;
			round_stage2_res <= round_stage1_res;
			round_stage3_res <= round_stage2_res;
			round_stage4_res <= round_stage3_res;
			round_stage5_res <= round_stage4_res;
			round_result     <= round_stage5_res xor corresponding_round_key;
		end if;
	end process;

end r7_aes_round_1_impl;