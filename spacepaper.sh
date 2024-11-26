#!/bin/bash -e

[[ -z $1 ]] && { echo "error: missing object"; exit 1; }
[[ -z $2 ]] && { echo "error: missing width"; exit 1; }
[[ -z $3 ]] && { echo "error: missing height"; exit 1; }
[[ ! -f objects/$1.xcf ]] && { echo "error: object not found"; exit 1; }

PATTERNS=$(find ~/.config/GIMP -path "*patterns")
SCRIPTS=$(find ~/.config/GIMP -path "*scripts")
OUTPUT="$2"x"$3"

cp film-grain-vertical.pat "$PATTERNS"/
cp generate-wallpaper.scm "$SCRIPTS"/
mkdir -p "$OUTPUT"

gimp -ib "(generate-wallpaper \"$1\" $2 $3 \"$OUTPUT/$1.jpg\")" -b '(gimp-quit 0)'

rm -f "$PATTERNS"/film-grain-vertical.pat
rm -f "$SCRIPTS"/generate-wallpaper.scm
