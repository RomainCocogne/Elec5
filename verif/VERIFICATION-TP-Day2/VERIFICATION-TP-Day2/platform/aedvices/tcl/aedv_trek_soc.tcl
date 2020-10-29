


proc aed_compile_trek_test {{testarg ""}} {
  global AMBER_BASE CODESOURCERY DIRUTILS PUTS
  
  if { ! [file exists obj] } {
    file mkdir obj
  }
  if { ! [file exists obj/lib] } {
    file mkdir obj/lib
  }
  if { ! [file exists obj/main] } {
    file mkdir obj/main
  }
  if { ! [file exists obj/boot] } {
    file mkdir obj/boot
  }

  # TODO: check if windows is open, if yes take this, else take the last ::testname
  if { $testarg eq "" } {
    set filename [.top.fTest.enTest get]
  } else {
    set filename $testarg
  }

  # HACK TODO we should have a separate configuration for this
  # If $BREKER_HOME is set we add the appropriate include 
  set INCDIR ""
  $PUTS ::env(BREKER_HOME) 
  if { [info exists ::env(BREKER_HOME) ]} {
    set INCDIR "-I$::env(BREKER_HOME)/libraries/trekbox/include"
    $PUTS "$INCDIR"

  } 
  
  set testdir [file dirname $filename]
  set shortfilename [file tail $filename]
  set testname [file root $shortfilename]
      if { [info exists ::env(BREKER_HOME)]} {
      if { [file exists "/$testdir/../src/hello.c"] } {
        file delete "/$testdir/../src/hello.c"
      }
      file copy /$testdir/../run/hello.c /$testdir/../src/
    }
  
  
  $PUTS "=================================="
  $PUTS "compiling $filename"
  $PUTS "=================================="
  if { [catch {


    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/lib/memcpy.o  $AMBER_BASE/sw/mini-libc/memcpy.c"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/lib/memcpy.o  $AMBER_BASE/sw/mini-libc/memcpy.c
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/lib/printf.o  $AMBER_BASE/sw/mini-libc/printf.c"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/lib/printf.o  $AMBER_BASE/sw/mini-libc/printf.c
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -I$AMBER_BASE/sw/include   -c -o obj/lib/libc_asm.o $AMBER_BASE/sw/mini-libc/libc_asm.S"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -I$AMBER_BASE/sw/include   -c -o obj/lib/libc_asm.o $AMBER_BASE/sw/mini-libc/libc_asm.S

    
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/boot-loader-serial.o $AMBER_BASE/sw/boot-loader-serial/boot-loader-serial.c"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/boot-loader-serial.o $AMBER_BASE/sw/boot-loader-serial/boot-loader-serial.c
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -I$AMBER_BASE/sw/include    -c -o obj/boot/start.o $AMBER_BASE/sw/boot-loader-serial/start.S"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -I$AMBER_BASE/sw/include    -c -o obj/boot/start.o $AMBER_BASE/sw/boot-loader-serial/start.S
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/crc16.o $AMBER_BASE/sw/boot-loader-serial/crc16.c"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/crc16.o $AMBER_BASE/sw/boot-loader-serial/crc16.c
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/xmodem.o $AMBER_BASE/sw/boot-loader-serial/xmodem.c"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/xmodem.o $AMBER_BASE/sw/boot-loader-serial/xmodem.c
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/elfsplitter.o $AMBER_BASE/sw/boot-loader-serial/elfsplitter.c"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -Os -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/boot/elfsplitter.o $AMBER_BASE/sw/boot-loader-serial/elfsplitter.c
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-ld -Bstatic -Map obj/boot-loader-serial.map  --strip-debug --fix-v4bx -o obj/boot/boot-loader-serial.elf -T $AMBER_BASE/sw/boot-loader-serial/sections.lds obj/boot/start.o obj/boot/boot-loader-serial.o obj/boot/crc16.o obj/boot/xmodem.o obj/boot/elfsplitter.o obj/lib/printf.o obj/lib/libc_asm.o obj/lib/memcpy.o"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-ld -Bstatic -Map obj/boot-loader-serial.map  --strip-debug --fix-v4bx -o obj/boot/boot-loader-serial.elf -T $AMBER_BASE/sw/boot-loader-serial/sections.lds obj/boot/start.o obj/boot/crc16.o obj/boot/xmodem.o obj/boot/elfsplitter.o obj/lib/printf.o obj/lib/libc_asm.o obj/lib/memcpy.o obj/boot/boot-loader-serial.o 
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-objcopy -R .comment -R .note obj/boot/boot-loader-serial.elf"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-objcopy -R .comment -R .note obj/boot/boot-loader-serial.elf


    


    $PUTS "$DIRUTILS/amber-elfsplitter obj/boot/boot-loader-serial.elf > obj/boot-loader-serial.mem"
    exec   $DIRUTILS/amber-elfsplitter obj/boot/boot-loader-serial.elf > obj/boot-loader-serial.mem
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-objdump -D obj/boot/boot-loader-serial.elf > obj/boot-loader-serial.dis
  #  cd [file dirname $filename]
    
    


    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -O3 -march=armv2a -mno-thumb-interwork -DSINGLE_CPU -DTREK_USE_STDINT_H  -ffreestanding -I$AMBER_BASE/sw/include $INCDIR  -c -o obj/main/$testname.o $filename"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -O3 -march=armv2a -mno-thumb-interwork -DSINGLE_CPU -DTREK_USE_STDINT_H  -ffreestanding -I$AMBER_BASE/sw/include $INCDIR  -c -o obj/main/$testname.o $filename


    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -I$AMBER_BASE/sw/include    -c -o obj/main/start.o $testdir/start.S"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -I$AMBER_BASE/sw/include    -c -o obj/main/start.o $testdir/start.S


    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-ld -Bstatic -Map obj/$testname.map  --strip-debug --fix-v4bx -o obj/main/$testname.flt -T $testdir/sections.lds obj/main/start.o obj/main/$testname.o obj/lib/printf.o obj/lib/libc_asm.o obj/lib/memcpy.o"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-ld -Bstatic -Map obj/$testname.map  --strip-debug --fix-v4bx -o obj/main/$testname.flt -T $testdir/sections.lds obj/main/start.o obj/main/$testname.o obj/lib/printf.o obj/lib/libc_asm.o obj/lib/memcpy.o
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-ld -Bstatic -Map obj/$testname.map  --strip-debug --fix-v4bx -o obj/main/$testname.elf -T $testdir/sections.lds obj/main/start.o obj/main/$testname.o obj/lib/printf.o obj/lib/libc_asm.o obj/lib/memcpy.o"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-ld -Bstatic -Map obj/$testname.map  --strip-debug --fix-v4bx -o obj/main/$testname.elf -T $testdir/sections.lds obj/main/start.o obj/main/$testname.o obj/lib/printf.o obj/lib/libc_asm.o obj/lib/memcpy.o
    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-objcopy -R .comment -R .note obj/main/$testname.elf"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-objcopy -R .comment -R .note obj/main/$testname.elf
    $PUTS "$DIRUTILS/amber-elfsplitter obj/main/$testname.elf > obj/$testname.mem"
    exec   $DIRUTILS/amber-elfsplitter obj/main/$testname.elf > obj/$testname.mem


    $PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-objdump -D obj/main/$testname.elf > obj/$testname.dis"
    exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-objdump -D obj/main/$testname.elf > obj/$testname.dis


    if { [info exists ::env(BREKER_HOME)]} {
      if { [file exists "hello.tbx"] } {
        file delete "hello.tbx"
      }
      file copy /$testdir/../run/hello.tbx .
    }

  } err] } {
    $PUTS "Compilation Failed !"
    $PUTS "\t$err"
  }

  $PUTS "--"
  $PUTS "File obj/$testname.mem created !"
  $PUTS "=================================="


}


proc aed_soc_compile_trek_rtl {{testarg ""}} {
  global VLOG_ARG AMBER_BASE simdir DIRUTILS PUTS AMBERSOC_HOME
  #cd $simdir

  if { $testarg eq "" } {
    set filename [.top.fTest.enTest get]
  } else {
    set filename $testarg
  }
  set testdir  [file dirname $filename]
  set bootdir  $AMBER_BASE/sw/boot-loader-serial
  set shortfilename [file tail $filename]
  set testname [file root $shortfilename]

  set ::env(AMBER_BASE) $AMBER_BASE
  set ::env(AMBERSOC_HOME) $AMBERSOC_HOME

  set BOOT_MEM_FILE obj/boot-loader-serial.mem
  set MAIN_MEM_FILE obj/$testname.mem
  set AMBER_TIMEOUT 0
  set AMBER_LOG_FILE "tests.log"
  set AMBER_SIM_CTRL 4
  set AMBER_TEST_NAME $testname

  set VLOG_ARG "+acc"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/lib"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/system"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber23"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber25"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/tb"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/ethmac"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBERSOC_HOME}/aedvices/socv"
  set VLOG_ARG "${VLOG_ARG} +define+BOOT_MEM_FILE=${BOOT_MEM_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+MAIN_MEM_FILE=${MAIN_MEM_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_LOG_FILE=${AMBER_LOG_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_TIMEOUT=${AMBER_TIMEOUT}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL}"
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_TEST_NAME={AMBER_TEST_NAME}"

  if { [file isdirectory work] } {
  #  file delete -force work
  } else {
    vlib work
  }
  vlog +acc -work work -timescale 1ns/10ps +incdir+${AMBER_BASE}/hw/vlog/lib \
    +incdir+${AMBER_BASE}/hw/vlog/system \
    +incdir+${AMBER_BASE}/hw/vlog/amber23 \
    +incdir+${AMBER_BASE}/hw/vlog/amber25 \
    +incdir+${AMBER_BASE}/hw/vlog/tb \
    +incdir+${AMBER_BASE}/hw/vlog/ethmac \
    +incdir+${AMBERSOC_HOME}/aedvices/socv \
    +define+BOOT_MEM_FILE="${BOOT_MEM_FILE}" \
    +define+MAIN_MEM_FILE="${MAIN_MEM_FILE}" \
    +define+AMBER_LOAD_MAIN_MEM=1 \
    +define+AMBER_LOG_FILE="${AMBER_LOG_FILE}" \
    +define+AMBER_TIMEOUT=${AMBER_TIMEOUT} \
    +define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL} \
    +define+AMBER_TEST_NAME="${AMBER_TEST_NAME}" \
    -f filelist.txt
}



proc aed_soc_compile_trek_tb {{testarg ""}} {
  global VLOG_ARG AMBER_BASE simdir DIRUTILS AMBERSOC_HOME TOP_FILES

  # TODO: common place holder for TB and RTL
  if { $testarg eq "" } {
    set filename [.top.fTest.enTest get]
  } else {
    set filename $testarg
  }


  set testdir  [file dirname $filename]
  set bootdir  $AMBER_BASE/sw/boot-loader-serial
  set shortfilename [file tail $filename]
  set testname [file root $shortfilename]

  set ::env(AMBER_BASE) $AMBER_BASE



  set BOOT_MEM_FILE obj/boot-loader-serial.mem
  set MAIN_MEM_FILE obj/$testname.mem
  set AMBER_TIMEOUT 0
  set AMBER_LOG_FILE "tests.log"
  set AMBER_SIM_CTRL 4
  set AMBER_TEST_NAME $testname

  set VLOG_ARG "+acc"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/lib"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/system"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber23"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber25"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/tb"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/ethmac"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBERSOC_HOME}/aedvices/uart_tb"
  set VLOG_ARG "${VLOG_ARG} +define+BOOT_MEM_FILE=${BOOT_MEM_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+MAIN_MEM_FILE=${MAIN_MEM_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_LOG_FILE=${AMBER_LOG_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_TIMEOUT=${AMBER_TIMEOUT}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL}"
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_TEST_NAME={AMBER_TEST_NAME}"

   if { [file exists "${testdir}/tb.sv"] } {
    set TOP_FILES "${testdir}/tb.sv"
  } else {
    set TOP_FILES "${AMBER_BASE}/hw/vlog/tb/tb.v"
  }  

  # HACK
  set INCDIR ""
  if { [info exists ::env(BREKER_HOME)]} {
    set INCDIR "+incdir+$::env(BREKER_HOME)/include"
  }


  # Compile TB
  	vlog +acc -cover bcs -work work -timescale 1ns/10ps +incdir+${AMBER_BASE}/hw/vlog/lib \
		+incdir+${AMBER_BASE}/hw/vlog/system \
		+incdir+${AMBER_BASE}/hw/vlog/amber23 \
		+incdir+${AMBER_BASE}/hw/vlog/amber25 \
		+incdir+${AMBER_BASE}/hw/vlog/tb \
		+incdir+${AMBER_BASE}/hw/vlog/ethmac \
		+incdir+${AMBERSOC_HOME}/aedvices/socv \
    +incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv/ \
    +incdir+${AMBERSOC_HOME}/aedvices/vip/wishbone/src/sv/ \
    +incdir+${AMBERSOC_HOME}/aedvices/uart_tb \
		+define+BOOT_MEM_FILE="${BOOT_MEM_FILE}" \
		+define+MAIN_MEM_FILE="${MAIN_MEM_FILE}" \
		+define+AMBER_LOAD_MAIN_MEM=1 \
		+define+AMBER_LOG_FILE="${AMBER_LOG_FILE}" \
		+define+AMBER_TIMEOUT=${AMBER_TIMEOUT} \
		+define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL} \
		+define+AMBER_TEST_NAME="${AMBER_TEST_NAME}" \
    +incdir+$::env(BREKER_HOME)/include \
		${TOP_FILES}

    
}

proc aed_soc_load_trek_sim {{testarg ""}} {
  global PUTS SIMULATOR TOP_FILES

  set TREKBOX_EVENTS_FILE "../../demos/TrekSoC/hello/run/hello.tbx"
  set LIB ""
  if { [info exists ::env(BREKER_HOME)]} {
    set LIB "-sv_lib $::env(BREKER_HOME)/lib/libtrekbox"
  }
  aed_cmd "vsim ${LIB} tb -coverage +TREKBOX_EVENTS_FILE=${TREKBOX_EVENTS_FILE} "
  do wave_soc.do

}
