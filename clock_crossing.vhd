library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_crossing is
    generic (
        data_width: natural := 16  -- Width of the data
    );
    port (
        clk_a: in std_logic;
        clk_b: in std_logic;
        rst: in std_logic;
        bin_in: in std_logic_vector(data_width - 1 downto 0);  -- Binary input
        bin_out: out std_logic_vector(data_width - 1 downto 0) -- Binary output
    );
end entity clock_crossing;

architecture Behavioral of clock_crossing is

    -- Internal signal declaration
    signal gray_code: std_logic_vector(data_width - 1 downto 0);
    signal synchronized_gray_code: std_logic_vector(data_width - 1 downto 0);

    -- Component instances
    component bin_to_gray is
        generic (
            input_width: positive := 16
        );
        port (
            bin_in: in std_logic_vector(input_width - 1 downto 0);
            gray_out: out std_logic_vector(input_width - 1 downto 0)
        );
    end component bin_to_gray;

    component gray_to_bin is
        generic (
            input_width: positive := 16
        );
        port (
            gray_in: in std_logic_vector(input_width - 1 downto 0);
            bin_out: out std_logic_vector(input_width - 1 downto 0)
        );
    end component gray_to_bin;

    component synchronizer is
        generic (
            data_width: natural := 4
        );
        port (
            clk_a: in std_logic;
            clk_b: in std_logic;
            rst: in std_logic;
            data_in: in std_logic_vector(data_width - 1 downto 0);
            data_out: out std_logic_vector(data_width - 1 downto 0)
        );
    end component synchronizer;

begin

    -- Instance of bin_to_gray
    b2g: bin_to_gray
        generic map (input_width => data_width)
        port map (
            bin_in => bin_in,
            gray_out => gray_code
        );

    -- Instance of synchronizer
    sync: synchronizer
        generic map (data_width => data_width)
        port map (
            clk_a => clk_a,
            clk_b => clk_b,
            rst => rst,
            data_in => gray_code,
            data_out => synchronized_gray_code
        );

    -- Instance of gray_to_bin
    g2b: gray_to_bin
        generic map (input_width => data_width)
        port map (
            gray_in => synchronized_gray_code,
            bin_out => bin_out
        );

end Behavioral;
