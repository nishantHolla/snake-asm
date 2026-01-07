#!/bin/sh

CC="gcc"
LD="gcc"
CFLAGS="-c -g -m32 -Iinclude"
LDFLAGS="-m32 -no-pie -z noexecstack -Llib"
LIBS="-lraylib -lm -ldl -lpthread -lX11 -lGL"
BUILD_DIR="./build"
OUT="snake"

mkdir -p $BUILD_DIR
rm -r $BUILD_DIR/*.o

cd src
for file in ./[^_]*.s; do
  base=`basename -s .s $file`
  $CC $CFLAGS $file -o ../$BUILD_DIR/$base.o
done
cd ..

$LD $LDFLAGS $BUILD_DIR/*.o -o $OUT $LIBS
./$OUT "${@:2}"
