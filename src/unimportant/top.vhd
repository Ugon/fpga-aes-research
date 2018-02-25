library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_transformations.all;
use work.aes_sub_bytes.all;


entity top is
generic (
	ROM_NUMBER: Integer := 8);
port (
      --------- ADC ---------
	ADC_CS_N:                     inout std_logic;
	ADC_DIN:                      out   std_logic;
	ADC_DOUT:                     in    std_logic;
	ADC_SCLK:                     out   std_logic;

      --------- AUD ---------
	AUD_ADCDAT:                   in    std_logic;
	AUD_ADCLRCK:                  inout std_logic;
	AUD_BCLK:                     inout std_logic;
	AUD_DACDAT:                   out   std_logic;
	AUD_DACLRCK:                  inout std_logic;
	AUD_XCK:                      out   std_logic;

      --------- CLOCK ---------
    CLOCK_50:                     in    std_logic;
    CLOCK2_50:                    in    std_logic;
    CLOCK3_50:                    in    std_logic;
    CLOCK4_50:                    in    std_logic;

      --------- DRAM ---------
	DRAM_ADDR:                    out   std_logic_vector(12 downto 0);
	DRAM_BA:                      out   std_logic_vector(1 downto 0);
	DRAM_CAS_N:                   out   std_logic;
	DRAM_CKE:                     out   std_logic;
	DRAM_CLK:                     out   std_logic;
	DRAM_CS_N:                    out   std_logic;
	DRAM_DQ:                      inout std_logic_vector(15 downto 0);
	DRAM_LDQM:                    out   std_logic;
	DRAM_RAS_N:                   out   std_logic;
	DRAM_UDQM:                    out   std_logic;
	DRAM_WE_N:                    out   std_logic;

      --------- FAN ---------
	FAN_CTRL:                     out   std_logic;

      --------- FPGA ---------
	FPGA_I2C_SCLK:                out   std_logic;
	FPGA_I2C_SDAT:                inout std_logic;

      --------- GPIO ---------
	GPIO_0:                       inout std_logic_vector(35 downto 0);
	GPIO_1:                       inout std_logic_vector(35 downto 0);
 
      --------- HEX ---------
	HEX0:                         out   std_logic_vector(6 downto 0);
	HEX1:                         out   std_logic_vector(6 downto 0);
	HEX2:                         out   std_logic_vector(6 downto 0);
	HEX3:                         out   std_logic_vector(6 downto 0);
	HEX4:                         out   std_logic_vector(6 downto 0);
	HEX5:                         out   std_logic_vector(6 downto 0);

      --------- HPS ---------
	--HPS_CONV_USB_N:               inout std_logic;
	--HPS_DDR3_ADDR:                out   std_logic_vector(14 downto 0);
	--HPS_DDR3_BA:                  out   std_logic_vector(2 downto 0);
	--HPS_DDR3_CAS_N:               out   std_logic;
	--HPS_DDR3_CKE:                 out   std_logic;
	--HPS_DDR3_CK_N:                out   std_logic;
	--HPS_DDR3_CK_P:                out   std_logic;
	--HPS_DDR3_CS_N:                out   std_logic;
	--HPS_DDR3_DM:                  out   std_logic_vector(3 downto 0);
	--HPS_DDR3_DQ:                  inout std_logic_vector(31 downto 0);
	--HPS_DDR3_DQS_N:               inout std_logic_vector(3 downto 0);
	--HPS_DDR3_DQS_P:               inout std_logic_vector(3 downto 0);
	--HPS_DDR3_ODT:                 out   std_logic;
	--HPS_DDR3_RAS_N:               out   std_logic;
	--HPS_DDR3_RESET_N:             out   std_logic;
	--HPS_DDR3_RZQ:                 in    std_logic;
	--HPS_DDR3_WE_N:                out   std_logic;
	--HPS_ENET_GTX_CLK:             out   std_logic;
	--HPS_ENET_INT_N:               inout std_logic;
	--HPS_ENET_MDC:                 out   std_logic;
	--HPS_ENET_MDIO:                inout std_logic;
	--HPS_ENET_RX_CLK:              in    std_logic;
	--HPS_ENET_RX_DATA:             in    std_logic_vector(3 downto 0);
	--HPS_ENET_RX_DV:               in    std_logic;
	--HPS_ENET_TX_DATA:             out   std_logic_vector(3 downto 0);
	--HPS_ENET_TX_EN:               out   std_logic;
	--HPS_FLASH_DATA:               inout std_logic_vector(3 downto 0);
	--HPS_FLASH_DCLK:               out   std_logic;
	--HPS_FLASH_NCSO:               out   std_logic;
	--HPS_GSENSOR_INT:              inout std_logic;
	--HPS_I2C1_SCLK:                inout std_logic;
	--HPS_I2C1_SDAT:                inout std_logic;
	--HPS_I2C2_SCLK:                inout std_logic;
	--HPS_I2C2_SDAT:                inout std_logic;
	--HPS_I2C_CONTROL:              inout std_logic;
	--HPS_KEY:                      inout std_logic;
	--HPS_LED:                      inout std_logic;
	--HPS_LTC_GPIO:                 inout std_logic;
	--HPS_SD_CLK:                   out   std_logic;
	--HPS_SD_CMD:                   inout std_logic;
	--HPS_SD_DATA:                  inout std_logic_vector(3 downto 0);
	--HPS_SPIM_CLK:                 out   std_logic;
	--HPS_SPIM_MISO:                in    std_logic;
	--HPS_SPIM_MOSI:                out   std_logic;
	--HPS_SPIM_SS:                  inout std_logic;
	--HPS_UART_RX:                  inout std_logic;
	--HPS_UART_TX:                  inout std_logic;
	--HPS_USB_CLKOUT:               in    std_logic;
	--HPS_USB_DATA:                 inout std_logic_vector(7 downto 0);
	--HPS_USB_DIR:                  in    std_logic;
	--HPS_USB_NXT:                  in    std_logic;
	--HPS_USB_STP:                  out   std_logic;

      --------- IRDA ---------
	IRDA_RXD:                     in    std_logic;
	IRDA_TXD:                     out   std_logic;

      --------- KEY ---------
	KEY:                          in    std_logic_vector(3 downto 0);

      --------- LEDR ---------
	LEDR:                         out   std_logic_vector(9 downto 0);

      --------- PS2 ---------
	PS2_CLK:                      inout std_logic;
	PS2_CLK2:                     inout std_logic;
	PS2_DAT:                      inout std_logic;
	PS2_DAT2:                     inout std_logic;

      --------- SW ---------
	SW:                           in    std_logic_vector(9 downto 0);

      --------- TD ---------
	TD_CLK27:                     in    std_logic;
	TD_DATA:                      in    std_logic_vector(7 downto 0);
	TD_HS:                        in    std_logic;
	TD_RESET_N:                   out   std_logic;
	TD_VS:                        in    std_logic;

      --------- VGA ---------
	VGA_B:                        out   std_logic_vector(7 downto 0);
	VGA_BLANK_N:                  out   std_logic;
	VGA_CLK:                      out   std_logic;
	VGA_G:                        out   std_logic_vector(7 downto 0);
	VGA_HS:                       out   std_logic;
	VGA_R:                        out   std_logic_vector(7 downto 0);
	VGA_SYNC_N:                   out   std_logic;
	VGA_VS:                       out   std_logic);
end entity top;

architecture rtl of top is

    signal rom_address_sig : integer range 0 to 32 := 0;
    signal rom_data       : std_logic_vector(255 downto 0);


	signal probe                              : std_logic_vector(7 downto 0);
	signal probe_gnd                          : std_logic_vector(1 downto 0);
	
	signal reset_n                            : std_logic;

	signal started: std_logic := '0';
	
	signal transformation_input: std_logic_vector(127 downto 0);
	signal transformation_output: std_logic_vector(127 downto 0);
	signal expected: std_logic_vector(127 downto 0);
	
	signal wrong: std_logic := '0';

	signal main_clk : std_logic := '0';

begin

	main_clk <= CLOCK_50;

--	memory_arrangement_inst: entity work.memory_arrangement 
--		generic map (
--			MEM_FOLDER => "identity")
--    	port map (
--    	    main_clk => main_clk,
--    	    data     => rom_data);
	
	transformation_input <= rom_data(255 downto 128);
	process(main_clk) begin
		if (falling_edge(main_clk)) then
			transformation_output <= sub_bytes_calc(transformation_input);
			expected <= rom_data(127 downto 0);
		end if;
	end process;

	process(main_clk, started) begin
		if (rising_edge(main_clk) and started = '1') then
			if (transformation_output /= expected) then
				wrong <= '1';
			end if;
		end if;
	end process;

	LEDR(9) <= wrong;

	LEDR(8) <= main_clk;
	LEDR(7) <= started;

	LEDR(2 downto 0) <= transformation_output(2 downto 0);
	LEDR(5 downto 3) <= expected(2 downto 0);

	--reset_n <= KEY(0);

	--LEDR(8) <= rom_data(8);
	--LEDR(6) <= rom_data(6);
	--LEDR(5) <= rom_data(5);
	--LEDR(4) <= rom_data(4);
	--LEDR(3) <= rom_data(3);
	--LEDR(2) <= rom_data(2);
	--LEDR(1) <= rom_data(1);
	--LEDR(0) <= rom_data(0);
	
	--probe_gnd <= (others => '0');

	--GPIO_1(27) <= probe(0);
	--GPIO_1(26) <= probe(1);
	--GPIO_1(29) <= probe(2);
	--GPIO_1(28) <= probe(3);
	--GPIO_1(31) <= probe(4);
	--GPIO_1(30) <= probe(5);
	--GPIO_1(33) <= probe(6);
	--GPIO_1(32) <= probe(7);

	--GPIO_1(35) <= probe_gnd(0);
	--GPIO_1(34) <= probe_gnd(1);

end architecture rtl;
