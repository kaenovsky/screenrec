#!/bin/bash
# record screen with ffmpeg
# please make sure you have ffmpeg installed or it won't work

echo '
############################################################
::: Screen recording with ffmpeg :::
 ___ ___ ___ ___ ___ ___    ___ ___ ___ ___ ___ _| |___ ___ 
|_ -|  _|  _| -_| -_|   |  |  _| -_|  _| . |  _| . | -_|  _|
|___|___|_| |___|___|_|_|  |_| |___|___|___|_| |___|___|_|  

v0.1 - https://github.com/kaenovsky/screenrec
############################################################
'

# check if export directory exists, if not create one

DIR="$HOME/screen-rec"

if [ ! -d "$DIR" ]; then
  echo "creating new folder and saving file here: $DIR"
  echo
  mkdir -p $DIR
  else echo "your export file will be saved here: $DIR"
  echo
fi

checkScreenSize=$(xdpyinfo | awk '/dimensions/{print $2}') 

echo 'This seems to be your resolution:'
echo 
echo '========'
echo $checkScreenSize
echo '========'
echo

sleep 1

echo
echo 'Reminder: stop ffmpeg recording by pressing ctrl + c'
echo
echo '::::: screen recording is about to start :::::'
echo

sleep 1

confirm() {
  local _prompt _response
 
  if [ "$1" ]; then _prompt="$1"; else _prompt="Are you sure"; fi
  _prompt="$_prompt [y/N] ?"
  
  read -r -p "$_prompt " _response
    case "$_response" in
      [Yy][Ee][Ss]|[Yy]) # Yes or Y (case-insensitive).
        ffmpeg -y -video_size $checkScreenSize -loglevel error -framerate 30 -f x11grab -i $DISPLAY+0,0 -c:v libx264 -qp 0 -preset ultrafast $DIR/output`date +%H%M%S`.mp4
        ;;
      [Nn][Oo]|[Nn])  # No or N.
        return 1
        ;;
      *) # Anything else (including a blank) is invalid.
        ;;
    esac
}

confirm

echo
echo '::::: end of recording :::::' 
echo
echo 'Your file should be here' $DIR/output`date +%H%M%S`.mp4
echo
echo 'Have a good one :)'
echo