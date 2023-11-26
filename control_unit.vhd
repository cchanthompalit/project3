library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic; -- Clock signal
        rst : in std_logic; -- Asynchronous reset signal
        data_in : in std_logic_vector(11 downto 0); -- Data input for writing to mem
        data_out : out std_logic_vector(11 downto 0); -- Data output from reading mem
        write_enable : in std_logic; -- Signal to enable writing to mem
        read_enable : in std_logic; -- Signal to enable reading from mem
        mem_address : out std_logic_vector (10 downto 0); -- Address for mem
        mem_wren : out std_logic; -- Write enable for mem
        mem_rden : out std_logic; -- Read enable for mem
        buffer_full : out std_logic; -- Indicates when the buffer is full
        buffer_empty : out std_logic -- Indicates when the buffer is empty
    );
end entity control_unit;

architecture Behavioral of control_unit is
    constant BUFFER_SIZE : natural := 2048;
    signal head : natural := 0;
    signal tail : natural := 0;

begin
    -- Control unit process
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset logic
            head <= 0;
            tail <= 0;
        elsif rising_edge(clk) then
            -- Calculate address from head or tail
            mem_address <= std_logic_vector(to_unsigned(head, mem_address'length));

            -- Buffer write logic
            if write_enable = '1' and not buffer_full then
                mem_data <= data_in;
                mem_wren <= '1';
                head <= (head + 1) mod BUFFER_SIZE;
            else
                mem_wren <= '0';
            end if;

            -- Buffer read logic
            if read_enable = '1' and not buffer_empty then
                mem_rden <= '1';
                data_out <= mem_data;
                tail <= (tail + 1) mod BUFFER_SIZE;
            else
                mem_rden <= '0';
            end if;

            -- Update buffer status signals
            buffer_full <= '1' when (head + 1) mod BUFFER_SIZE = tail else '0';
            buffer_empty <= '1' when head = tail else '0';
        end if;
    end process;
end architecture Behavioral;
