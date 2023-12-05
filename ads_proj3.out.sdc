## Generated SDC file "ads_proj3.out.sdc"

## Copyright (C) 2023  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 22.1std.2 Build 922 07/20/2023 SC Lite Edition"

## DATE    "Mon Dec  4 21:03:53 2023"

##
## DEVICE  "10M50DAF484C8GES"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {new_adc_clock} -period 1000.000 -waveform { 0.000 500.000 } [get_ports {new_adc_clock}]
create_clock -name {clock_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clock_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {adc_pll|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {adc_pll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -master_clock {new_adc_clock} [get_pins {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clock_50}] -rise_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -fall_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -rise_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -rise_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -fall_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {clock_50}] -fall_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -rise_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -fall_to [get_clocks {clock_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -rise_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -rise_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -fall_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {clock_50}] -fall_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clock_50}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clock_50}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clock_50}] -setup 0.110  
set_clock_uncertainty -rise_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clock_50}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clock_50}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clock_50}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clock_50}] -setup 0.110  
set_clock_uncertainty -fall_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clock_50}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {adc_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

