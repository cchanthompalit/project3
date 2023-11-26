library ieee; 
use ieee.std_logic_1164.all; 

entity synchronizer is
    port ( 
			clk : in STD_LOGIC;
         rst : in STD_LOGIC;
         data_in : in STD_LOGIC;
         data_out : out STD_LOGIC
	 );
end synchronizer;

architecture Behavioral of synchronizer is
    signal intermediate : STD_LOGIC;
begin

    -- Synchronizer process
    process(clk, rst)
    begin
        if rst = '1' then
            -- Asynchronous reset (active high)
            intermediate <= '0';
            data_out <= '0';
        elsif rising_edge(clk) then
            -- First flip-flop captures the input signal
            intermediate <= data_in;
            -- Second flip-flop captures the output of the first flip-flop
            data_out <= intermediate;
        end if;
    end process;

end Behavioral;
