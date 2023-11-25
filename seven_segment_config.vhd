type seven_segment_config is 
record 
a, b, c, d, e, f, g: std_logic; 
end record;

type seven_segment_array is array(natural range<>) of seven_segment_config;

type lamp_configuration is (common_anode, common_cathode); 
constant default_lamp_config: lamp_configuration := common_anode;

constant seven_segment_table : seven_segment_array := (
    "0111111", -- 0
    "0000110", -- 1
    "1011011", -- 2
    "1001111", -- 3
    "1100110", -- 4
    "1101101", -- 5
    "1111101", -- 6
    "0000111", -- 7
    "1111111", -- 8
    "1101111", -- 9
    "1110111", -- A
    "1111100", -- b
    "0111001", -- C
    "1011110", -- d
    "1111001", -- E
    "1110001"  -- F
);


function get_hex_digit (
       digit: in hex_digit;
       lamp_mode: in lamp_configuration := default_lamp_config
) return seven_segment_config is
begin
if lamp_mode = common_cathode then
      return not seven_segment_table(digit); 
else 
     return seven_segment_table(digit); 
end if; 
end get_hex_digit;


function lamps_off (
lamp_mode: in lamp_configuration := default_lamp_config
) return seven_segment_config;
	variable off_config : seven_segment_config;
begin
if lamp_mode = common_anode then 
    off_config := (others => '0');
else 
    off_config := (others => '1'); 
end if;

return off_config; 
end function;





