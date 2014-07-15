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

answer=$(zenity --list --column "" --text "Gentoo Livedvd Screenshot uploader"\
  --hide-header "Upload an Image" "Desktop Screenshot" "Window Screenshot")

imgur() {
  local re='(jpg|png)'

  case $1 in
    'Upload an Image')
      filename=$(zenity --file-selection)
      if [[ ! $re =~ ${filename/#*.} ]]; then
        zenity --warning --text "Filename '${filename/#*\/} is invalid!\nOnly JPEG, GIF, PNG, APNG, TIFF, BMP, PDF, XCF (GIMP) are supported"
        exit 1
      fi
      ./imgurbash.sh "$filename"
      ;;
    'Desktop Screenshot')
      scrot '%Y-%m-%d_$wx$h_gentoo-livedvd-imgur-scrot.png' -e 'mv $f ~/Pictures/ && imgurbash.sh ~/Pictures/$f'
      ;;
    'Window Screenshot')
      scrot '%Y-%m-%d_$wx$h_gentoo-livedvd-imgur-scrot.png' -b -s -e 'mv $f ~/Pictures/ && imgurbash.sh ~/Pictures/$f'
      ;;
    *)
      echo "Error occurred, exiting"
      exit 1
  esac
}

imgur "$answer"
