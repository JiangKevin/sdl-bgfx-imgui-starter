#
reset
clear
#
export dev_root="/Users/kevin.jiang/Dev/src/github-res/sdl-bgfx-imgui-starter"
export app_name="hmi"
# 构建程序的编译中间路径
emcmake cmake -B embuild/release-emscripten -G Ninja \
    -DCMAKE_BUILD_TYPE=Release -DSUPERBUILD=ON
# 构建shader的编译路径
mkdir -p shader/embuild
./tools/macos/bin/shaderc \
    -f apps/${app_name}/shader/f_simple.sc -o apps/${app_name}/shader/embuild/f_simple.bin \
    --platform asmjs --type fragment --verbose -i ./

#
time_cur=$(date)
echo $time_cur
#
cmake --build embuild/release-emscripten
