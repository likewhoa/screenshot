#!/bin/bash

# screenshot.sh script imgur.com uploader using imgurbash.sh and zenity
# Copyright (C) 2014 Mission Accomplish, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

yesno() {
  local re='^([Yy]|[Yy][Ee][Ss])'

  if [[ $answer =~ $re ]]; then
    echo "Exiting script"
    return 0
  else
    echo "Invalid answer, try again"
    return 1
  fi
}

imgur_results() {
  case $1 in
    1)
      echo -e "\n"
      read -p 'Type yes to exit this window: ' answer;;
    *)
      echo -e "\n"
      read -p 'Your imgur urls are above. Type yes to exit this window: ' answer
  esac

  yesno $answer || imgur_results 1
}

if [ $(id -u) = 0 ]; then
  echo "This script must not be run as root"
  echo "exiting";exit 1
fi

if ! hash imgurbash.sh 2>/dev/null; then
  echo "imgurbash.sh script missing from \$PATH"
  echo "Download imgurbash.sh from http://imgur.com/tools/imgurbash.sh"
  echo "and place it in your \$PATH i.e /usr/local/bin"
  echo "exiting";exit 1
fi

[ -d ~/Pictures ] || mkdir ~/Pictures

question=$(zenity --list --column "" --text "Imgur screenshot uploader"\
  --hide-header "Image upload" "Entire screen" "Select a region" 2>/dev/null)

imgur() {
  local re='(jpg|png)'

  case $1 in
    'Image upload')
      local filename
      filename=$(zenity --file-selection)

      if [[ ! ${filename/#*.} =~ $re ]]; then
        zenity --warning --text "Filename '${filename/#*\/}' is invalid! \n\nOnly JPEG, GIF, PNG, APNG, TIFF, BMP, PDF, XCF (GIMP)\nare supported"
        return 1
      fi

      imgurbash.sh "$filename"
      ;;
    'Entire screen')
      scrot '%Y-%m-%d_$wx$h-imgur-scrot-src.png' -e 'mv $f ~/Pictures/ && imgurbash.sh ~/Pictures/$f'
      ;;
    'Select a region')
      scrot '%Y-%m-%d_$wx$h-imgur-scrot-region.png' -b -s -e 'mv $f ~/Pictures/ && imgurbash.sh ~/Pictures/$f'
      ;;
    *)
      echo "Error occurred, exiting"
      exit 1
  esac

  imgur_results
}

imgur "$question"
