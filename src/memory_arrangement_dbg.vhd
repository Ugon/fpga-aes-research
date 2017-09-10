library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_arrangement is
	generic (
		ROM_NUMBER   : Integer := 2;
		ROM_DEPTH    : Integer := 32);
	port (
		main_clk     : in  std_logic;
		data         : out std_logic_vector(255 downto 0);
		ready        : out std_logic := '0';

		dbg_clocks   : out std_logic_vector(ROM_NUMBER - 1 downto 0);
		dbg_cnt      : out Integer range 0 to ROM_NUMBER - 1;
		dbg_which_data: out Integer range 0 to ROM_NUMBER - 1;
		dbg_address0 : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address1 : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address2 : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address3 : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address4 : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address5 : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address6 : out Integer range 0 to ROM_DEPTH - 1;
		dbg_address7 : out Integer range 0 to ROM_DEPTH - 1
		);
end memory_arrangement;

architecture memory_arrangement_impl of memory_arrangement is 
	type fsm is (s_warmup, s_data);
	signal state: fsm := s_warmup;

	type address_array is array (ROM_NUMBER - 1 downto 0) of Integer range 0 to 31;
	type data_array    is array (ROM_NUMBER - 1 downto 0) of std_logic_vector(255 downto 0);
	type clock_array   is array (ROM_NUMBER - 1 downto 0) of std_logic;

	component rom256
    generic (
    	init_file : string);
    port (
		address   : in  std_logic_vector (4 downto 0);
		clock     : in  std_logic;
		q         : out std_logic_vector (255 downto 0));
	end component;

	signal rom_addresses : address_array;
	signal rom_datas     : data_array;
	signal rom_clocks    : clock_array;
	
	signal counter       : Integer range 0 to ROM_NUMBER - 1 := 0;

begin

	dbg_clocks(0) <= rom_clocks(0);
	dbg_clocks(1) <= rom_clocks(1);
	--dbg_clocks(2) <= rom_clocks(2);
	--dbg_clocks(3) <= rom_clocks(3);
	--dbg_clocks(4) <= rom_clocks(4);
	--dbg_clocks(5) <= rom_clocks(5);
	--dbg_clocks(6) <= rom_clocks(6);
	--dbg_clocks(7) <= rom_clocks(7);

	dbg_address0 <= rom_addresses(0);
	dbg_address1 <= rom_addresses(1);
	--dbg_address2 <= rom_addresses(2);
	--dbg_address3 <= rom_addresses(3);
	--dbg_address4 <= rom_addresses(4);
	--dbg_address5 <= rom_addresses(5);
	--dbg_address6 <= rom_addresses(6);
	--dbg_address7 <= rom_addresses(7);

	dbg_cnt <= counter;

	rom_gen: for i in 0 to ROM_NUMBER - 1 generate
		rom_inst: rom256
    	generic map (
			init_file => "../mem/mem" & integer'image(i) & ".mif")
    	port map (
    	    address  => std_logic_vector(to_unsigned(rom_addresses(i), 5)),
    	    clock    => rom_clocks(i),
    	    q        => rom_datas(i));
    end generate;

	clocks_gen: for i in 0 to ROM_NUMBER - 1 generate
		process(main_clk, counter, rom_datas) begin
			if (rising_edge(main_clk)) then
				if ((counter - i) mod ROM_NUMBER >= 0 and ((counter - i) mod ROM_NUMBER < ROM_NUMBER / 2)) then
					rom_clocks(i) <= '1';
				else 
					rom_clocks(i) <= '0';
				end if;
			end if;
		end process;
	end generate;

	addresses_gen: for i in 0 to ROM_NUMBER - 1 generate
		process (rom_clocks(i)) begin
			if (falling_edge(rom_clocks(i))) then
				rom_addresses(i) <= rom_addresses(i) + 1;
			end if;
		end process;
	end generate;

	process(main_clk, counter, rom_datas) begin
		if (rising_edge(main_clk)) then
			data <= rom_datas((counter - ROM_NUMBER / 2) mod ROM_NUMBER);
			dbg_which_data <= (counter - ROM_NUMBER / 2) mod ROM_NUMBER;
		end if;
	end process;



	process(main_clk) begin
		if (falling_edge(main_clk)) then
			counter <= counter + 1;
		end if;
	end process;

	process(main_clk) 
		variable warmup_counter: Integer range 0 to 1023 := 0;
	begin
		if (rising_edge(main_clk)) then
			warmup_counter := warmup_counter + 1;
			case state is 
				when s_warmup =>
					ready <= '0';
					if (warmup_counter = 20) then 
						state <= s_data;
					end if;
				when s_data =>
					ready <= '1';
			end case;
		end if;

	end process;


end memory_arrangement_impl;