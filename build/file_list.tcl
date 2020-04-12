#add constraints
add_files -fileset constrs_1 -norecurse ./constraints/pinout.xdc

#add source
add_files ../source/qwi05_hdmi.v
add_files ../source/qwi_regctrl.v
add_files ../source/led_indicator.v
add_files ../source/rgb2dvi
add_files ../source/define
add_files ../source/hdmi

import_ip ../source/ips/clk_wiz_0.xci
import_ip ../source/ips/clk_wiz_1.xci

#global define
#set_property is_global_include true [get_files define.vh]
