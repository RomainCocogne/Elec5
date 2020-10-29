

set MODULE_PATH             [file normalize [info script]/../..]

set INCDIR [list \
  +incdir+${MODULE_PATH}/src \
  +incdir+${MODULE_PATH}/../apb2wb_bridge/src \
]

echo "# Compiling uart_apb.v : started"
eval vlog +acc +cover -incr ${INCDIR} ${MODULE_PATH}/src/uart_apb.v
echo "# Compilation of uart_apb.v : done !!"

