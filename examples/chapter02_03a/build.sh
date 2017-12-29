#!/usr/bin/env bash
#
# Copyright Christopher Kormanyos 2014.
# Distributed under the Boost Software License,
# Version 1.0. (See accompanying file LICENSE_1_0.txt
# or copy at http://www.boost.org/LICENSE_1_0.txt)
#


#
# Usage:
#
# If command
#     /usr/bin/avr-g++
# installed, e.g. via command   apt-get install gcc-avr avr-libc
# then:
# ./build.sh
#
# Otherwise for custom installations
# ./build.sh directory_of_gcc_bin avr
# For example,
# ./build.sh /usr/bin avr
#

if [[ $# == 0 ]]; then                   ##  $# is the number of arguments
    if [[ -n "$(which avr-g++)" ]]; then ## -n tests if string is not empty
        TOOL_PATH="$(dirname $(which avr-g++))"
        TOOL_PREFIX=avr
    else
        echo
        echo "Try:  apt-get install gcc-avr avr-libc"
        echo "Then: ./build.sh"
        echo "Otherwise, if you're using a custom avr, use: ./build.sh /directory/to/gcc_avr_bin Prefix"
        echo "                                              (such that /directory/to/gcc_avr_bin/Prefix-g++ is the name"
        echo "                                                   of the c++ compiler)"
        exit 1
    fi
else
    TOOL_PATH="$1"
    TOOL_PREFIX="$2"
fi

CFLAGS="-Wall -Wextra -pedantic -mmcu=atmega328p -fsigned-char -O2 -fno-exceptions"
CPPFLAGS="-std=c++11 -fno-rtti -fstrict-enums -fno-use-cxa-atexit -fno-use-cxa-get-exception-ptr -fno-nonansi-builtins -fno-threadsafe-statics -fno-enforce-eh-specs"
CINCLUDES="-Isrc -Isrc/mcal/avr -Isrc/util/STL -Isrc/util/STL_C++11_Compatibility -Isrc/util/STL_C++17_Compatibility"

echo
echo "Building with        : build.sh"
echo "Using tool path      : $TOOL_PATH"
echo "Using tool prefix    : $TOOL_PREFIX"
echo "Create bin directory : bin/"
mkdir -p bin
echo "Clean  bin directory : bin/*"
rm -f bin/*
echo

echo "Compile  : app_led.cpp to bin/app_led.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/app/led/app_led.cpp -o bin/app_led.o

echo "Compile  : mcal.cpp to bin/mcal.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/mcal.cpp -o bin/mcal.o

echo "Compile  : mcal_gcc_cxx_completion.cpp to bin/mcal_gcc_cxx_completion.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/mcal_gcc_cxx_completion.cpp -o bin/mcal_gcc_cxx_completion.o

echo "Compile  : mcal_cpu.cpp to bin/mcal_cpu.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/avr/mcal_cpu.cpp -o bin/mcal_cpu.o

echo "Compile  : mcal_gpt.cpp to bin/mcal_gpt.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/avr/mcal_gpt.cpp -o bin/mcal_gpt.o

echo "Compile  : mcal_irq.cpp to bin/mcal_irq.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/avr/mcal_irq.cpp -o bin/mcal_irq.o

echo "Compile  : mcal_led.cpp to bin/mcal_led.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/avr/mcal_led.cpp -o bin/mcal_led.o

echo "Compile  : mcal_osc.cpp to bin/mcal_osc.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/avr/mcal_osc.cpp -o bin/mcal_osc.o

echo "Compile  : mcal_port.cpp to bin/mcal_port.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/avr/mcal_port.cpp -o bin/mcal_port.o

echo "Compile  : mcal_wdg.cpp to bin/mcal_wdg.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/mcal/avr/mcal_wdg.cpp -o bin/mcal_wdg.o

echo "Compile  : os.cpp to bin/os.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/os/os.cpp -o bin/os.o

echo "Compile  : os.cpp to bin/os_task_control_block.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/os/os_task_control_block.cpp -o bin/os_task_control_block.o

echo "Compile  : sys_idle.cpp to bin/sys_idle.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/sys/idle/sys_idle.cpp -o bin/sys_idle.o

echo "Compile  : sys_mon.cpp to bin/sys_mon.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/sys/mon/sys_mon.cpp -o bin/sys_mon.o

echo "Compile  : sys_start.cpp to bin/sys_start.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c src/sys/start/sys_start.cpp -o bin/sys_start.o

echo "Compile  : crt0.cpp to bin/crt0.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c target/micros/avr/startup/crt0.cpp -o bin/crt0.o

echo "Compile  : crt0_init_ram.cpp to bin/crt0_init_ram.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c target/micros/avr/startup/crt0_init_ram.cpp -o bin/crt0_init_ram.o

echo "Compile  : crt1.cpp to bin/crt1.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c target/micros/avr/startup/crt1.cpp -o bin/crt1.o

echo "Compile  : int_vect.cpp to bin/int_vect.o"
$TOOL_PATH/$TOOL_PREFIX-g++ -x c++ $CFLAGS $CPPFLAGS $CINCLUDES -c target/micros/avr/startup/int_vect.cpp -o bin/int_vect.o

echo "Link     : objects to bin/chapter02_03a.elf"
$TOOL_PATH/$TOOL_PREFIX-g++ -x none -mrelax -nostartfiles $CFLAGS $CPPFLAGS $CINCLUDES -Wl,--gc-sections -Wl,-Ttarget/micros/avr/make/avr.ld,-Map,bin/chapter02_03a.map bin/app_led.o bin/mcal.o bin/mcal_gcc_cxx_completion.o bin/mcal_cpu.o bin/mcal_gpt.o bin/mcal_irq.o bin/mcal_led.o bin/mcal_osc.o bin/mcal_port.o bin/mcal_wdg.o bin/os.o bin/os_task_control_block.o bin/sys_idle.o bin/sys_mon.o bin/sys_start.o bin/crt0.o bin/crt0_init_ram.o bin/crt1.o bin/int_vect.o -o bin/chapter02_03a.elf

echo
echo "Extract  : executable hex file : from bin/chapter02_03a.elf"
$TOOL_PATH/$TOOL_PREFIX-objcopy -O ihex bin/chapter02_03a.elf bin/chapter02_03a.hex

echo "Extract  : assembly list file  : from bin/chapter02_03a.elf"
$TOOL_PATH/$TOOL_PREFIX-objdump -h -S bin/chapter02_03a.elf > bin/chapter02_03a.lss

echo "Extract  : size information    : from bin/chapter02_03a.elf"
$TOOL_PATH/$TOOL_PREFIX-size -A -t bin/chapter02_03a.elf > bin/chapter02_03a_size.txt

echo "Extract  : name information    : from bin/chapter02_03a.elf"
$TOOL_PATH/$TOOL_PREFIX-nm --numeric-sort --print-size bin/chapter02_03a.elf > bin/chapter02_03a_nm.txt

echo "Extract  : demangled names     : from bin/chapter02_03a.elf"
$TOOL_PATH/$TOOL_PREFIX-nm --numeric-sort --print-size bin/chapter02_03a.elf | $TOOL_PATH/$TOOL_PREFIX-c++filt > bin/chapter02_03a_cppfilt.txt