cmake_minimum_required(VERSION 3.24)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY $ENV{dev_root}/website/$ENV{app_name})

option(SUPERBUILD "Perform a superbuild (or not)" ON)

project($ENV{app_name} LANGUAGES CXX)

if(SUPERBUILD)
  if(EMSCRIPTEN)
    set(THIRD_PARTY_BUILD_DIR_NAME embuild)
  else()
    set(THIRD_PARTY_BUILD_DIR_NAME build)
  endif()

  include(third-party/CMakeLists.txt)
  include(cmake/superbuild.cmake)
  return()
endif()

find_package(SDL2 REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)
find_package(bgfx REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)
find_package(imgui.cmake REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)

add_executable(${PROJECT_NAME})

# 添加源码
file(GLOB app_src
  ./apps/hmi/src/*.cpp

  # *.cpp
)

# 编译的源码
target_sources(${PROJECT_NAME} PUBLIC
  ${app_src}
  sdl-imgui/imgui_impl_sdl2.cpp
  bgfx-imgui/imgui_impl_bgfx.cpp
)

#
target_include_directories($ENV{app_name} PUBLIC
  $ENV{dev_root}
)

#
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_11)

#
target_link_libraries(
  ${PROJECT_NAME} PRIVATE SDL2::SDL2-static SDL2::SDL2main bgfx::bgfx bgfx::bx
  imgui.cmake::imgui.cmake
)

#
target_link_options(
  ${PROJECT_NAME} PRIVATE $<$<BOOL:${EMSCRIPTEN}>:-sMAX_WEBGL_VERSION=2
  -sALLOW_MEMORY_GROWTH=1 --preload-file $ENV{dev_root}/apps/$ENV{app_name}/shader@shader >
)

#
target_compile_definitions(
  ${PROJECT_NAME} PRIVATE $<$<BOOL:${EMSCRIPTEN}>:USE_SDL=2>
)
#
if(EMSCRIPTEN)
  set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")
endif()
