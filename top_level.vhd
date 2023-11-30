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
        clock: in std_logic;
        new_adc_clock: in std_logic; -- Changed signal name
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

    signal tail_ptr, head_ptr, tail_producer, head_consumer: natural range 0 to 2**ADDR_WIDTH - 1;
    signal buffer_write: std_logic;

    -- Added signals for synchronizer
    signal sync_data_in : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal sync_data_out : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin
    adc_pll: pll
        port map (
            inclk0 => new_adc_clock,
            c0 => adc_clock -- Corrected signal name
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

    memory: true_dual_port_ram_dual_clock
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk_a => adc_clock,
            clk_b => producer_clock,
            addr_a => tail_ptr,
            addr_b => head_ptr,
            data_a => (others => '0'),
            data_b => buffer_in,
            we_a => '0',
            we_b => buffer_write,
            q_a => buffer_out,
            q_b => open
        );

    -- Synchronize buffer_out before feeding into synchronizer
    sync_data_in <= buffer_out;
    synchronizer_inst: synchronizer
        generic map (
            data_width => DATA_WIDTH
        )
        port map (
            clk_a => clock,
				clk_b => clock,
            rst => '0', 
            data_in => sync_data_in,
            data_out => sync_data_out
        );
    producer_fsm: adc_producer
        generic map (
            ADDR_WIDTH => 12
        )
        port map (
            clock => producer_clock,
            reset => '1',
            tail_ptr => tail_producer,
            eoc => eoc,
            soc => soc,
            buffer_write => buffer_write,
            head_ptr => head_ptr
        );

    cons_fsm: adc_control
        generic map (
            ADDR_WIDTH => 12
        )
        port map (
            clock => consumer_clock,
            reset => '1',
            head_ptr => head_consumer,
            tail_ptr => tail_ptr
        );

end architecture driver;
