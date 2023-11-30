library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.project_pkg.all;
use work.seven_segment_pkg.all;

entity top_level is
    generic (
        ADDR_WIDTH: natural := 12
    );
    port (
        clock_50: in std_logic;
        new_adc_clock: in std_logic; -- Changed signal name
		  reset:	in std_logic;
        displays: out seven_segment_array(0 to 2)
    );
end entity top_level;

architecture driver of top_level is
    constant DATA_WIDTH: natural := 12;

    signal adc_clock: std_logic; -- Corrected signal name
    signal producer_clock: std_logic;
    signal consumer_clock: std_logic; -- Assuming you have a consumer clock

    signal soc, eoc: std_logic;
    signal adc_out: natural range 0 to 2**DATA_WIDTH - 1;
    signal buffer_in: std_logic_vector((DATA_WIDTH - 1) downto 0);
    signal buffer_out: std_logic_vector((DATA_WIDTH - 1) downto 0);

    signal buffer_write: std_logic;
	 
	 signal tail_ptr_a, head_ptr_a, tail_ptr_b, head_ptr_b: natural range 0 to 2**ADDR_WIDTH - 1;
	 signal tail_ptr_a_vect, tail_ptr_b_vect: std_logic_vector(ADDR_WIDTH - 1 downto 0);
	 signal head_ptr_a_vect, head_ptr_b_vect: std_logic_Vector(ADDR_WIDTH - 1 downto 0);

    -- Added signals for synchronizer
    signal sync_data_in : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal sync_data_out : std_logic_vector(DATA_WIDTH - 1 downto 0);
	
begin

	-- clock domain B things (1 MHz)
    producer_fsm: adc_producer
        generic map (
            ADDR_WIDTH => 12
        )
        port map (
            clock => producer_clock,
            reset => reset,
            tail_ptr => tail_ptr_b,
            eoc => eoc,
            soc => soc,
            buffer_write => buffer_write,
            head_ptr => head_ptr_b
        );

	
	-- clock domain A things (50 MHz)
    cons_fsm: adc_control
        generic map (
            ADDR_WIDTH => 12
        )
        port map (
            clock => clock_50,
            reset => reset,
            head_ptr => head_ptr_a,
            tail_ptr => tail_ptr_a
        );
	
	
	-- clock domain crossing sychnronizers
	-- from A to B
	tail_ptr_a_vect <= std_logic_vector(to_unsigned(tail_ptr_a, ADDR_WIDTH));
	tail_ptr_b <= to_integer(unsigned(tail_ptr_b_vect));
	a_to_b_crossing: clock_crossing
		generic map (
			data_width => ADDR_WIDTH
		)
		port map (
			clk_a =>		clock_50,	
			clk_b =>		producer_clock,
			rst =>		reset,
			bin_in =>	tail_ptr_a_vect,
			bin_out =>	tail_ptr_b_vect
			
		);
	
	-- from B to A
	head_ptr_b_vect <= std_logic_vector(to_unsigned(head_ptr_b, ADDR_WIDTH));
	head_ptr_a <= to_integer(unsigned(head_ptr_a_vect));
	b_to_a_crossing: clock_crossing
		generic map (
			data_width => ADDR_WIDTH
		)
		port map (
			clk_a =>		producer_clock,	
			clk_b =>		clock_50,
			rst =>		reset,
			bin_in =>	head_ptr_b_vect,
			bin_out =>	head_ptr_a_vect
		);
	-- RAM buffer
	memory: true_dual_port_ram_dual_clock
	generic map (
			DATA_WIDTH => DATA_WIDTH,
			ADDR_WIDTH => ADDR_WIDTH
		)
		port map (
			clk_a => clock_50,
			clk_b => producer_clock,
			addr_a => tail_ptr_a,
			addr_b => head_ptr_b,
			data_a => (others => '0'),	-- not writing anything
			data_b => buffer_in,
			we_a => '0',					-- seriously, not writing anything
			we_b => buffer_write,
			q_a => buffer_out,
			q_b => open						-- not reading anything
		);


	---- REGROUP stuff below into groups above
	
	
    adc_pll: pll
        port map (
            inclk0 => new_adc_clock,
            c0 => adc_clock 
        );

    adc: max10_adc
        port map (
            pll_clk => adc_clock,
            chsel => 0,
            soc => soc,
            tsen => '1',
            dout => adc_out,
            eoc => eoc,
            clk_dft => producer_clock
        );

    buffer_in <= std_logic_vector(to_unsigned(adc_out, DATA_WIDTH));

    -- Synchronize buffer_out before feeding into synchronizer
    sync_data_in <= buffer_out;
   
	
end architecture driver;
