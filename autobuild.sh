#!/bin/bash

set -e

# 创建 build 目录（如果不存在）
BUILD_DIR="$(pwd)/build"
if [ ! -d "$BUILD_DIR" ]; then
    mkdir "$BUILD_DIR"
fi

# 清空 build 目录
rm -rf "$BUILD_DIR"/*

# 进入 build 目录并执行 cmake 和 make
cd "$BUILD_DIR"
cmake ..
make

# 回到项目根目录
cd ..

# 创建 /usr/include/mymuduo 目录（如果不存在）
INCLUDE_DIR="/usr/include/mymuduo"
if [ ! -d "$INCLUDE_DIR" ]; then
    sudo mkdir -p "$INCLUDE_DIR"
fi

# 拷贝头文件到 /usr/include/mymuduo
for header in *.h; do
    sudo cp "$header" "$INCLUDE_DIR"
done

# 检查库文件并拷贝到 /usr/lib
LIB_FILE="$(pwd)/lib/libmyMuduo.so"
if [ -f "$LIB_FILE" ]; then
    sudo cp "$LIB_FILE" /usr/lib
else
    echo "Error: $LIB_FILE not found."
    exit 1
fi

# 更新共享库缓存
sudo ldconfig

echo "Build and installation completed successfully."
