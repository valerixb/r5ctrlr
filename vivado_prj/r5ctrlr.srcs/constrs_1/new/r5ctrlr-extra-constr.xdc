


set_property MARK_DEBUG true [get_nets design_1_i/QUAD_ADAQ23876_0/U0/conv_strobe]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/zynq_ultra_ps_e_0/U0/pl_clk0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/QUAD_ADAQ23876_0/U0/DB[0]} {design_1_i/QUAD_ADAQ23876_0/U0/DB[1]} {design_1_i/QUAD_ADAQ23876_0/U0/DB[2]} {design_1_i/QUAD_ADAQ23876_0/U0/DB[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/QUAD_ADAQ23876_0/U0/DA[0]} {design_1_i/QUAD_ADAQ23876_0/U0/DA[1]} {design_1_i/QUAD_ADAQ23876_0/U0/DA[2]} {design_1_i/QUAD_ADAQ23876_0/U0/DA[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[0]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[1]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[2]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[3]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[4]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[5]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[6]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[7]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[8]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[9]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[10]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[11]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[12]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[13]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[14]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[15]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[16]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[17]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[18]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[19]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[20]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[21]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[22]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[23]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[24]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[25]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[26]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[27]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[28]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[29]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[30]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_D_C[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[0]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[1]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[2]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[3]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[4]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[5]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[6]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[7]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[8]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[9]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[10]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[11]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[12]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[13]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[14]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[15]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[16]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[17]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[18]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[19]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[20]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[21]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[22]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[23]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[24]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[25]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[26]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[27]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[28]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[29]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[30]} {design_1_i/QUAD_ADAQ23876_0/U0/sample_B_A[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 24 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[0]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[1]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[2]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[3]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[4]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[5]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[6]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[7]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[8]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[9]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[10]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[11]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[12]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[13]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[14]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[15]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[16]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[17]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[18]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[19]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[20]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[21]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[22]} {design_1_i/AD3552_SPI_B/U0/DAC_wr_word[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[0]} {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[1]} {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[2]} {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[3]} {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[4]} {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[5]} {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[6]} {design_1_i/AD3552_SPI_B/U0/SPI_rbyte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {design_1_i/AD3552_SPI_B/U0/SDIO_t[0]} {design_1_i/AD3552_SPI_B/U0/SDIO_t[1]} {design_1_i/AD3552_SPI_B/U0/SDIO_t[2]} {design_1_i/AD3552_SPI_B/U0/SDIO_t[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[0]} {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[1]} {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[2]} {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[3]} {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[4]} {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[5]} {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[6]} {design_1_i/AD3552_SPI_B/U0/SPI_wbyte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 2 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {design_1_i/AD3552_SPI_B/U0/DAC_bytenum[0]} {design_1_i/AD3552_SPI_B/U0/DAC_bytenum[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 4 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {design_1_i/AD3552_SPI_B/U0/SDIO_i[0]} {design_1_i/AD3552_SPI_B/U0/SDIO_i[1]} {design_1_i/AD3552_SPI_B/U0/SDIO_i[2]} {design_1_i/AD3552_SPI_B/U0/SDIO_i[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 24 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[0]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[1]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[2]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[3]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[4]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[5]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[6]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[7]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[8]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[9]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[10]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[11]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[12]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[13]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[14]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[15]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[16]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[17]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[18]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[19]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[20]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[21]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[22]} {design_1_i/AD3552_SPI_B/U0/DAC_rd_word[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 4 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {design_1_i/AD3552_SPI_B/U0/SDIO_o[0]} {design_1_i/AD3552_SPI_B/U0/SDIO_o[1]} {design_1_i/AD3552_SPI_B/U0/SDIO_o[2]} {design_1_i/AD3552_SPI_B/U0/SDIO_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[0]} {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[1]} {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[2]} {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[3]} {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[4]} {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[5]} {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[6]} {design_1_i/AD3552_SPI_A/U0/SPI_rbyte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 4 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {design_1_i/AD3552_SPI_A/U0/SDIO_i[0]} {design_1_i/AD3552_SPI_A/U0/SDIO_i[1]} {design_1_i/AD3552_SPI_A/U0/SDIO_i[2]} {design_1_i/AD3552_SPI_A/U0/SDIO_i[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 2 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {design_1_i/AD3552_SPI_A/U0/DAC_bytenum[0]} {design_1_i/AD3552_SPI_A/U0/DAC_bytenum[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 4 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {design_1_i/AD3552_SPI_A/U0/errcode[0]} {design_1_i/AD3552_SPI_A/U0/errcode[1]} {design_1_i/AD3552_SPI_A/U0/errcode[2]} {design_1_i/AD3552_SPI_A/U0/errcode[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 4 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {design_1_i/AD3552_SPI_A/U0/SDIO_t[0]} {design_1_i/AD3552_SPI_A/U0/SDIO_t[1]} {design_1_i/AD3552_SPI_A/U0/SDIO_t[2]} {design_1_i/AD3552_SPI_A/U0/SDIO_t[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 24 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[0]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[1]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[2]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[3]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[4]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[5]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[6]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[7]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[8]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[9]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[10]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[11]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[12]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[13]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[14]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[15]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[16]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[17]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[18]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[19]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[20]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[21]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[22]} {design_1_i/AD3552_SPI_A/U0/DAC_rd_word[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 24 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[0]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[1]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[2]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[3]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[4]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[5]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[6]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[7]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[8]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[9]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[10]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[11]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[12]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[13]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[14]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[15]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[16]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[17]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[18]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[19]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[20]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[21]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[22]} {design_1_i/AD3552_SPI_A/U0/DAC_wr_word[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 4 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {design_1_i/AD3552_SPI_A/U0/SDIO_o[0]} {design_1_i/AD3552_SPI_A/U0/SDIO_o[1]} {design_1_i/AD3552_SPI_A/U0/SDIO_o[2]} {design_1_i/AD3552_SPI_A/U0/SDIO_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 8 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[0]} {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[1]} {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[2]} {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[3]} {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[4]} {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[5]} {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[6]} {design_1_i/AD3552_SPI_A/U0/SPI_wbyte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 4 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {design_1_i/AD3552_SPI_B/U0/errcode[0]} {design_1_i/AD3552_SPI_B/U0/errcode[1]} {design_1_i/AD3552_SPI_B/U0/errcode[2]} {design_1_i/AD3552_SPI_B/U0/errcode[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list design_1_i/AD3552_SPI_B/U0/busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list design_1_i/AD3552_SPI_A/U0/busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list design_1_i/QUAD_ADAQ23876_0/U0/conv_strobe]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list design_1_i/QUAD_ADAQ23876_0/U0/SCLK]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list design_1_i/AD3552_SPI_B/U0/SPI_busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list design_1_i/AD3552_SPI_A/U0/SPI_busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list design_1_i/AD3552_SPI_A/U0/SPI_CE]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list design_1_i/AD3552_SPI_B/U0/SPI_CE]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list design_1_i/AD3552_SPI_A/U0/SPI_CSn]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list design_1_i/AD3552_SPI_B/U0/SPI_CSn]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list design_1_i/AD3552_SPI_A/U0/SPI_RW]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list design_1_i/AD3552_SPI_B/U0/SPI_RW]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list design_1_i/AD3552_SPI_A/U0/SPI_SCLK]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list design_1_i/AD3552_SPI_B/U0/SPI_SCLK]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list design_1_i/AD3552_SPI_A/U0/SPI_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list design_1_i/AD3552_SPI_B/U0/SPI_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list design_1_i/AD3552_SPI_A/U0/start_transaction]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list design_1_i/AD3552_SPI_B/U0/start_transaction]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list design_1_i/AD3552_SPI_A/U0/XLATOR_DIR]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list design_1_i/AD3552_SPI_B/U0/XLATOR_DIR]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_pl_clk0]
