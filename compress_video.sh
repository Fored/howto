#!/bin/bash
EXTENSION=mp4
mkdir ./compressed 2> /dev/null
if [ ! -z $1 ];then
    if [[ $1  == -f ]]; then
        files=$2
    elif [[ $1  == -d ]]; then
        files=$(find -L $2/*.$EXTENSION )
    else
        echo " -f file; -d dir"
    fi
else
    files=$(find -L ./*.mp4 )
fi



while read file; do
    new_name=$(basename $file .$EXTENSION)
#     echo $new_name
    ffmpeg -y -i $file -c:v libx265 -preset slow -crf 25 ./compressed/$new_name.mp4
done <<< $files
