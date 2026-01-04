# Clock (100 MHz onboard oscillator)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name sys_clk -period 10.00 [get_ports clk]

# Reset button (BTN0)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# North-South straight LEDs
set_property PACKAGE_PIN U16 [get_ports northsouth_red]
set_property IOSTANDARD LVCMOS33 [get_ports northsouth_red]

set_property PACKAGE_PIN E19 [get_ports northsouth_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports northsouth_yellow]

set_property PACKAGE_PIN U19 [get_ports northsouth_green]
set_property IOSTANDARD LVCMOS33 [get_ports northsouth_green]

# East-West straight LEDs
set_property PACKAGE_PIN V19 [get_ports eastwest_red]
set_property IOSTANDARD LVCMOS33 [get_ports eastwest_red]

set_property PACKAGE_PIN W18 [get_ports eastwest_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports eastwest_yellow]

set_property PACKAGE_PIN U15 [get_ports eastwest_green]
set_property IOSTANDARD LVCMOS33 [get_ports eastwest_green]

# North-South left-turn LEDs
set_property PACKAGE_PIN U14 [get_ports northsouth_left_red]
set_property IOSTANDARD LVCMOS33 [get_ports northsouth_left_red]

set_property PACKAGE_PIN V14 [get_ports northsouth_left_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports northsouth_left_yellow]

set_property PACKAGE_PIN V13 [get_ports northsouth_left_green]
set_property IOSTANDARD LVCMOS33 [get_ports northsouth_left_green]

# East-West left-turn LEDs
set_property PACKAGE_PIN V3 [get_ports eastwest_left_red]
set_property IOSTANDARD LVCMOS33 [get_ports eastwest_left_red]

set_property PACKAGE_PIN W3 [get_ports eastwest_left_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports eastwest_left_yellow]

set_property PACKAGE_PIN U3 [get_ports eastwest_left_green]
set_property IOSTANDARD LVCMOS33 [get_ports eastwest_left_green]
