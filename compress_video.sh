#!/bin/bash

OUTDIR="./compressed"
mkdir -p "$OUTDIR"

process_file() {
    local file="$1"
    local ext="${file##*.}"                     # расширение файла (mp4 или MOV)
    local base_name="$(basename "$file" ."$ext")"

    # Определяем кодек
    local codec
    codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name \
            -of default=noprint_wrappers=1:nokey=1 "$file")

    echo "Processing: $file"
    echo "Detected codec: $codec"

    if [[ "$codec" == "h264" ]]; then
        # Сжатие H.264
        ffmpeg -y -i "$file" \
            -c:v libx265 -preset slow -crf 28 \
            -tag:v hvc1 -pix_fmt yuv420p10le \
            -c:a copy \
            -map 0 \
            -map_metadata 0 \
            -movflags use_metadata_tags \
            "$OUTDIR/$base_name.mov"

    elif [[ "$codec" == "hevc" ]]; then
        # Сжатие H.265 (без Dolby Vision)
        ffmpeg -y -i "$file" \
            -c:v libx265 -preset slow -crf 28 \
            -tag:v hvc1 -pix_fmt yuv420p10le \
            -c:a copy \
            -map 0 \
            -map_metadata 0 \
            -movflags use_metadata_tags \
            "$OUTDIR/$base_name.$ext"

    else
        echo "⚠ Пропущено: неизвестный кодек $codec"
    fi
}

# Считывание списка файлов
get_file_list() {
    local target="$1"
    local -n out_array=$2

    if [[ -f "$target" ]]; then
        out_array+=("$target")
    elif [[ -d "$target" ]]; then
        while IFS= read -r -d '' file; do
            out_array+=("$file")
        done < <(find -L "$target" -type f \( -iname "*.mp4" -o -iname "*.mov" \) -print0)
    else
        echo "Error: '$target' is neither a file nor a directory"
        exit 1
    fi
}

declare -a files

if [[ "$1" == "-f" && -n "$2" ]]; then
    get_file_list "$2" files
elif [[ "$1" == "-d" && -n "$2" ]]; then
    get_file_list "$2" files
elif [[ -z "$1" ]]; then
    get_file_list "." files
else
    echo "Usage:"
    echo "  $0               # compress all mp4/MOV files in current dir"
    echo "  $0 -f file.mp4   # compress one specific file"
    echo "  $0 -d folder     # compress all mp4/MOV files in folder"
    exit 1
fi

for file in "${files[@]}"; do
    process_file "$file"
done
