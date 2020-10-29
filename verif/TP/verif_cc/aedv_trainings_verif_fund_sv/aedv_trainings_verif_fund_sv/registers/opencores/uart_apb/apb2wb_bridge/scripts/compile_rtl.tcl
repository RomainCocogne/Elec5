

set MODULE_PATH             [file normalize [info script]/../..]
echo "# Compiling apb2wb_bridge.v : started"
eval vlog +acc +cover -incr \
  +incdir+${MODULE_PATH}/src \
  ${MODULE_PATH}/src/apb2wb_bridge.v
echo "# Compilation of apb2wb_bridge.v : done !!"


