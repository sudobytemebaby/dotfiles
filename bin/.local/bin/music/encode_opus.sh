#!/bin/bash

ffmpeg -i "$1" -c:a libopus -b:a 192k -vbr on -compression_level 10 -application audio \
  -c:v copy -disposition:v attached_pic \
  -metadata lyrics="" \
  -metadata UNSYNCEDLYRICS="" \
  -metadata unsyncedlyrics="" \
  "$2"
