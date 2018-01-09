#!/bin/bash
NASM=/usr/local/bin/nasm

if [ ! -f $NASM ]
 then
	echo "Please install nasm from nasm.us."
	echo "Compile with --prefix=/usr/local or modify path to nasm in the script."
	exit 1
fi

# default to 100m execs if not user specified
if [ $1 ]
 then 
  EXECS=$1
else
  EXECS=100000000
fi

for PROGRAM in *.asm; do
	$NASM $PROGRAM -f macho64 -DTOTAL_EXECS=${EXECS} && ld -macosx_version_min 10.12.0 -lSystem -o bench_${PROGRAM%%.asm} -image_base 0x0000000100000000 -pagezero_size 0x0000000100000000 ${PROGRAM%%.asm}.o
	chmod +x bench_${PROGRAM%%.asm}
	rm ${PROGRAM%%.asm}.o 
done

for PROGRAM in *.c; do
	clang -std=c99 -O2 -DTOTAL_EXECS=${EXECS} $PROGRAM -o bench_${PROGRAM%%.c}
	clang -std=c99 -arch i386 -O2 -DTOTAL_EXECS=${EXECS} $PROGRAM -o bench_${PROGRAM%%.c}_32
done
