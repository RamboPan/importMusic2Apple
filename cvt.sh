#!/bin/bash

# 检查是否安装了 ffmpeg
if ! command -v ffmpeg &> /dev/null
then
    echo "Error: ffmpeg 未安装。请先安装 ffmpeg。"
    exit 1
fi

# 检查参数是否足够
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <import_directory> <export_directory>"
    exit 1
fi

# 输入和输出目录
import_dir="$1"
export_dir="$2"
error_log="$export_dir/error_log.txt"

# 检查导入目录是否存在
if [ ! -d "$import_dir" ]; then
    echo "Error: 导入目录 $import_dir 不存在。"
    exit 1
fi

# 创建导出目录（如果不存在）
mkdir -p "$export_dir"

# 清空错误日志文件
: > "$error_log"

# 查找所有文件并计算文件总数
total_files=$(find "$import_dir" -type f | wc -l)
if [ "$total_files" -eq 0 ]; then
    echo "Error: 未找到文件。"
    exit 1
fi

echo "共找到 $total_files 个文件，开始处理..."

# 初始化计数器
counter=1

# 遍历所有歌手目录
for artist_dir in "$import_dir"/*; do
    if [ -d "$artist_dir" ]; then
        # 遍历每个歌手目录下的所有文件
        for song in "$artist_dir"/*; do
            if [ -f "$song" ]; then
                # 确定输出文件夹结构
                rel_path="${song#$import_dir/}"
                output_dir="$export_dir/$(dirname "$rel_path")"
                mkdir -p "$output_dir"

                # 获取文件扩展名
                ext="${song##*.}"
                # 处理不同文件类型
                if [ "$ext" = "flac" ]; then
                    # 转换 FLAC 文件为 MP3，指定比特率 320k，并显式指定编码器
                    output_file="$output_dir/$(basename "${song%.flac}.mp3")"
                    echo "正在转换文件 ($counter/$total_files): $song -> $output_file"
                    
                    # 使用 libmp3lame 编码器，忽略非音频流，并增加 analyzeduration 和 probesize
                    ffmpeg -analyzeduration 100M -probesize 50M -i "$song" -vn -c:a libmp3lame -b:a 320k "$output_file" > /dev/null 2> ffmpeg_errors.txt
                    if [ $? -ne 0 ]; then
                        echo "Error: 转换 $song 失败。" | tee -a "$error_log"
                    else
                        echo "转换成功: $output_file"
                    fi
                elif [ "$ext" = "lrc" ] || [ "$ext" = "mp3" ] || [ "$ext" = "wav" ]; then
                    # 直接复制 LRC 和 MP3 文件
                    echo "正在复制文件 ($counter/$total_files): $song -> $output_dir/"
                    cp "$song" "$output_dir/"
                    if [ $? -ne 0 ]; then
                        echo "Error: 复制 $song 失败。" | tee -a "$error_log"
                    else
                        echo "复制成功: $song"
                    fi
                else
                    echo "跳过不支持的文件 ($counter/$total_files): $song"
                fi

                # 更新计数器
                counter=$((counter + 1))
            fi
        done
    fi
done

echo "所有文件已处理完成。"