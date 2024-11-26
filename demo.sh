#!/bin/bash -e

[[ -z $1 ]] && { echo "error: phone object not provided"; exit 1; }
[[ -z $2 ]] && { echo "error: tablet object not provided"; exit 1; }
[[ -z $3 ]] && { echo "error: laptop object not provided"; exit 1; }
[[ -z $4 ]] && { echo "error: desktop object not provided"; exit 1; }

bash wallpaper.sh 375 812
bash wallpaper.sh 768 1024
bash wallpaper.sh 3072 1920
bash wallpaper.sh 4096 2304

exit

SCRIPTS=$(find ~ -path "*GIMP*scripts")

cp scripts/generate-demo.scm "$SCRIPTS"/

gimp -ib "(generate-demo \"$1\" \"demo/mockup-$1.png\")" -b '(gimp-quit 0)'

rm -f "$SCRIPTS"/generate-demo.scm
