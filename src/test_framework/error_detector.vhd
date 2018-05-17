library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity error_detector is
	generic (
		ROM_WIDTH      : Integer := 128);
	port (
		main_clk       : in  std_logic;
		started        : in  std_logic;
		
		detect         : in  std_logic := '1';
		data           : in  std_logic_vector(ROM_WIDTH - 1 downto 0);
		expected       : in  std_logic_vector(ROM_WIDTH - 1 downto 0);
		
		error_detected : out std_logic
	);
end error_detector;

architecture error_detector_impl of error_detector is 
	signal xored       : std_logic_vector(ROM_WIDTH - 1 downto 0) := (others => '0');
	signal data_reg    : std_logic_vector(ROM_WIDTH - 1 downto 0) := (others => '0');
	signal expected_reg: std_logic_vector(ROM_WIDTH - 1 downto 0) := (others => '0');
	signal detect_reg  : std_logic                                := '1';
begin

	error_detected <= or_reduce(xored);

	process(main_clk, data, expected) begin
		if (rising_edge(main_clk)) then
			data_reg <= data;
			expected_reg <= expected;
			detect_reg <= detect;
		end if;
	end process;

	gen_check: for i in ROM_WIDTH - 1 downto 0 generate
		process(main_clk, data_reg(i), expected_reg(i), started) begin
			if (started = '0') then
				xored(i) <= '0';
			elsif (rising_edge(main_clk)) then
				if ((data_reg(i) xor expected_reg(i))) then 
					xored(i) <= xored(i) or detect_reg;
				end if;
			end if;
		end process;
	end generate;

end error_detector_impl;