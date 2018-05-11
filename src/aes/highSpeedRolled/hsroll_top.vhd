library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.aes_mix_columns.all;
use work.aes_sub_bytes.all;
use work.aes_utils.all;


entity hsroll_top is
generic (
	--NUMBER_OF_CYCLES: Integer := 14 * 11 + 10;
	--NUMBER_OF_CYCLES: Integer := 13 * 11;
	--NUMBER_OF_CYCLES: Integer := 13 * 11 + 10;
	NUMBER_OF_CYCLES: Integer := 14 * 11;
	--NUMBER_OF_CYCLES: Integer := 11;
	MEM_FOLDER:       String  := "enc2"
);
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
end entity hsroll_top;

architecture rtl of hsroll_top is

	component pll is
		port (
			refclk   : in  std_logic := 'X';
			rst      : in  std_logic := 'X';
			outclk_0 : out std_logic
		);
	end component;

	signal main_clk              : std_logic := '0';
    signal rom_data_in           : std_logic_vector(127 downto 0);
    signal rom_data_out          : std_logic_vector(127 downto 0);
    signal rom_data_key_high     : std_logic_vector(127 downto 0);
    signal rom_data_key_low      : std_logic_vector(127 downto 0);
    signal rom_data_calculated   : std_logic_vector(127 downto 0);
    
    signal rom_data_key          : std_logic_vector(255 downto 0);

	signal started               : std_logic := '0';
	signal exchange              : std_logic := '0';
		
	signal transformation_input  : std_logic_vector(127 downto 0);
	signal transformation_output : std_logic_vector(127 downto 0);
	signal expected              : std_logic_vector(127 downto 0);

begin

	LEDR(9) <= started;

	rom_data_key(255 downto 128) <= rom_data_key_high;
	rom_data_key(127 downto 0)   <= rom_data_key_low;

	--main_clk <= CLOCK_50;
	pll_inst: pll
		port map (
			refclk   => CLOCK_50,
			rst      => '0',
			outclk_0 => main_clk);

	memory_arrangement_inst0: entity work.memory_arrangement 
		generic map (
			MEM_FOLDER       => MEM_FOLDER,
			MEM_IN_OUT       => "in",
			NUMBER_OF_CYCLES => 0)
    	port map (
    	    main_clk         => main_clk,
    	    data             => rom_data_in);

    memory_arrangement_inst1: entity work.memory_arrangement 
		generic map (
			MEM_FOLDER       => MEM_FOLDER,
			MEM_IN_OUT       => "out",
			NUMBER_OF_CYCLES => NUMBER_OF_CYCLES)
    	port map (
    	    main_clk         => main_clk,
    	    data             => rom_data_out);

    memory_arrangement_inst2: entity work.memory_arrangement 
		generic map (
			MEM_FOLDER       => MEM_FOLDER,
			MEM_IN_OUT       => "key_high",
			NUMBER_OF_CYCLES => 0)
    	port map (
    	    main_clk         => main_clk,
    	    data             => rom_data_key_high);

    memory_arrangement_inst3: entity work.memory_arrangement 
		generic map (
			MEM_FOLDER       => MEM_FOLDER,
			MEM_IN_OUT       => "key_low",
			NUMBER_OF_CYCLES => 0)
    	port map (
    	    main_clk         => main_clk,
    	    data             => rom_data_key_low);	
	
	error_detector_inst0: entity work.error_detector 
    	port map (
    		main_clk       => main_clk,
			started        => started,
			data           => rom_data_calculated,
			detect         => exchange,
			--data           => rom_data_in or rom_data_key_high or rom_data_key_low,
			--data           => not reverse_bit_order(rom_data_in),
			--data           => rom_data_late,
			--data           => sub_bytes_lookup(rom_data_in),
			--data           => sub_bytes_lookup(rom_data_in),
			--data           => mix_columns(rom_data_in),
			expected       => rom_data_out,
			error_detected => LEDR(0));

	aes256enc_inst0: entity work.hsroll_aes256enc 
    	port map (
			main_clk   => main_clk,
			key        => rom_data_key,
			plaintext  => rom_data_in,
			cyphertext => rom_data_calculated,
			exchange   => exchange);

	process(main_clk, KEY(0)) begin
		if (rising_edge(main_clk)) then
			if (KEY(0) = '0') then
				started <= '1';
			end if;
		end if;
	end process;


end architecture rtl;
