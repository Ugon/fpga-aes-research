library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_utils.all;

entity error_detector is
	generic (
		ROM_WIDTH      : Integer := 128);
	port (
		main_clk       : in  std_logic;
		started        : in  std_logic;
		
		data           : in  std_logic_vector(ROM_WIDTH - 1 downto 0);
		expected       : in  std_logic_vector(ROM_WIDTH - 1 downto 0);
		
		error_detected : out std_logic);
end error_detector;

architecture error_detector_impl of error_detector is 
	signal xored       : std_logic_vector(ROM_WIDTH - 1 downto 0) := (others => '0');
	signal data_reg    : std_logic_vector(ROM_WIDTH - 1 downto 0) := (others => '0');
	signal expected_reg: std_logic_vector(ROM_WIDTH - 1 downto 0) := (others => '0');
begin

	error_detected <= or_reduce(xored);

	process(main_clk, data, expected) begin
		if (rising_edge(main_clk)) then
			data_reg <= data;
			expected_reg <= expected;
		end if;
	end process;

	gen_check: for i in ROM_WIDTH - 1 downto 0 generate
		process(main_clk, data_reg(i), expected_reg(i)) begin
			if (started = '0') then
				xored(i) <= '0';
			elsif (rising_edge(main_clk)) then
				if (data_reg(i) xor expected_reg(i)) then 
					xored(i) <= '1';
				end if;
			end if;
		end process;
	end generate;

end error_detector_impl;