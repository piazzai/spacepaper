#!/bin/bash -e

bash wallpaper.sh 375 812
bash wallpaper.sh 768 1024
bash wallpaper.sh 3072 1920
bash wallpaper.sh 4096 2304

SCRIPTS=$(find ~ -path "*GIMP*scripts")

cp scripts/generate-demo.scm "$SCRIPTS"/
mkdir -p "demo"

gimp -ib "(generate-demo \"moon\" \"neptune\" \"saturn\" \"venus\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'
gimp -ib "(generate-demo \"saturn\" \"moon\" \"venus\" \"neptune\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'
gimp -ib "(generate-demo \"neptune\" \"venus\" \"moon\" \"saturn\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'
gimp -ib "(generate-demo \"venus\" \"saturn\" \"neptune\" \"moon\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'
gimp -ib "(generate-demo \"jupiter\" \"uranus\" \"earth\" \"mars\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'
gimp -ib "(generate-demo \"earth\" \"jupiter\" \"mars\" \"uranus\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'
gimp -ib "(generate-demo \"uranus\" \"mars\" \"jupiter\" \"earth\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'
gimp -ib "(generate-demo \"mars\" \"earth\" \"uranus\" \"jupiter\" \"$(mktemp -u demo/XXX).png\")" -b '(gimp-quit TRUE)'

convert -delay 150 -loop 0 -resize 35% demo/*.png demo.gif

rm -f "$SCRIPTS"/generate-demo.scm
rm -rf "demo/"
