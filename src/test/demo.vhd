library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_utils.all;

entity demo is
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
		CLK     : in  std_logic;
      A            : in std_logic;
      ENABLE       : in std_logic;
      B            : out std_logic
      --ins          : in  std_logic_vector(7 downto 0);
		--outs         : out std_logic_vector(7 downto 0)


		);
end demo;

architecture memory_arrangement_impl of demo is 
   signal CLK_ENABLED: std_logic;
begin

   CLK_ENABLED <= CLK and ENABLE;
   process(CLK_ENABLED) is begin
      if (rising_edge(CLK_ENABLED)) then
         B <= A;
      end if;
   end process;

   --gated <= CLK and a;
   --process(gated) is begin
      --if (rising_edge(gated)) then
         --e <= c;
      --end if;
   --end process;





end memory_arrangement_impl;