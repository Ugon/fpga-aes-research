library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_sub_bytes.all;
use work.aes_key_expansion.all;
use work.aes_utils.all;


entity aes_key_expansion_test is
port (
	clk:     in  std_logic;
	inp_key: in  std_logic_vector(255 downto 0);
	
	round1_key:  out std_logic_vector(127 downto 0);
	round2_key:  out std_logic_vector(127 downto 0);
	round3_key:  out std_logic_vector(127 downto 0);
	round4_key:  out std_logic_vector(127 downto 0);
	round5_key:  out std_logic_vector(127 downto 0);
	round6_key:  out std_logic_vector(127 downto 0);
	round7_key:  out std_logic_vector(127 downto 0);
	round8_key:  out std_logic_vector(127 downto 0);
	round9_key:  out std_logic_vector(127 downto 0);
	round10_key: out std_logic_vector(127 downto 0);
	round11_key: out std_logic_vector(127 downto 0);
	round12_key: out std_logic_vector(127 downto 0);
	round13_key: out std_logic_vector(127 downto 0);
	round14_key: out std_logic_vector(127 downto 0);
	round15_key: out std_logic_vector(127 downto 0);

	round1_key_exp:  in std_logic_vector(127 downto 0);
	round2_key_exp:  in std_logic_vector(127 downto 0);
	round3_key_exp:  in std_logic_vector(127 downto 0);
	round4_key_exp:  in std_logic_vector(127 downto 0);
	round5_key_exp:  in std_logic_vector(127 downto 0);
	round6_key_exp:  in std_logic_vector(127 downto 0);
	round7_key_exp:  in std_logic_vector(127 downto 0);
	round8_key_exp:  in std_logic_vector(127 downto 0);
	round9_key_exp:  in std_logic_vector(127 downto 0);
	round10_key_exp: in std_logic_vector(127 downto 0);
	round11_key_exp: in std_logic_vector(127 downto 0);
	round12_key_exp: in std_logic_vector(127 downto 0);
	round13_key_exp: in std_logic_vector(127 downto 0);
	round14_key_exp: in std_logic_vector(127 downto 0);
	round15_key_exp: in std_logic_vector(127 downto 0);

	round1_eq:  out std_logic;
	round2_eq:  out std_logic;
	round3_eq:  out std_logic;
	round4_eq:  out std_logic;
	round5_eq:  out std_logic;
	round6_eq:  out std_logic;
	round7_eq:  out std_logic;
	round8_eq:  out std_logic;
	round9_eq:  out std_logic;
	round10_eq: out std_logic;
	round11_eq: out std_logic;
	round12_eq: out std_logic;
	round13_eq: out std_logic;
	round14_eq: out std_logic;
	round15_eq: out std_logic
);
end entity aes_key_expansion_test;

architecture rtl of aes_key_expansion_test is
	signal r3_key: std_logic_vector(127 downto 0);
	signal r4_key: std_logic_vector(127 downto 0);
	signal r5_key: std_logic_vector(127 downto 0);
	signal r6_key: std_logic_vector(127 downto 0);
	signal r7_key: std_logic_vector(127 downto 0);
	signal r8_key: std_logic_vector(127 downto 0);
	signal r9_key: std_logic_vector(127 downto 0);
	signal r10_key: std_logic_vector(127 downto 0);
	signal r11_key: std_logic_vector(127 downto 0);
	signal r12_key: std_logic_vector(127 downto 0);
	signal r13_key: std_logic_vector(127 downto 0);
	signal r14_key: std_logic_vector(127 downto 0);
	signal r15_key: std_logic_vector(127 downto 0);

	signal r1_key_latched_current: std_logic_vector(127 downto 0);
	signal r2_key_latched_current: std_logic_vector(127 downto 0);
	signal r3_key_latched_current: std_logic_vector(127 downto 0);
	signal r4_key_latched_current: std_logic_vector(127 downto 0);
	signal r5_key_latched_current: std_logic_vector(127 downto 0);
	signal r6_key_latched_current: std_logic_vector(127 downto 0);
	signal r7_key_latched_current: std_logic_vector(127 downto 0);
	signal r8_key_latched_current: std_logic_vector(127 downto 0);
	signal r9_key_latched_current: std_logic_vector(127 downto 0);
	signal r10_key_latched_current: std_logic_vector(127 downto 0);
	signal r11_key_latched_current: std_logic_vector(127 downto 0);
	signal r12_key_latched_current: std_logic_vector(127 downto 0);
	signal r13_key_latched_current: std_logic_vector(127 downto 0);
	signal r14_key_latched_current: std_logic_vector(127 downto 0);
	signal r15_key_latched_current: std_logic_vector(127 downto 0);

	signal r2_key_latched_next: std_logic_vector(127 downto 0);
	signal r3_key_latched_next: std_logic_vector(127 downto 0);
	signal r4_key_latched_next: std_logic_vector(127 downto 0);
	signal r5_key_latched_next: std_logic_vector(127 downto 0);
	signal r6_key_latched_next: std_logic_vector(127 downto 0);
	signal r7_key_latched_next: std_logic_vector(127 downto 0);
	signal r8_key_latched_next: std_logic_vector(127 downto 0);
	signal r9_key_latched_next: std_logic_vector(127 downto 0);
	signal r10_key_latched_next: std_logic_vector(127 downto 0);
	signal r11_key_latched_next: std_logic_vector(127 downto 0);
	signal r12_key_latched_next: std_logic_vector(127 downto 0);
	signal r13_key_latched_next: std_logic_vector(127 downto 0);
	signal r14_key_latched_next: std_logic_vector(127 downto 0);
	signal r15_key_latched_next: std_logic_vector(127 downto 0);
begin
	
	expand_round_rsr(r1_key_latched_current,  r2_key_latched_next,  r3_key,   3);
	expand_round_s  (r2_key_latched_current,  r3_key_latched_next,  r4_key     );
	expand_round_rsr(r3_key_latched_current,  r4_key_latched_next,  r5_key,   5);
	expand_round_s  (r4_key_latched_current,  r5_key_latched_next,  r6_key     );
	expand_round_rsr(r5_key_latched_current,  r6_key_latched_next,  r7_key,   7);
	expand_round_s  (r6_key_latched_current,  r7_key_latched_next,  r8_key     );
	expand_round_rsr(r7_key_latched_current,  r8_key_latched_next,  r9_key,   9);
	expand_round_s  (r8_key_latched_current,  r9_key_latched_next,  r10_key    );
	expand_round_rsr(r9_key_latched_current,  r10_key_latched_next, r11_key, 11);
	expand_round_s  (r10_key_latched_current, r11_key_latched_next, r12_key    );
	expand_round_rsr(r11_key_latched_current, r12_key_latched_next, r13_key, 13);
	expand_round_s  (r12_key_latched_current, r13_key_latched_next, r14_key    );
	expand_round_rsr(r13_key_latched_current, r14_key_latched_next, r15_key, 15);

	round1_key <= r1_key_latched_current;
	round2_key <= r2_key_latched_current;
	round3_key <= r3_key_latched_current;
	round4_key <= r4_key_latched_current;
	round5_key <= r5_key_latched_current;
	round6_key <= r6_key_latched_current;
	round7_key <= r7_key_latched_current;
	round8_key <= r8_key_latched_current;
	round9_key <= r9_key_latched_current;
	round10_key <= r10_key_latched_current;
	round11_key <= r11_key_latched_current;
	round12_key <= r12_key_latched_current;
	round13_key <= r13_key_latched_current;
	round14_key <= r14_key_latched_current;
	round15_key <= r15_key_latched_current;

	round1_eq <= '1' when r1_key_latched_current = round1_key_exp else '0';
	round2_eq <= '1' when r2_key_latched_current = round2_key_exp else '0';
	round3_eq <= '1' when r3_key_latched_current = round3_key_exp else '0';
	round4_eq <= '1' when r4_key_latched_current = round4_key_exp else '0';
	round5_eq <= '1' when r5_key_latched_current = round5_key_exp else '0';
	round6_eq <= '1' when r6_key_latched_current = round6_key_exp else '0';
	round7_eq <= '1' when r7_key_latched_current = round7_key_exp else '0';
	round8_eq <= '1' when r8_key_latched_current = round8_key_exp else '0';
	round9_eq <= '1' when r9_key_latched_current = round9_key_exp else '0';
	round10_eq <= '1' when r10_key_latched_current = round10_key_exp else '0';
	round11_eq <= '1' when r11_key_latched_current = round11_key_exp else '0';
	round12_eq <= '1' when r12_key_latched_current = round12_key_exp else '0';
	round13_eq <= '1' when r13_key_latched_current = round13_key_exp else '0';
	round14_eq <= '1' when r14_key_latched_current = round14_key_exp else '0';
	round15_eq <= '1' when r15_key_latched_current = round15_key_exp else '0';

	process(clk) begin
		if (rising_edge(clk)) then
			r1_key_latched_current <= inp_key(255 downto 128);
			r2_key_latched_current <= r2_key_latched_next;
			r3_key_latched_current <= r3_key_latched_next;
			r4_key_latched_current <= r4_key_latched_next;
			r5_key_latched_current <= r5_key_latched_next;
			r6_key_latched_current <= r6_key_latched_next;
			r7_key_latched_current <= r7_key_latched_next;
			r8_key_latched_current <= r8_key_latched_next;
			r9_key_latched_current <= r9_key_latched_next;
			r10_key_latched_current <= r10_key_latched_next;
			r11_key_latched_current <= r11_key_latched_next;
			r12_key_latched_current <= r12_key_latched_next;
			r13_key_latched_current <= r13_key_latched_next;
			r14_key_latched_current <= r14_key_latched_next;
			r15_key_latched_current <= r15_key_latched_next;

			r2_key_latched_next <= inp_key(127 downto 0);
			r3_key_latched_next <= r3_key;
			r4_key_latched_next <= r4_key;
			r5_key_latched_next <= r5_key;
			r6_key_latched_next <= r6_key;
			r7_key_latched_next <= r7_key;
			r8_key_latched_next <= r8_key;
			r9_key_latched_next <= r9_key;
			r10_key_latched_next <= r10_key;
			r11_key_latched_next <= r11_key;
			r12_key_latched_next <= r12_key;
			r13_key_latched_next <= r13_key;
			r14_key_latched_next <= r14_key;
			r15_key_latched_next <= r15_key;
		end if;
	end process;

end architecture rtl;
