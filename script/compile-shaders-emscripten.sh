#!/bin/bash

# compile shaders

mkdir -p shader/embuild

# simple shader
./tools/macos/bin/shaderc \
    -f shader/v_simple.sc -o shader/embuild/v_simple.bin \
    --platform asmjs --type vertex --verbose -i ./

./tools/macos/bin/shaderc \
    -f shader/f_simple.sc -o shader/embuild/f_simple.bin \
    --platform asmjs --type fragment --verbose -i ./
