library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_utils.all;

entity memory_queue is
	generic (
		ROM_DEPTH        : Integer := 32;
		ROM_WIDTH        : Integer := 128;
		NUMBER_OF_CYCLES : Integer := 6;
		MEM_FOLDER       : String  := "identity";
		--MEM_FOLDER       : String  := "sub_bytes";
		DATAS_OUT_QUEUE_NUMBER  : Integer := 3;
		--DATAS_OUT_QUEUE_NUMBER  : Integer := 5;
		MEM_IN_OUT       : String  := "in");
	port (
		main_clk     : in  std_logic;
		data         : out std_logic_vector(ROM_WIDTH - 1 downto 0);

		dbg_address   : out Integer range 0 to ROM_DEPTH - 1;

		dbg_data_mem       : out std_logic_vector(ROM_WIDTH - 1 downto 0);
		dbg_data_mem_latch       : out std_logic_vector(ROM_WIDTH - 1 downto 0);
		dbg_mem_clock       : out std_logic;
		dbg_data_enable   : out std_logic

		);
end memory_queue;

architecture memory_arrangement_impl of memory_queue is 
	constant OFFSET : Integer range 0 to ROM_DEPTH - 1 := NUMBER_OF_CYCLES mod ROM_DEPTH;

	--type address_array      is array (ROM_NUMBER - 1 downto 0) of Integer range 0 to ROM_DEPTH - 1;
	--type data_array         is array (ROM_NUMBER - 1 downto 0) of std_logic_vector(ROM_WIDTH - 1 downto 0);
	--type clken_array        is array (ROM_NUMBER - 1 downto 0) of std_logic;

	type datas_queue_type is array (0 to ROM_DEPTH - 1) of std_logic_vector(ROM_WIDTH - 1 downto 0);
	signal datas_queue: datas_queue_type;

	type datas_out_queue_type is array (0 to DATAS_OUT_QUEUE_NUMBER - 1) of std_logic_vector(ROM_WIDTH - 1 downto 0);
	signal datas_out_queue: datas_queue_type;


	component rom128
	    generic (
    		init_file : string);
	    port (
			address   : in  std_logic_vector (4 downto 0);
			clock     : in  std_logic;
			clken     : in  std_logic;
			q         : out std_logic_vector (ROM_WIDTH - 1 downto 0));
	end component;

	signal mem_clock: std_logic;
	signal mem_clock_internal: std_logic;

	signal mem_data: std_logic_vector(ROM_WIDTH - 1 downto 0);
	signal mem_data_latched: std_logic_vector(ROM_WIDTH - 1 downto 0);
	signal address: Integer range 0 to ROM_DEPTH - 1;
	signal mem_block_enable: std_logic;
	signal mem_block_enable_counter: std_logic_vector(32 downto 0) := "100000000000000000000000000000000";
	--signal mem_block_enable_internal: std_logic;
   	--signal counter: Integer range 0 to 32 := 0;
   	signal mem_clock_counter: std_logic_vector(32 downto 0) := "111111111111111110000000000000000";
   	--signal counter_reset: std_logic;

begin

	dbg_address <= address;
	dbg_data_mem <= mem_data;
	dbg_data_mem_latch <= mem_data_latched;
	dbg_mem_clock <= mem_clock;
	dbg_data_enable <= mem_block_enable;

	rom_inst: rom128
   	generic map (
		--init_file => "../mem/" & MEM_FOLDER & "/mem" & integer'image(i) & "_" & MEM_IN_OUT & ".mif")
		init_file => "../mem/" & MEM_FOLDER & "/mem0" & "_" & MEM_IN_OUT & ".mif")
   	port map (
   	    address  => std_logic_vector(to_unsigned(address, 5)),
   	    --clock    => main_clk,
   	    clock    => mem_clock,
   	    clken    => '1',--mem_block_enable,
   	    q        => mem_data);

	process(main_clk) is begin
   		if(rising_edge(main_clk)) then
   			datas_out_queue(0) <= datas_queue(0);
   			data <= datas_out_queue(DATAS_OUT_QUEUE_NUMBER - 1);
   			--datas_queue(0) <= and_with_bit(mem_data_latched, mem_block_enable) or and_with_bit(datas_queue(31), not mem_block_enable);

   			if (mem_block_enable = '1') then
   				datas_queue(0) <= mem_data_latched;
   			else
   			 	datas_queue(0) <= datas_queue(31);
   			end if;
   			for i in 1 to ROM_DEPTH - 1 loop
   				datas_queue(i) <= datas_queue(i - 1);
   			end loop;
   			for i in 1 to DATAS_OUT_QUEUE_NUMBER - 1 loop
   				datas_out_queue(i) <= datas_out_queue(i - 1);
   			end loop;
   		end if;
   	end process;

   	process(main_clk) is begin
   		if(rising_edge(main_clk)) then
   			mem_data_latched <= mem_data;
   		end if;
   	end process;

   	--mem_block_enable_internal <= '1' when counter = "011111" else '0';
   	--process(main_clk) is begin
   		--if(rising_edge(main_clk)) then
   			--mem_block_enable <= mem_block_enable_internal;
   		--end if;
   	--end process;


	--process(counter) is begin
   		--if(counter = 32) then
   			--mem_block_enable <= '1';
   		--else 
   			--mem_block_enable <= '0';
   		--end if;
   	--end process;

   	process(mem_clock) is begin
   		if (falling_edge(mem_clock)) then
   			address <= address + 1;
   		end if;
   	end process;

	mem_block_enable <= mem_block_enable_counter(32);
	mem_clock <= mem_clock_counter(32);

	--counter_reset <= '1' when counter = 32 else '0';
   	process(main_clk) is begin
   		if(rising_edge(main_clk)) then
   			mem_block_enable_counter <= mem_block_enable_counter(31 downto 0) & mem_block_enable_counter(32);
   			mem_clock_counter <= mem_clock_counter(31 downto 0) & mem_clock_counter(32);
   			--if (counter_reset = '1') then
   			--if (counter(5) = '1') then
   				--counter <= "000000";
   			--else
   				--counter <= counter + 1;
   				--counter <= std_logic_vector(unsigned(counter) + 1);
   			--end if;
   		end if;
   	end process;

   	--mem_clock_internal <= '1' when counter <= ROM_DEPTH / 2 else '0';
   	--mem_clock_internal <= '1' when (counter(5) or counter(4)) = '0' else '0';
   	--process(main_clk) is begin
   		--if(rising_edge(main_clk)) then
   			--mem_clock <= mem_clock_internal;
   		--end if;
   	--end process;









end memory_arrangement_impl;