library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
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
	HPS_CONV_USB_N:               inout std_logic;
	HPS_DDR3_ADDR:                out   std_logic_vector(14 downto 0);
	HPS_DDR3_BA:                  out   std_logic_vector(2 downto 0);
	HPS_DDR3_CAS_N:               out   std_logic;
	HPS_DDR3_CKE:                 out   std_logic;
	HPS_DDR3_CK_N:                out   std_logic;
	HPS_DDR3_CK_P:                out   std_logic;
	HPS_DDR3_CS_N:                out   std_logic;
	HPS_DDR3_DM:                  out   std_logic_vector(3 downto 0);
	HPS_DDR3_DQ:                  inout std_logic_vector(31 downto 0);
	HPS_DDR3_DQS_N:               inout std_logic_vector(3 downto 0);
	HPS_DDR3_DQS_P:               inout std_logic_vector(3 downto 0);
	HPS_DDR3_ODT:                 out   std_logic;
	HPS_DDR3_RAS_N:               out   std_logic;
	HPS_DDR3_RESET_N:             out   std_logic;
	HPS_DDR3_RZQ:                 in    std_logic;
	HPS_DDR3_WE_N:                out   std_logic;
	HPS_ENET_GTX_CLK:             out   std_logic;
	HPS_ENET_INT_N:               inout std_logic;
	HPS_ENET_MDC:                 out   std_logic;
	HPS_ENET_MDIO:                inout std_logic;
	HPS_ENET_RX_CLK:              in    std_logic;
	HPS_ENET_RX_DATA:             in    std_logic_vector(3 downto 0);
	HPS_ENET_RX_DV:               in    std_logic;
	HPS_ENET_TX_DATA:             out   std_logic_vector(3 downto 0);
	HPS_ENET_TX_EN:               out   std_logic;
	HPS_FLASH_DATA:               inout std_logic_vector(3 downto 0);
	HPS_FLASH_DCLK:               out   std_logic;
	HPS_FLASH_NCSO:               out   std_logic;
	HPS_GSENSOR_INT:              inout std_logic;
	HPS_I2C1_SCLK:                inout std_logic;
	HPS_I2C1_SDAT:                inout std_logic;
	HPS_I2C2_SCLK:                inout std_logic;
	HPS_I2C2_SDAT:                inout std_logic;
	HPS_I2C_CONTROL:              inout std_logic;
	HPS_KEY:                      inout std_logic;
	HPS_LED:                      inout std_logic;
	HPS_LTC_GPIO:                 inout std_logic;
	HPS_SD_CLK:                   out   std_logic;
	HPS_SD_CMD:                   inout std_logic;
	HPS_SD_DATA:                  inout std_logic_vector(3 downto 0);
	HPS_SPIM_CLK:                 out   std_logic;
	HPS_SPIM_MISO:                in    std_logic;
	HPS_SPIM_MOSI:                out   std_logic;
	HPS_SPIM_SS:                  inout std_logic;
	HPS_UART_RX:                  inout std_logic;
	HPS_UART_TX:                  inout std_logic;
	HPS_USB_CLKOUT:               in    std_logic;
	HPS_USB_DATA:                 inout std_logic_vector(7 downto 0);
	HPS_USB_DIR:                  in    std_logic;
	HPS_USB_NXT:                  in    std_logic;
	HPS_USB_STP:                  out   std_logic;

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

	signal probe                              : std_logic_vector(7 downto 0);
	signal probe_gnd                          : std_logic_vector(1 downto 0);
	
	signal CONNECTED_TO_hps_0_h2f_loan_io_in  : std_logic_vector(66 downto 0);
	signal CONNECTED_TO_hps_0_h2f_loan_io_out : std_logic_vector(66 downto 0);
	signal CONNECTED_TO_hps_0_h2f_loan_io_oe  : std_logic_vector(66 downto 0);

	signal reset_n                            : std_logic;

	signal hps_key_signal                     : std_logic;
	signal hps_led_signal                     : std_logic;

	component soc_system is
		port (
			clk_clk                                : in    std_logic                     := 'X';
			reset_reset_n                          : in    std_logic                     := 'X';
	
			hps_0_f2h_cold_reset_req_reset_n       : in    std_logic                     := 'X';
			hps_0_f2h_debug_reset_req_reset_n      : in    std_logic                     := 'X';
			hps_0_f2h_stm_hw_events_stm_hwevents   : in    std_logic_vector(27 downto 0) := (others => 'X');
			hps_0_f2h_warm_reset_req_reset_n       : in    std_logic                     := 'X';
				
			--HPS DDR3
			memory_mem_a                           : out   std_logic_vector(14 downto 0);
			memory_mem_ba                          : out   std_logic_vector(2 downto 0);
			memory_mem_ck                          : out   std_logic;
			memory_mem_ck_n                        : out   std_logic;
			memory_mem_cke                         : out   std_logic;
			memory_mem_cs_n                        : out   std_logic;
			memory_mem_ras_n                       : out   std_logic;
			memory_mem_cas_n                       : out   std_logic;
			memory_mem_we_n                        : out   std_logic;
			memory_mem_reset_n                     : out   std_logic;
			memory_mem_dq                          : inout std_logic_vector(31 downto 0) := (others => 'X');
			memory_mem_dqs                         : inout std_logic_vector(3 downto 0)  := (others => 'X');
			memory_mem_dqs_n                       : inout std_logic_vector(3 downto 0)  := (others => 'X');
			memory_mem_odt                         : out   std_logic;
			memory_mem_dm                          : out   std_logic_vector(3 downto 0);
			memory_oct_rzqin                       : in    std_logic                     := 'X';
	
			--HPS ethernet		
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK  : out   std_logic;
			hps_0_hps_io_hps_io_emac1_inst_TXD0    : out   std_logic;
			hps_0_hps_io_hps_io_emac1_inst_TXD1    : out   std_logic;
			hps_0_hps_io_hps_io_emac1_inst_TXD2    : out   std_logic;
			hps_0_hps_io_hps_io_emac1_inst_TXD3    : out   std_logic;
			hps_0_hps_io_hps_io_emac1_inst_RXD0    : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_emac1_inst_MDIO    : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_emac1_inst_MDC     : out   std_logic;
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL  : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL  : out   std_logic;
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK  : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_emac1_inst_RXD1    : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_emac1_inst_RXD2    : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_emac1_inst_RXD3    : in    std_logic                     := 'X';
			
			--HPS QSPI
			hps_0_hps_io_hps_io_qspi_inst_IO0      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_qspi_inst_IO1      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_qspi_inst_IO2      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_qspi_inst_IO3      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_qspi_inst_SS0      : out   std_logic;
			hps_0_hps_io_hps_io_qspi_inst_CLK      : out   std_logic;
			
			--HPS SD card
			hps_0_hps_io_hps_io_sdio_inst_CMD      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_sdio_inst_D0       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_sdio_inst_D1       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_sdio_inst_CLK      : out   std_logic;
			hps_0_hps_io_hps_io_sdio_inst_D2       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_sdio_inst_D3       : inout std_logic                     := 'X';
			
			--HPS USB
			hps_0_hps_io_hps_io_usb1_inst_D0       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_D1       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_D2       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_D3       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_D4       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_D5       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_D6       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_D7       : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_CLK      : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_STP      : out   std_logic;
			hps_0_hps_io_hps_io_usb1_inst_DIR      : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_usb1_inst_NXT      : in    std_logic                     := 'X';

			--HPS SPI
			hps_0_hps_io_hps_io_spim1_inst_CLK     : out   std_logic;
			hps_0_hps_io_hps_io_spim1_inst_MOSI    : out   std_logic;
			hps_0_hps_io_hps_io_spim1_inst_MISO    : in    std_logic                     := 'X';
			hps_0_hps_io_hps_io_spim1_inst_SS0     : out   std_logic;

			--HPS UART
			hps_0_hps_io_hps_io_uart0_inst_RX      : in    std_logic;
			hps_0_hps_io_hps_io_uart0_inst_TX      : out   std_logic;

			--HPS I2C
			hps_0_hps_io_hps_io_i2c0_inst_SDA      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_i2c0_inst_SCL      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_i2c1_inst_SDA      : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_i2c1_inst_SCL      : inout std_logic                     := 'X';
			
			--HPS GPIO
			hps_0_hps_io_hps_io_gpio_inst_GPIO09   : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_gpio_inst_GPIO35   : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_gpio_inst_GPIO40   : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_gpio_inst_GPIO48   : inout std_logic                     := 'X';

			--HPS LOANIO
			hps_0_h2f_loan_io_in                   : out   std_logic_vector(66 downto 0);
			hps_0_h2f_loan_io_out                  : in    std_logic_vector(66 downto 0) := (others => 'X');
			hps_0_h2f_loan_io_oe                   : in    std_logic_vector(66 downto 0) := (others => 'X');
			hps_0_h2f_reset_reset_n                : out   std_logic;
			hps_0_hps_io_hps_io_gpio_inst_LOANIO53 : inout std_logic                     := 'X';
			hps_0_hps_io_hps_io_gpio_inst_LOANIO54 : inout std_logic                     := 'X'
		);
	end component soc_system;

begin

	CONNECTED_TO_hps_0_h2f_loan_io_oe(53) <= '1';
	CONNECTED_TO_hps_0_h2f_loan_io_oe(54) <= '0';

	CONNECTED_TO_hps_0_h2f_loan_io_out(53) <= hps_led_signal;
	hps_key_signal <= CONNECTED_TO_hps_0_h2f_loan_io_in(54);
	
	u0 : component soc_system
		port map (
			clk_clk                                => CLOCK_50,
			reset_reset_n                          => '1',

			hps_0_f2h_cold_reset_req_reset_n       => '1',
			hps_0_f2h_debug_reset_req_reset_n      => '1',
			hps_0_f2h_stm_hw_events_stm_hwevents   => (others => '1'),
			--hps_0_f2h_warm_reset_req_reset_n        => CONNECTED_TO_hps_0_f2h_warm_reset_req_reset_n,

			--HPS DDR3
			memory_mem_a                           => HPS_DDR3_ADDR,
			memory_mem_ba                          => HPS_DDR3_BA,
			memory_mem_ck                          => HPS_DDR3_CK_P,
			memory_mem_ck_n                        => HPS_DDR3_CK_N,
			memory_mem_cke                         => HPS_DDR3_CKE,
			memory_mem_cs_n                        => HPS_DDR3_CS_N,
			memory_mem_ras_n                       => HPS_DDR3_RAS_N,
			memory_mem_cas_n                       => HPS_DDR3_CAS_N,
			memory_mem_we_n                        => HPS_DDR3_WE_N,
			memory_mem_reset_n                     => HPS_DDR3_RESET_N,
			memory_mem_dq                          => HPS_DDR3_DQ,
			memory_mem_dqs                         => HPS_DDR3_DQS_P,
			memory_mem_dqs_n                       => HPS_DDR3_DQS_N,
			memory_mem_odt                         => HPS_DDR3_ODT,
			memory_mem_dm                          => HPS_DDR3_DM,
			memory_oct_rzqin                       => HPS_DDR3_RZQ,

			--HPS ethernet		
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK  => HPS_ENET_GTX_CLK,
			hps_0_hps_io_hps_io_emac1_inst_TXD0    => HPS_ENET_TX_DATA(0),
			hps_0_hps_io_hps_io_emac1_inst_TXD1    => HPS_ENET_TX_DATA(1),
			hps_0_hps_io_hps_io_emac1_inst_TXD2    => HPS_ENET_TX_DATA(2),
			hps_0_hps_io_hps_io_emac1_inst_TXD3    => HPS_ENET_TX_DATA(3),
			hps_0_hps_io_hps_io_emac1_inst_RXD0    => HPS_ENET_RX_DATA(0),
			hps_0_hps_io_hps_io_emac1_inst_MDIO    => HPS_ENET_MDIO,
			hps_0_hps_io_hps_io_emac1_inst_MDC     => HPS_ENET_MDC,
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL  => HPS_ENET_RX_DV,
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL  => HPS_ENET_TX_EN,
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK  => HPS_ENET_RX_CLK,
			hps_0_hps_io_hps_io_emac1_inst_RXD1    => HPS_ENET_RX_DATA(1),
			hps_0_hps_io_hps_io_emac1_inst_RXD2    => HPS_ENET_RX_DATA(2),
			hps_0_hps_io_hps_io_emac1_inst_RXD3    => HPS_ENET_RX_DATA(3),
			
			--HPS QSPI
			hps_0_hps_io_hps_io_qspi_inst_IO0      => HPS_FLASH_DATA(0),
			hps_0_hps_io_hps_io_qspi_inst_IO1      => HPS_FLASH_DATA(1),
			hps_0_hps_io_hps_io_qspi_inst_IO2      => HPS_FLASH_DATA(2),
			hps_0_hps_io_hps_io_qspi_inst_IO3      => HPS_FLASH_DATA(3),
			hps_0_hps_io_hps_io_qspi_inst_SS0      => HPS_FLASH_NCSO,
			hps_0_hps_io_hps_io_qspi_inst_CLK      => HPS_FLASH_DCLK,
			
			--HPS SD card
			hps_0_hps_io_hps_io_sdio_inst_CMD      => HPS_SD_CMD,
			hps_0_hps_io_hps_io_sdio_inst_D0       => HPS_SD_DATA(0),
			hps_0_hps_io_hps_io_sdio_inst_D1       => HPS_SD_DATA(1),
			hps_0_hps_io_hps_io_sdio_inst_CLK      => HPS_SD_CLK,
			hps_0_hps_io_hps_io_sdio_inst_D2       => HPS_SD_DATA(2),
			hps_0_hps_io_hps_io_sdio_inst_D3       => HPS_SD_DATA(3),
			
			--HPS USB
			hps_0_hps_io_hps_io_usb1_inst_D0       => HPS_USB_DATA(0),
			hps_0_hps_io_hps_io_usb1_inst_D1       => HPS_USB_DATA(1),
			hps_0_hps_io_hps_io_usb1_inst_D2       => HPS_USB_DATA(2),
			hps_0_hps_io_hps_io_usb1_inst_D3       => HPS_USB_DATA(3),
			hps_0_hps_io_hps_io_usb1_inst_D4       => HPS_USB_DATA(4),
			hps_0_hps_io_hps_io_usb1_inst_D5       => HPS_USB_DATA(5),
			hps_0_hps_io_hps_io_usb1_inst_D6       => HPS_USB_DATA(6),
			hps_0_hps_io_hps_io_usb1_inst_D7       => HPS_USB_DATA(7),
			hps_0_hps_io_hps_io_usb1_inst_CLK      => HPS_USB_CLKOUT,
			hps_0_hps_io_hps_io_usb1_inst_STP      => HPS_USB_STP,
			hps_0_hps_io_hps_io_usb1_inst_DIR      => HPS_USB_DIR,
			hps_0_hps_io_hps_io_usb1_inst_NXT      => HPS_USB_NXT,
			
			--HPS SPI
			hps_0_hps_io_hps_io_spim1_inst_CLK     => HPS_SPIM_CLK,
			hps_0_hps_io_hps_io_spim1_inst_MOSI    => HPS_SPIM_MOSI,
			hps_0_hps_io_hps_io_spim1_inst_MISO    => HPS_SPIM_MISO,
			hps_0_hps_io_hps_io_spim1_inst_SS0     => HPS_SPIM_SS,

			--HPS UART
			hps_0_hps_io_hps_io_uart0_inst_RX       => HPS_UART_RX,
			hps_0_hps_io_hps_io_uart0_inst_TX       => HPS_UART_TX,

			--HPS I2C
			hps_0_hps_io_hps_io_i2c0_inst_SDA      => HPS_I2C1_SDAT,
			hps_0_hps_io_hps_io_i2c0_inst_SCL      => HPS_I2C1_SCLK,
			hps_0_hps_io_hps_io_i2c1_inst_SDA      => HPS_I2C2_SDAT,
			hps_0_hps_io_hps_io_i2c1_inst_SCL      => HPS_I2C2_SCLK,

			--HPS GPIO
			hps_0_hps_io_hps_io_gpio_inst_GPIO09   => HPS_CONV_USB_N,
			hps_0_hps_io_hps_io_gpio_inst_GPIO35   => HPS_ENET_INT_N,
			hps_0_hps_io_hps_io_gpio_inst_GPIO40   => HPS_LTC_GPIO,
			hps_0_hps_io_hps_io_gpio_inst_GPIO48   => HPS_I2C_CONTROL,

			--HPS LOANIO
			hps_0_h2f_loan_io_in                   => CONNECTED_TO_hps_0_h2f_loan_io_in,
			hps_0_h2f_loan_io_out                  => CONNECTED_TO_hps_0_h2f_loan_io_out,
			hps_0_h2f_loan_io_oe                   => CONNECTED_TO_hps_0_h2f_loan_io_oe,
			--hps_0_h2f_reset_reset_n                 => CONNECTED_TO_hps_0_h2f_reset_reset_n,
			hps_0_hps_io_hps_io_gpio_inst_LOANIO53 => HPS_LED,
			hps_0_hps_io_hps_io_gpio_inst_LOANIO54 => HPS_KEY
		);


	reset_n <= KEY(0);
	hps_led_signal <= hps_key_signal;

	LEDR(3) <= KEY(3);
	
	probe_gnd <= (others => '0');

	GPIO_1(27) <= probe(0);
	GPIO_1(26) <= probe(1);
	GPIO_1(29) <= probe(2);
	GPIO_1(28) <= probe(3);
	GPIO_1(31) <= probe(4);
	GPIO_1(30) <= probe(5);
	GPIO_1(33) <= probe(6);
	GPIO_1(32) <= probe(7);

	GPIO_1(35) <= probe_gnd(0);
	GPIO_1(34) <= probe_gnd(1);

end architecture rtl;
