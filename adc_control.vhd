library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity adc_control is
	port (
		clk_10MHz: in std_logic; 							-- 10 MHz clk into ADC
		reset:	  in std_logic;							-- Reset
		adc_data:  out std_logic_vector(11 downto 0);-- 12-bit ADC data
		clk_out:	  out std_logic;
		sent_data: out std_logic_vector(7 downto 0)
);
	
end adc_control;

architecture rtl of adc_control is
	signal adc_soc: std_logic;								-- start of conversion signal
	signal adc_tsen: std_logic;							-- temp sensing signal
	signal adc_dout: natural range 0 to 2**12 - 1;  -- data output signal
	signal adc_eoc: std_logic;								-- end of conversion signal
	signal adc_clk_dft: std_logic;						-- divided clk signal
	
	signal adc_convert_done: std_logic;							-- signals that conversion is complete
	signal adc_out: std_logic_vector(7 downto 0);			-- data obtained from ADC
	
	signal gray_input: std_logic;
	signal synched_output: std_logic;
	
	
begin
	
	-- 2-stage synchronizer
	synchronizer_inst: entity work.synchronizer
		port map (
			clk => adc_clk_dft,
			rst => reset,
			data_in => gray_input,
			data_out => synched_output
		);
		
	process (clk_10MHz, reset)
	begin
		if reset = '1' then
			gray_input <= '0';
		elsif rising_edge(clk_10MHz) then
			gray_input <= adc_clk_dft;
		end if;
	end process;
	
	-- ADC
	max10_adc_inst: entity work.max10_adc
		port map (
			pll_clk => clk_10MHz,
			chsel => adc_chsel,					   -- channel select
			soc => adc_soc,							-- start of conversion
			tsen => adc_tsen,							-- temp sensing signal
			dout => adc_dout,							-- data output
			eoc => adc_eoc,							-- end of conversion
			clk_dft => adc_clk_dft
		);
	
	-- assign ADC data output
	adc_data <= adc_out;
	
	

end rtl;
		
