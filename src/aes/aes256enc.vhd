library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_transformations.all;
use work.aes_sub_bytes_5pipe.all;


entity aes256enc is
	generic (
		byte_bits          : Integer := 8;
		block_bytes        : Integer := 16;
		block_bits         : Integer := 128;
		key_bytes          : Integer := 32;
		key_expansion_bits : Integer := 15 * 128);
	port (
		main_clk      : in  std_logic;
		key_expansion : in  std_logic_vector(key_expansion_bits - 1 downto 0);
		plaintext     : in  std_logic_vector(block_bits - 1 downto 0);
		cyphertext    : out std_logic_vector(block_bits - 1 downto 0));
end aes256enc;

architecture aes256enc_impl of aes256enc is 
	signal stage_0: std_logic_vector(127 downto 0);
	signal stage_1: asb_5pipe_1res;
	signal stage_2: asb_5pipe_2res;
	signal stage_3: asb_5pipe_3res;
	signal stage_4: asb_5pipe_4res;
	signal stage_5: std_logic_vector(127 downto 0);
	signal stage_6: std_logic_vector(127 downto 0);
	signal stage_7: std_logic_vector(127 downto 0);
	signal stage_8: std_logic_vector(127 downto 0);
	signal stage_9: std_logic_vector(127 downto 0);


begin

	process(main_clk, plaintext) begin
		if(rising_edge(main_clk)) then
			stage_1 <= asb_5pipe_stage1(plaintext);
			stage_2 <= asb_5pipe_stage2(stage_1);
			stage_3 <= asb_5pipe_stage3(stage_2);
			stage_4 <= asb_5pipe_stage4(stage_3);
			cyphertext <= asb_5pipe_stage5(stage_4);
		end if;
	end process;

--	cyphertext <= encode256(plaintext, key_expansion);
--	cyphertext <= plaintext;

end aes256enc_impl;