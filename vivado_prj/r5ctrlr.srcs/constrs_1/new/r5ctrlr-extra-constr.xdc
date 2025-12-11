


set_property MARK_DEBUG true [get_nets design_1_i/QUAD_ADAQ23876_0/U0/conv_strobe]


set_property PULLTYPE PULLUP [get_ports PMOD1_4]
set_property PULLTYPE PULLUP [get_ports PMOD1_0]
set_property PULLTYPE PULLUP [get_ports PMOD1_1]



set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
