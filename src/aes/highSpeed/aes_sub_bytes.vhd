library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package aes_sub_bytes is

	type t_sub_table is array (0 to 255) of std_logic_vector(7 downto 0);

	constant sub_table : t_sub_table := (
		------|   0      1      2      3      4      5      6      7      8      9      a      b      c      d      e      f
		------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|
		/* 0 */ x"63", x"7c", x"77", x"7b", x"f2", x"6b", x"6f", x"c5", x"30", x"01", x"67", x"2b", x"fe", x"d7", x"ab", x"76",
		/* 1 */ x"ca", x"82", x"c9", x"7d", x"fa", x"59", x"47", x"f0", x"ad", x"d4", x"a2", x"af", x"9c", x"a4", x"72", x"c0",
		/* 2 */ x"b7", x"fd", x"93", x"26", x"36", x"3f", x"f7", x"cc", x"34", x"a5", x"e5", x"f1", x"71", x"d8", x"31", x"15",
		/* 3 */ x"04", x"c7", x"23", x"c3", x"18", x"96", x"05", x"9a", x"07", x"12", x"80", x"e2", x"eb", x"27", x"b2", x"75",
		/* 4 */ x"09", x"83", x"2c", x"1a", x"1b", x"6e", x"5a", x"a0", x"52", x"3b", x"d6", x"b3", x"29", x"e3", x"2f", x"84",
		/* 5 */ x"53", x"d1", x"00", x"ed", x"20", x"fc", x"b1", x"5b", x"6a", x"cb", x"be", x"39", x"4a", x"4c", x"58", x"cf",
		/* 6 */ x"d0", x"ef", x"aa", x"fb", x"43", x"4d", x"33", x"85", x"45", x"f9", x"02", x"7f", x"50", x"3c", x"9f", x"a8",
		/* 7 */ x"51", x"a3", x"40", x"8f", x"92", x"9d", x"38", x"f5", x"bc", x"b6", x"da", x"21", x"10", x"ff", x"f3", x"d2",
		/* 8 */ x"cd", x"0c", x"13", x"ec", x"5f", x"97", x"44", x"17", x"c4", x"a7", x"7e", x"3d", x"64", x"5d", x"19", x"73",
		/* 9 */ x"60", x"81", x"4f", x"dc", x"22", x"2a", x"90", x"88", x"46", x"ee", x"b8", x"14", x"de", x"5e", x"0b", x"db",
		/* a */ x"e0", x"32", x"3a", x"0a", x"49", x"06", x"24", x"5c", x"c2", x"d3", x"ac", x"62", x"91", x"95", x"e4", x"79",
		/* b */ x"e7", x"c8", x"37", x"6d", x"8d", x"d5", x"4e", x"a9", x"6c", x"56", x"f4", x"ea", x"65", x"7a", x"ae", x"08",
		/* c */ x"ba", x"78", x"25", x"2e", x"1c", x"a6", x"b4", x"c6", x"e8", x"dd", x"74", x"1f", x"4b", x"bd", x"8b", x"8a",
		/* d */ x"70", x"3e", x"b5", x"66", x"48", x"03", x"f6", x"0e", x"61", x"35", x"57", x"b9", x"86", x"c1", x"1d", x"9e",
		/* e */ x"e1", x"f8", x"98", x"11", x"69", x"d9", x"8e", x"94", x"9b", x"1e", x"87", x"e9", x"ce", x"55", x"28", x"df",
		/* f */ x"8c", x"a1", x"89", x"0d", x"bf", x"e6", x"42", x"68", x"41", x"99", x"2d", x"0f", x"b0", x"54", x"bb", x"16"
	);

	function sub_bytes_lookup (state_in: std_logic_vector) return std_logic_vector;
	--function sub_bytes_calc (state_in: std_logic_vector) return std_logic_vector;
	
	function sub_byte_lookup(byte: std_logic_vector) return std_logic_vector;	
	--function sub_byte_calc(byte: std_logic_vector) return std_logic_vector;	

	--2 => 2; multiplication by phi in GF(2^2) 
	function mul_phi_2(inp: std_logic_vector) return std_logic_vector;

	--4 => 4; multiplication by lambda in GF(2^4)
	function mul_lam_4(inp: std_logic_vector) return std_logic_vector;
	
	--4 => 4; squaring in GF(2^4)
	function sq_4(inp: std_logic_vector) return std_logic_vector;
	
	--2 => 2; multiplication in GF(2^2)
	function mul_2(inp1: std_logic_vector; inp2: std_logic_vector) return std_logic_vector;
	
	--4 => 4; multiplication in GF(2^4) --in 2 stages for 4LUTs
	function mul_4a(inp1: std_logic_vector; inp2: std_logic_vector) return std_logic_vector;
	function mul_4b(inp: std_logic_vector) return std_logic_vector;
	
	--4 => 4; multiplicative inversion in GF(2^4)
	function inv_4(inp: std_logic_vector) return std_logic_vector;
	
	--8 => 8; multiplicative inversion in GF(2^8)
	--function inv_8(inp: std_logic_vector) return std_logic_vector;
	
	--8 => 8; multiplication by delta matrix in GF(2^8)
	function mul_delta_8a(inp: std_logic_vector) return std_logic_vector;
	function mul_delta_8b(inp: std_logic_vector) return std_logic_vector;
	function mul_delta_8b_xored(inp: std_logic_vector) return std_logic_vector;
	
	--8 => 8; multiplication by delta_inv matrix + AES affine transformation in GF(2^8)
	function mul_deltainv_affine_8a(inp: std_logic_vector) return std_logic_vector;
	function mul_deltainv_affine_8b(inp: std_logic_vector) return std_logic_vector;


end aes_sub_bytes;

package body aes_sub_bytes is

	function mul_phi_2(inp: std_logic_vector) return std_logic_vector is
		constant a : std_logic := inp(inp'low + 1);
		constant b : std_logic := inp(inp'low + 0);
		
		constant c : std_logic := a xor b;

		constant result: std_logic_vector(1 downto 0) := (c, a);
	begin
		return result;
	end function;

	
	function mul_lam_4(inp: std_logic_vector) return std_logic_vector is
		constant a : std_logic := inp(inp'low + 3);
		constant b : std_logic := inp(inp'low + 2);
		constant c : std_logic := inp(inp'low + 1);
		constant d : std_logic := inp(inp'low + 0);

		constant e : std_logic := a xor c;
		constant f : std_logic := b xor d;
		constant g : std_logic := e xor f;

		constant result: std_logic_vector(3 downto 0) := (f, g, a, b);
	begin
		return result;
	end function;

	
	function sq_4(inp: std_logic_vector) return std_logic_vector is
		constant a : std_logic := inp(inp'low + 3);
		constant b : std_logic := inp(inp'low + 2);
		constant c : std_logic := inp(inp'low + 1);
		constant d : std_logic := inp(inp'low + 0);
		
		constant e : std_logic := a xor b;
		constant f : std_logic := b xor c;
		constant g : std_logic := c xor d;
		constant h : std_logic := a xor g;

		constant result: std_logic_vector(3 downto 0) := (a, e, f, h);
	begin
		return result;
	end function;

	
	function mul_2(inp1: std_logic_vector; inp2: std_logic_vector) return std_logic_vector is
		constant a : std_logic := inp1(inp1'low + 1);
		constant b : std_logic := inp1(inp1'low + 0);
		constant c : std_logic := inp2(inp2'low + 1);
		constant d : std_logic := inp2(inp2'low + 0);
		
		constant e : std_logic := a xor b;
		constant f : std_logic := c xor d;
		constant g : std_logic := a and c;
		constant h : std_logic := e and f;
		constant i : std_logic := b and d;
		constant j : std_logic := h xor i;
		constant k : std_logic := g xor i;
		
		constant result: std_logic_vector(1 downto 0) := (j, k);
	begin
		return result;
	end function;

	
	function mul_4a(inp1: std_logic_vector; inp2: std_logic_vector) return std_logic_vector is
		constant a : std_logic_vector(1 downto 0) := inp1(inp1'low + 3 downto inp1'low + 2);
		constant b : std_logic_vector(1 downto 0) := inp1(inp1'low + 1 downto inp1'low + 0);
		constant c : std_logic_vector(1 downto 0) := inp2(inp2'low + 3 downto inp2'low + 2);
		constant d : std_logic_vector(1 downto 0) := inp2(inp2'low + 1 downto inp2'low + 0);
		
		constant e : std_logic_vector(1 downto 0) := a xor b;
		constant f : std_logic_vector(1 downto 0) := c xor d;
		constant g : std_logic_vector(1 downto 0) := mul_2(a, c);
		constant i : std_logic_vector(1 downto 0) := mul_2(b, d);

		variable result: std_logic_vector(7 downto 0);
	begin
		result(7 downto 6) := g;
		result(5 downto 4) := e;
		result(3 downto 2) := f;
		result(1 downto 0) := i;
		return result;
	end function;


	function mul_4b(inp: std_logic_vector) return std_logic_vector is
		constant g : std_logic_vector(1 downto 0) := inp(7 downto 6);
		constant e : std_logic_vector(1 downto 0) := inp(5 downto 4);
		constant f : std_logic_vector(1 downto 0) := inp(3 downto 2);
		constant i : std_logic_vector(1 downto 0) := inp(1 downto 0);
		
		constant h : std_logic_vector(1 downto 0) := mul_2(e, f);
		constant j : std_logic_vector(1 downto 0) := h xor i;
		constant k : std_logic_vector(1 downto 0) := mul_phi_2(g) xor i;
		
		variable result: std_logic_vector(3 downto 0);
	begin
		result(3 downto 2) := j;
		result(1 downto 0) := k;
		return result;
	end function;

	
	function inv_4(inp: std_logic_vector) return std_logic_vector is
		constant x0 : std_logic := inp(inp'low + 0);
		constant x1 : std_logic := inp(inp'low + 1);
		constant x2 : std_logic := inp(inp'low + 2);
		constant x3 : std_logic := inp(inp'low + 3);
		

		constant x3i : std_logic := x3 xor (x3 and x2 and x1) xor (x3 and x0) xor x2;
		constant x2i : std_logic := (x3 and x2 and x1) xor (x3 and x2 and x0) xor(x3 and x0) xor x2 xor (x2 and x1);
		constant x1i : std_logic := x3 xor (x3 and x2 and x1) xor (x3 and x1 and x0) xor x2 xor (x2 and x0) xor x1;
		constant x0i : std_logic := (x3 and x2 and x1) xor (x3 and x2 and x0) xor (x3 and x1) xor (x3 and x1 and x0) xor (x3 and x0) xor x2 xor (x2 and x1) xor (x2 and x1 and x0) xor x1 xor x0;
		
		constant result: std_logic_vector(3 downto 0) := (x3i, x2i, x1i, x0i);
	begin
		return result;
	end function;
	

	function mul_delta_8a(inp: std_logic_vector) return std_logic_vector is
		constant a:  std_logic := inp(inp'low + 0);
		constant b:  std_logic := inp(inp'low + 1);
		constant c:  std_logic := inp(inp'low + 2);
		constant d:  std_logic := inp(inp'low + 3);
		constant e:  std_logic := inp(inp'low + 4);
		constant f:  std_logic := inp(inp'low + 5);
		constant g:  std_logic := inp(inp'low + 6);
		constant h:  std_logic := inp(inp'low + 7);
		
		constant cd:   std_logic := c xor d;
		constant fh:   std_logic := f xor h;
		constant be:   std_logic := b xor e;
  
		constant result: std_logic_vector(10 downto 0) := (be, fh, cd, h, g, f, e, d, c, b, a);
  	begin
  		return result;
	end function;


	function mul_delta_8b(inp: std_logic_vector) return std_logic_vector is
		constant a:  std_logic := inp(inp'low + 0);
		constant b:  std_logic := inp(inp'low + 1);
		constant c:  std_logic := inp(inp'low + 2);
		constant d:  std_logic := inp(inp'low + 3);
		constant e:  std_logic := inp(inp'low + 4);
		constant f:  std_logic := inp(inp'low + 5);
		constant g:  std_logic := inp(inp'low + 6);
		constant h:  std_logic := inp(inp'low + 7);
  		
  		constant cd: std_logic := inp(inp'low + 8);
		constant fh: std_logic := inp(inp'low + 9);
		constant be: std_logic := inp(inp'low + 10);
		
		constant r0: std_logic := a xor b xor                         g                    ;
		constant r1: std_logic :=                                     g       xor be       ;
		constant r2: std_logic :=                                           h xor be xor cd;
		constant r3: std_logic :=       b xor c xor                   g xor h              ;
		
		constant r4: std_logic :=       b xor                                     fh xor cd;
		constant r5: std_logic :=                                                 fh xor cd;
		constant r6: std_logic :=                                     g xor h xor be xor cd;
		constant r7: std_logic :=                                                 fh       ;
         
		constant result: std_logic_vector(7 downto 0) := (r7, r6, r5, r4, r3, r2, r1, r0);
  	begin
  		return result;
	end function;


	function mul_delta_8b_xored(inp: std_logic_vector) return std_logic_vector is
		constant a:  std_logic := inp(inp'low + 0);
		constant b:  std_logic := inp(inp'low + 1);
		constant c:  std_logic := inp(inp'low + 2);
		constant d:  std_logic := inp(inp'low + 3);
		constant e:  std_logic := inp(inp'low + 4);
		constant f:  std_logic := inp(inp'low + 5);
		constant g:  std_logic := inp(inp'low + 6);
		constant h:  std_logic := inp(inp'low + 7);
  
  		constant cd: std_logic := inp(inp'low + 8);
		constant fh: std_logic := inp(inp'low + 9);
		constant be: std_logic := inp(inp'low + 10);

		constant r0: std_logic := a xor g xor cd xor fh;
		constant r1: std_logic := g xor be xor cd xor fh;
		constant r2: std_logic := g;
		constant r3: std_logic := b xor c xor f xor g;
		
		constant result: std_logic_vector(3 downto 0) := (r3, r2, r1, r0);
  	begin
  		return result;
	end function;

	
	function mul_deltainv_affine_8a(inp: std_logic_vector) return std_logic_vector is
		constant a: std_logic := inp(inp'low + 0);
		constant b: std_logic := inp(inp'low + 1);
		constant c: std_logic := inp(inp'low + 2);
		constant d: std_logic := inp(inp'low + 3);
		constant e: std_logic := inp(inp'low + 4);
		constant f: std_logic := inp(inp'low + 5);
		constant g: std_logic := inp(inp'low + 6);
		constant h: std_logic := inp(inp'low + 7);

		constant cd:     std_logic := c xor d;
		constant abc:    std_logic := a xor b xor c;
		constant acd:    std_logic := a xor c xor d;
		constant efg:    std_logic := e xor f xor g;
		constant abeh:   std_logic := a xor b xor e xor h;
		constant ch_not: std_logic := '1' xor c xor h;
		constant gh_not: std_logic := '1' xor g xor h;

		constant result: std_logic_vector(8 downto 0) := (a, h, cd, abc, acd, efg, abeh, ch_not, gh_not);
	begin
 		return result;
	end function;


	function mul_deltainv_affine_8b(inp: std_logic_vector) return std_logic_vector is
		constant a:      std_logic := inp(inp'low + 8);
		constant h:      std_logic := inp(inp'low + 7);
		constant cd:     std_logic := inp(inp'low + 6);
		constant abc:    std_logic := inp(inp'low + 5);
		constant acd:    std_logic := inp(inp'low + 4);
		constant efg:    std_logic := inp(inp'low + 3);
		constant abeh:   std_logic := inp(inp'low + 2);
		constant ch_not: std_logic := inp(inp'low + 1);
		constant gh_not: std_logic := inp(inp'low + 0);
		
		constant r0: std_logic := abc xor gh_not; 
		constant r1: std_logic := '1' xor a xor h;
		constant r2: std_logic := acd xor efg;
		constant r3: std_logic := abc;
		constant r4: std_logic := abeh;
		constant r5: std_logic := ch_not;
		constant r6: std_logic := '1' xor efg xor h;
		constant r7: std_logic := cd xor h;

		constant result: std_logic_vector(7 downto 0) := (r7, r6, r5, r4, r3, r2, r1, r0);
	begin
 		return result;
	end function;


	--function sub_byte_calc(byte: std_logic_vector) return std_logic_vector is begin
		--return mul_deltainv_affine_8b(mul_deltainv_affine_8a(inv_8(mul_delta_8b(mul_delta_8a((byte))))));
	--end function;


	function sub_byte_lookup(byte: std_logic_vector) return std_logic_vector is begin
		return sub_table(to_integer(unsigned(byte)));
	end function;


	--function sub_bytes_calc(state_in: std_logic_vector) return std_logic_vector is 
		--variable state_out: std_logic_vector(127 downto 0);
	--begin
		--for b in 0 to 15 loop
			--state_out((b + 1) * 8 - 1 downto b * 8) := sub_byte_calc(state_in((b + 1) * 8 - 1 downto b * 8));
		--end loop;
		--return state_out;
	--end function;


	function sub_bytes_lookup(state_in: std_logic_vector) return std_logic_vector is 
		variable state_out: std_logic_vector(127 downto 0);
	begin
		for b in 0 to 15 loop
			state_out((b + 1) * 8 - 1 downto b * 8) := sub_byte_lookup(state_in((b + 1) * 8 - 1 downto b * 8));
		end loop;
		return state_out;
	end function;

end aes_sub_bytes;