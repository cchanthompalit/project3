library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Define a package to hold the types, constants, and functions
package seven_segment_pkg is

    -- Define custom types
    type seven_segment_config is record
        a, b, c, d, e, f, g: std_logic;
    end record;

    type seven_segment_array is array(natural range<>) of seven_segment_config;
	 type num_set_array is array (natural range<>) of std_logic_vector(0 to 3);

    type lamp_configuration is (common_anode, common_cathode);
    constant default_lamp_config: lamp_configuration := common_anode;

    -- Define a constant array for seven-segment display encoding
	constant seven_segment_table : seven_segment_array(0 to 15) := (
		0 => (a => '1', b => '1', c => '1', d => '1', e => '1', f => '1', g => '0'), -- 0
		1 => (a => '0', b => '1', c => '1', d => '0', e => '0', f => '0', g => '0'), -- 1
		2 => (a => '1', b => '1', c => '0', d => '1', e => '1', f => '0', g => '1'), -- 2
		3 => (a => '1', b => '1', c => '1', d => '1', e => '0', f => '0', g => '1'), -- 3
		4 => (a => '0', b => '1', c => '1', d => '0', e => '0', f => '1', g => '1'), -- 4
		5 => (a => '1', b => '0', c => '1', d => '1', e => '0', f => '1', g => '1'), -- 5
		6 => (a => '1', b => '0', c => '1', d => '1', e => '1', f => '1', g => '1'), -- 6
		7 => (a => '1', b => '1', c => '1', d => '0', e => '0', f => '0', g => '0'), -- 7
		8 => (a => '1', b => '1', c => '1', d => '1', e => '1', f => '1', g => '1'), -- 8
		9 => (a => '1', b => '1', c => '1', d => '1', e => '0', f => '1', g => '1'), -- 9
		10 => (a => '1', b => '1', c => '1', d => '0', e => '1', f => '1', g => '0'), -- A
		11 => (a => '0', b => '0', c => '1', d => '1', e => '1', f => '1', g => '1'), -- b
		12 => (a => '1', b => '0', c => '0', d => '1', e => '1', f => '1', g => '0'), -- C
		13 => (a => '0', b => '1', c => '1', d => '1', e => '1', f => '1', g => '0'), -- d
		14 => (a => '1', b => '0', c => '0', d => '1', e => '1', f => '1', g => '1'), -- E
		15 => (a => '1', b => '0', c => '0', d => '0', e => '1', f => '1', g => '1')  -- F
	);	

    -- Declare functions that will be defined later
    function get_hex_digit(
        digit: in natural;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config;

    function lamps_off(
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config;
	 
	 subtype hex_number is natural range 0 to 2**12 - 1;
	 -- Overload the 'not' operator for the seven_segment_config type
	function invert(input_config: seven_segment_config) 
	return seven_segment_config;
	
	function need_hex_number(
			num: in hex_number;
			lamp_mode: in lamp_configuration := default_lamp_config
	) return seven_segment_array;


	function get_output (
			num: in std_logic_vector(11 downto 0);
			lamp_mode: in lamp_configuration := default_lamp_config
		) return seven_segment_array;
	
end package seven_segment_pkg;

-- Define the package body
package body seven_segment_pkg is

    -- Define the function to turn on LED for each number
    function get_hex_digit(
        digit: in natural;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config is
    begin
        if lamp_mode = common_cathode then
            return invert(seven_segment_table(digit)); 
        else
            return seven_segment_table(digit); 
        end if;
    end function get_hex_digit;

    -- Define the function to turn lamps off
    function lamps_off(
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_config is
        variable off_config: seven_segment_config;
    begin
        if lamp_mode = common_anode then
            off_config := (others => '0');
        else
            off_config := (others => '1'); 
        end if;

        return off_config;
    end function lamps_off;
	 
	 
	 
		 -- Implementation of the overloaded 'not' operator
		function invert(input_config: seven_segment_config) return seven_segment_config is
			variable output_config: seven_segment_config;
		begin
			output_config.a := not input_config.a;
			output_config.b := not input_config.b;
			output_config.c := not input_config.c;
			output_config.d := not input_config.d;
			output_config.e := not input_config.e;
			output_config.f := not input_config.f;
			output_config.g := not input_config.g;
		return output_config;
	end function;

	function need_hex_number(
        num: in hex_number;
        lamp_mode: in lamp_configuration := default_lamp_config
    ) return seven_segment_array is
        variable ret: seven_segment_array(0 to 2);
        variable in_vec: std_logic_vector(0 to 11);
        variable num_set: num_set_array(0 to 2);
    begin
        in_vec := std_logic_vector(to_unsigned(num, 12));

        for i in 0 to 2 loop
            num_set(2 - i) := in_vec(i * 4 to i * 4 + 3);
            ret(i) := get_hex_digit(to_integer(unsigned(num_set(i))), lamp_mode);
        end loop;
        return ret;
    end function need_hex_number;
	 
	 function get_output (
			num: in std_logic_vector(11 downto 0);
			lamp_mode: in lamp_configuration := default_lamp_config
		) return seven_segment_array
	is
		variable ret: seven_segment_array(0 to 2);
		variable digit: natural;
	begin
		for i in ret'range loop
			digit := to_integer(unsigned(num(4*i + 3 downto 4*i)));
			ret(i) := get_hex_digit(digit, lamp_mode);
		end loop;
		return ret;
	end function get_output;
	
end package body seven_segment_pkg;
