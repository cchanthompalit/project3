library ieee; 
use ieee.std_logic_1164.all; 

entity synchronizer is
	 generic (
		data_width: natural := 4
	 );
    port ( 
			clk_a : in STD_LOGIC;
			clk_b : in STD_LOGIC;
         rst : in STD_LOGIC;
         data_in : in STD_LOGIC_VECTOR(data_width - 1 downto 0);
         data_out : out STD_LOGIC(data_width - 1 downto 0)
	 );
end synchronizer;

architecture Behavioral of synchronizer is
	type synchronizer_chain_type is array(0 to 3) of std_logic_vector(data_in'range);
   signal intermediate : synchronizer_chain_type;
begin

	intermediate(0) <= data_in;
	data_out <= intermediate(3);

    -- Synchronizer process
    first_stage: process(clk_a, rst) is
    begin
        if rst = '0' then
            -- Asynchronous reset (active high)
            intermediate(1) <= (others => '0');
            -- data_out <= '0';
        elsif rising_edge(clk_a) then
            -- First flip-flop captures the input signal
            intermediate(1) <= intermediate(0);
            -- Second flip-flop captures the output of the first flip-flop
            -- data_out <= intermediate;
        end if;
    end process first_stage;

	 second_stage: process(clk_b, rst) is
	 begin
		if rst = '0' then
			intermediate(2) <= (others => '0');
		elsif rising_edge(clk_b) then
			intermediate(2) <= intermediate(1);	-- metastability problems
			intermediate(3) <= intermediate(2);
		end if;
	 end process second_stage;
	 
end Behavioral;
									  
