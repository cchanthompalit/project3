library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity adc_control is
	port (
		clk_10MHz: in std_logic;
		reset:	  in std_logic;
		start_convert: in std_logic;
		adc_data: out std_logic_vector(7 downto 0);
		clk_50MHz: out std_logic;
		sent_data: out std_logic_vector(7 downto 0)
	);
end adc_control;

architecture rtl of adc_control is
	signal adc_clk: std_logic;
	signal adc_soc: std_logic;
	signal adc_tsen: std_logic;
	signal adc_dout: natural range 0 to 2**12 - 1;
	signal adc_eoc: std_logic;
	signal adc_clk_dft: std_logic;
	
	signal adc_convert_done: std_logic;
	signal internal_data: std_logic_vector(7 downto 0);
	
	signal gray_input: std_logic;
	signal synched_output: std_logic;
	
	
begin
	-- Clk divider
	process (clk_10MHz, reset)
	begin
		if reset = '1' then
			adc_clk <= '0';
		elsif rising_edge(clk_10MHz) then
			adc_clk <= not adc_clk;
		end if;
	end process;
	
	-- 2-stage synchronizer
	synchronizer_inst: entity work.synchronizer
		port map (
			gray_input => gray_input,
			output => synched_output
		);
		
	process (clk_10MHz, reset)
	begin
		if reset = '1' then
			gray_input <= '0';
		elsif rising_edge(clk_10MHz) then
			gray_input <= adc_clk;
		end if;
	end process;
	
	-- ADC
	max10_adc_inst: entity work.max10_adc
		port map (
			pll_clk => adc_clk,
			chsel => 
			soc => adc_soc,
			tsen => adc_tsen,
			dout => adc_dout,
			eoc => adc_eoc,
			clk_dft => adc_clk_dft
		);
	
	-- assign ADC data output
	adc_data <= internal_data;

end rtl;
	
		