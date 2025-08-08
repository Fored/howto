#!/bin/bash

EXTENSION=mp4
OUTDIR="./compressed"

mkdir -p "$OUTDIR"

process_file() {
    local file="$1"
    local new_name
    new_name=$(basename "$file" ."$EXTENSION")
    echo "Processing: $file"
    ffmpeg -y -i "$file" -c:v libx264 -preset slow -map_metadata 0 -crf 25 "$OUTDIR/$new_name.$EXTENSION"
}

# Считываем список файлов в массив
get_file_list() {
    local target="$1"
    local -n out_array=$2  # ссылочная переменная

    if [[ -f "$target" ]]; then
        out_array+=("$target")

    elif [[ -d "$target" ]]; then
        while IFS= read -r -d '' file; do
            out_array+=("$file")
        done < <(find -L "$target" -type f -name "*.$EXTENSION" -print0)

    else
        echo "Error: '$target' is neither a file nor a directory"
        exit 1
    fi
}

# Основная логика
declare -a files

if [[ "$1" == "-f" && -n "$2" ]]; then
    get_file_list "$2" files

elif [[ "$1" == "-d" && -n "$2" ]]; then
    get_file_list "$2" files

elif [[ -z "$1" ]]; then
    get_file_list "." files

else
    echo "Usage:"
    echo "  $0               # compress all .$EXTENSION files in current dir"
    echo "  $0 -f file.mp4   # compress one specific file"
    echo "  $0 -d folder     # compress all .$EXTENSION files in folder"
    exit 1
fi

# Проход по массиву
for file in "${files[@]}"; do
    process_file "$file"
done
