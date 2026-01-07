#!/bin/sh

CC="gcc"
LD="gcc"
CFLAGS="-c -g -m32"
LDFLAGS="-m32 -no-pie -z noexecstack"
LIBS=""
BUILD_DIR="./build"
OUT="snake"

mkdir -p $BUILD_DIR

for file in ./src/*.s; do
  base=`basename -s .s $file`
  $CC $CFLAGS $file -o ./$BUILD_DIR/$base.o
done

$LD $LDFLAGS $BUILD_DIR/*.o -o $OUT $LIBS
./$OUT "${@:2}"
