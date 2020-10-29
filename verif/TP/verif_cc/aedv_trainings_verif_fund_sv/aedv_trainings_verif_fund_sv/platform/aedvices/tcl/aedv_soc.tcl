
proc aed_soc_compile_test {{testarg ""}} {
	global AMBER_BASE CODESOURCERY DIRUTILS PUTS TB_MESSAGE_ADDR TEMP_MEM err
	global OUT_LINE
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
		#	cd [file dirname $filename]
		set testdir [file dirname $filename]
		set shortfilename [file tail $filename]
		set testname [file root $shortfilename]
	
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


		$PUTS "$CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -O3 -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/main/$testname.o $filename"
		exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-gcc -c -O3 -march=armv2a -mno-thumb-interwork -ffreestanding -I$AMBER_BASE/sw/include   -c -o obj/main/$testname.o $filename
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

		exec   $CODESOURCERY/bin/arm-none-linux-gnueabi-objdump -D obj/main/$testname.elf > obj/$testname.dis
	} err] } {
		$PUTS "Compilation Failed !"
		$PUTS "\t$err"
	}

	$PUTS "--"
	$PUTS "File obj/$testname.mem created !"
	$PUTS "=================================="
 

}


proc aed_soc_compile_rtl {{testarg ""}} {
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
	#	file delete -force work
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
		+define+LITLE_ENDIAN=1 \
		-f filelist.txt
}


proc aed_soc_find_obj_address {{filepath "obj/lab.map"  } {search "tb_message"}} {
  set f [open $filepath]
  set re {0x([a-fA-F0-9]+)(\s|$)}
  set OBJ_ADDR ""
  while {[gets $f data] != -1} {
    if {[string match *[string toupper $search]* [string toupper $data]] } {
        if {[regexp $re $data ->  var1]} {
                lappend result $var1
        set OBJ_ADDR "${result}"
        
        }
    } 
  }
  close $f
  return $OBJ_ADDR
}


proc aed_soc_compile_tb {{testarg ""}} {
	global VLOG_ARG AMBER_BASE simdir DIRUTILS AMBERSOC_HOME TB_MESSAGE_ADDR PUTS MESSAGE_EN_ADDR AMBER_TEST_NAME
	# TODO: common place holder for TB and RTL
  set TB_MESSAGE_ADDR ""
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


  set VLOG_ARG "${VLOG_ARG} +define+TB_MESSAGE_ADDR={TB_MESSAGE_ADDR}"
  
  if { $TB_MESSAGE_ADDR eq ""} {
    $PUTS "TB_MESSAGE_ADDR was not found, using default value"
    	# Compile TB
    vlog +acc -work work -timescale 1ns/10ps +incdir+${AMBER_BASE}/hw/vlog/lib \
		+incdir+${AMBER_BASE}/hw/vlog/system \
		+incdir+${AMBER_BASE}/hw/vlog/amber23 \
		+incdir+${AMBER_BASE}/hw/vlog/amber25 \
		+incdir+${AMBER_BASE}/hw/vlog/tb \
		+incdir+${AMBER_BASE}/hw/vlog/ethmac \
		+incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv \
		+define+BOOT_MEM_FILE="${BOOT_MEM_FILE}" \
		+define+MAIN_MEM_FILE="${MAIN_MEM_FILE}" \
		+define+AMBER_LOAD_MAIN_MEM=1 \
		+define+AMBER_LOG_FILE="${AMBER_LOG_FILE}" \
		+define+AMBER_TIMEOUT=${AMBER_TIMEOUT} \
		+define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL} \
		+define+AMBER_TEST_NAME="${AMBER_TEST_NAME}" \
		${TOP_FILES}
    
  } else {
    set VLOG_ARG "${VLOG_ARG} +define+TB_MESSAGE_ADDR={TB_MESSAGE_ADDR}"
  	# Compile TB
    vlog +acc -work work -timescale 1ns/10ps +incdir+${AMBER_BASE}/hw/vlog/lib \
		+incdir+${AMBER_BASE}/hw/vlog/system \
		+incdir+${AMBER_BASE}/hw/vlog/amber23 \
		+incdir+${AMBER_BASE}/hw/vlog/amber25 \
		+incdir+${AMBER_BASE}/hw/vlog/tb \
		+incdir+${AMBER_BASE}/hw/vlog/ethmac \
		+incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv \
		+define+BOOT_MEM_FILE="${BOOT_MEM_FILE}" \
		+define+MAIN_MEM_FILE="${MAIN_MEM_FILE}" \
		+define+AMBER_LOAD_MAIN_MEM=1 \
		+define+AMBER_LOG_FILE="${AMBER_LOG_FILE}" \
		+define+AMBER_TIMEOUT=${AMBER_TIMEOUT} \
		+define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL} \
		+define+AMBER_TEST_NAME="${AMBER_TEST_NAME}" \
		${TOP_FILES}
  

  }  
  

		
}

proc aed_soc_load_sim {{testarg ""}} {
	global PUTS SIMULATOR AMBER_TEST_NAME

    if { $testarg eq "" } {
    set filename [.top.fTest.enTest get]
  } else {
    set filename $testarg
  }
	set shortfilename [file tail $filename]
	set testname [file root $shortfilename]
  set AMBER_TEST_NAME $testname
  
  
  set TB_MESSAGE_ADDR [aed_soc_find_obj_address "obj/$AMBER_TEST_NAME.map" "tb_message"]
  set MESSAGE_EN_ADDR [aed_soc_find_obj_address "obj/$AMBER_TEST_NAME.map" "msg_enable"]
    
	vsim tb +TB_MSG_ADDR=${TB_MESSAGE_ADDR} +TB_MSG_EN_ADDR=${MESSAGE_EN_ADDR}
	do wave_soc.do
}
