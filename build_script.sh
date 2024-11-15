#!/bin/bash
project_name="SerialTool"
example_name="examples"
example_pack_dll=0
# cmake_dir="/e/Qt/Tools/CMake_64/bin"
# ninja_dir="/e/Qt/Tools/Ninja"
#引用环境脚本中定义的路径，方便不同安装路径的电脑使用
source ./script/env.sh

# echo ${cmake_dir}
current_dir=$(pwd)
# echo curren dir =${current_dir}
output_dir="${current_dir}/build"
# echo ${output_dir}


if [ ! $1 ] ;then
    build_type=DEBUG
    
else
    build_type=$1
fi
echo "===========build TYPE:=======${build_type}============"

case ${build_type} in
  "DEBUG")
    output_dir="${output_dir}/Desktop_Qt_6_6_3_MinGW_64_bit-Debug" 
    build_type="-DCMAKE_BUILD_TYPE:STRING=Debug"
  ;;
  "RELEASE")
    output_dir="${output_dir}/Desktop_Qt_6_6_3_MinGW_64_bit-Release"
    build_type="-DCMAKE_BUILD_TYPE:STRING=Release"
  ;;
  "EXAMPLE")
    output_dir="${output_dir}/Desktop_Qt_6_6_3_MinGW_64_bit-Debug"
    example_pack_dll=1
  ;;
  *)
    echo "Unknown BUILD TYPE!"
    echo "argue should be 'DEBUG' or 'RELEASE'"
    exit 0
  ;;
esac

# echo "===========build TYPE:=======${build_type}============"

#设置临时环境变量(编译器，ninja等),不指定的话cmake configure时会报错找不到ninja
export PATH="${ninja_dir}":$PATH
# export PATH="/c/Qt/Tools/CMake_64/bin":$PATH
# export PATH="/c/Qt/6.6.3/mingw_64/bin":$PATH
# export PATH="/c/Qt/Tools/mingw1120_64/bin":$PATH
export PATH="${mingwLib_dir}":$PATH
export PATH="${mingw_dir}":$PATH

# echo $PATH
# rm -f ./build
if [ ! -e ${output_dir} ]; then
    # echo undo
    mkdir ${output_dir}
    copy_dll=1
else
    copy_dll=0
fi
# exit 0
${cmake_dir}/cmake -S ./ -B ${output_dir}  -G 'Ninja' ${build_type} -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
# /c/Qt/Tools/CMake_64/bin/cmake.exe -S /c/Users/60173/Documents/Git/Gitee/SerialTool -B /c/Users/60173/Documents/Git/Gitee/SerialTool/build/Desktop_Qt_6_6_3_MinGW_64_bit-Release -DCMAKE_GENERATOR:STRING=Ninja -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_PROJECT_INCLUDE_BEFORE:FILEPATH=/c/Users/60173/Documents/Git/Gitee/SerialTool/build/Desktop_Qt_6_6_3_MinGW_64_bit-Release/.qtc/package-manager/auto-setup.cmake -DQT_QMAKE_EXECUTABLE:FILEPATH=C:/Qt/6.6.3/mingw_64/bin/qmake.exe -DCMAKE_PREFIX_PATH:PATH=C:/Qt/6.6.3/mingw_64 -DCMAKE_C_COMPILER:FILEPATH=C:/Qt/Tools/mingw1120_64/bin/gcc.exe -DCMAKE_CXX_COMPILER:FILEPATH=C:/Qt/Tools/mingw1120_64/bin/g++.exe -DCMAKE_CXX_FLAGS_INIT:STRING= in /c/Users/60173/Documents/Git/Gitee/SerialTool/build/Desktop_Qt_6_6_3_MinGW_64_bit-Release
${cmake_dir}/cmake --build ${output_dir} --target all
#单独使用ninja编译
# cd ${output_dir}
# ${ninja_dir}/ninja all -j 4
#运行程序
# ${output_dir}/${project_name}.exe
#打包发布，并复制所有动态链接库，以使调试时不依赖动态库环境变量
if [ ${copy_dll} -eq 1 ]; then
windeployqt ${output_dir}/${project_name}.exe
fi
if [ ${example_pack_dll} -eq 1 ]; then
windeployqt ${output_dir}/examples/${example_name}.exe
fi