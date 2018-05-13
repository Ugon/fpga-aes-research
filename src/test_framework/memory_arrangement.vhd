library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_arrangement is
	generic (
		ROM_NUMBER              : Integer := 2;
		ROM_DEPTH               : Integer := 32;
		ROM_WIDTH               : Integer := 128;
		NUMBER_OF_CYCLES        : Integer := 32;
		MEM_FOLDER              : String  := "identity";
		MEM_IN_OUT              : String  := "in");
	port (
		main_clk     : in  std_logic;
		data         : out std_logic_vector(ROM_WIDTH - 1 downto 0);

		dbg_address0   : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address1   : out Integer range 0 to ROM_DEPTH - 1;

		dbg_data0       : out std_logic_vector(ROM_WIDTH - 1 downto 0);
		dbg_data1       : out std_logic_vector(ROM_WIDTH - 1 downto 0);

		dbg_sig_rom_enable0 : out std_logic;
		dbg_sig_rom_enable1 : out std_logic;
		dbg_sig_mem_enable0 : out std_logic;
		dbg_sig_mem_enable1 : out std_logic
	);
end memory_arrangement;

architecture double of memory_arrangement is 
	constant OFFSET : Integer range 0 to ROM_NUMBER * ROM_DEPTH - 1 := NUMBER_OF_CYCLES mod (ROM_DEPTH * ROM_NUMBER);

	type fsm is (s_warmup, s_data);
	signal state: fsm := s_warmup;

	type address_array      is array (ROM_NUMBER - 1 downto 0) of Integer range 0 to ROM_DEPTH - 1;
	type data_array         is array (ROM_NUMBER - 1 downto 0) of std_logic_vector(ROM_WIDTH - 1 downto 0);
	type clken_array        is array (ROM_NUMBER - 1 downto 0) of std_logic;
	
	component rom128
	    generic (
    		init_file : string);
	    port (
			address   : in  std_logic_vector (4 downto 0);
			clock     : in  std_logic;
			clken     : in  std_logic;
			q         : out std_logic_vector (ROM_WIDTH - 1 downto 0));
	end component;

	signal rom_datas       : data_array;
	signal registered      : data_array;
	signal registered_fast : data_array;
	signal anded           : data_array;
	
	signal rom_addresses  : address_array := (-OFFSET / ROM_NUMBER, -OFFSET / ROM_NUMBER);

	signal sig_rom_enable : clken_array := ('0', '1');
	signal sig_mem_enable : clken_array := ('0', '1');
	signal sig_and        : data_array := ((others => '0'), (others => '1'));

	signal data_early     : std_logic_vector(ROM_WIDTH - 1 downto 0);

begin

	dbg_sig_rom_enable0 <= sig_rom_enable(0);
	dbg_sig_rom_enable1 <= sig_rom_enable(1);
	dbg_sig_mem_enable0 <= sig_mem_enable(0);
	dbg_sig_mem_enable1 <= sig_mem_enable(1);

	dbg_address0 <= rom_addresses(0);	
	dbg_address1 <= rom_addresses(1);	

	dbg_data0 <= rom_datas(0);
	dbg_data1 <= rom_datas(1);

	rom_gen: for i in 0 to ROM_NUMBER - 1 generate
		rom_inst: rom128
    	generic map (
			init_file => "../mem/" & MEM_FOLDER & "/mem" & integer'image(i) & "_" & MEM_IN_OUT & ".mif")
    	port map (
    	    address  => std_logic_vector(to_unsigned(rom_addresses(i), 5)),
    	    clock    => main_clk,
    	    clken    => sig_rom_enable(i),
    	    q        => rom_datas(i));

		process(main_clk, rom_addresses, sig_mem_enable) begin
			if (rising_edge(main_clk) and sig_mem_enable(i) = '1') then
				rom_addresses(i) <= rom_addresses(i) + 1;
				registered(i) <= rom_datas(i);
			end if;
		end process;

		process(main_clk, rom_addresses, sig_mem_enable) begin
			if (rising_edge(main_clk)) then
				sig_rom_enable(i) <= not sig_rom_enable(i);
				sig_mem_enable(i) <= not sig_mem_enable(i);
				sig_and(i) <= not sig_and(i);
				anded(i) <= registered(i) and sig_and(i);
			end if;
		end process;
	end generate;

	no_delay_gen: if OFFSET mod 2 = 0 generate
		data <= data_early;
	end generate;

	delay_gen: if OFFSET mod 2 = 1 generate
		process(main_clk, data_early) begin
			if (rising_edge(main_clk)) then
				data <= data_early;
			end if;
		end process;
	end generate;

	process(main_clk, rom_datas) begin
		if (rising_edge(main_clk)) then
			data_early <= anded(0) or anded(1);
		end if;
	end process;

end double;