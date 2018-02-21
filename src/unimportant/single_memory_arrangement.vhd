library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_memory_arrangement is
	generic (
		ROM_DEPTH    : Integer := 32;
		MEM_FOLDER   : String  := "identity");
	port (
		main_clk     : in  std_logic;
		data         : out std_logic_vector(255 downto 0);

		--dbg_cnt        : out std_logic_vector(ROM_NUMBER - 1 downto 0);

		dbg_address0   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address1   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address2   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address3   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address4   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address5   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address6   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address7   : out Integer range 0 to ROM_DEPTH - 1


		);
end single_memory_arrangement;

architecture memory_arrangement_impl of single_memory_arrangement is 
	type fsm is (s_warmup, s_data);
	signal state: fsm := s_warmup;

	component rom256
	    generic (
    		init_file : string);
	    port (
			address   : in  std_logic_vector (4 downto 0);
			clock     : in  std_logic;
			clken     : in  std_logic;
			q         : out std_logic_vector (255 downto 0));
	end component;

	signal rom_address : Integer range 0 to 31;
	signal rom_data   : std_logic_vector(255 downto 0);
	
	--signal counter       : std_logic_vector(ROM_NUMBER - 1 downto 0) := (0 => '1', others => '0');

begin

	--dbg_cnt <= counter;

	--dbg_ens(0)   <= rom_clkens(0);	
	--dbg_ens(1)   <= rom_clkens(1);	
	--dbg_ens(2)   <= rom_clkens(2);	
	--dbg_ens(3)   <= rom_clkens(3);	
	--dbg_ens(4)   <= rom_clkens(4);	
	--dbg_ens(5)   <= rom_clkens(5);	
	--dbg_ens(6)   <= rom_clkens(6);	
	--dbg_ens(7)   <= rom_clkens(7);	

	--dbg_address0 <= rom_addresses(0);	
	--dbg_address1 <= rom_addresses(1);	
	--dbg_address2 <= rom_addresses(2);	
	--dbg_address3 <= rom_addresses(3);	
	--dbg_address4 <= rom_addresses(4);	
	--dbg_address5 <= rom_addresses(5);	
	--dbg_address6 <= rom_addresses(6);	
	--dbg_address7 <= rom_addresses(7);	


	data <= rom_data;

	rom_inst: rom256
    generic map (
		init_file => "../mem/" & MEM_FOLDER & "/mem" & integer'image(0) & ".mif")
    port map (
        address  => std_logic_vector(to_unsigned(rom_address, 5)),
        clock    => main_clk,
        clken    => '1',
        q        => rom_data);

	process(main_clk, rom_data) begin
		if (falling_edge(main_clk)) then
			rom_address <= rom_address + 1;
		end if;
	end process;

	--addresses_gen: for i in 0 to ROM_NUMBER - 1 generate
		--process (rom_clocks(i)) begin
			--if (falling_edge(rom_clocks(i))) then
				--rom_addresses(i) <= rom_addresses(i) + 1;
			--end if;
		--end process;
	--end generate;

	--process(main_clk, counter) begin
		--if (falling_edge(main_clk)) then
			--counter <= counter(ROM_NUMBER - 2 downto 0) & counter(ROM_NUMBER - 1);
		--end if;
	--end process;



end memory_arrangement_impl;