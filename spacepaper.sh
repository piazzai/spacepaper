#!/bin/bash -e

[[ -z $1 ]] && { echo "error: missing width"; exit 1; }
[[ -z $2 ]] && { echo "error: missing height"; exit 1; }
[[ -z $3 ]] && { echo "error: missing object"; exit 1; }

[[ ! -f input/$3.xcf ]] && { echo "error: object not found"; exit 1; }

PATTERNS=$(find ~/.config/GIMP -path "*patterns")
SCRIPTS=$(find ~/.config/GIMP -path "*scripts")
OUTPUT=output/"$1"x"$2"

cp film-grain-vertical.pat "$PATTERNS"/
cp generate-wallpaper.scm "$SCRIPTS"/
mkdir -p "$OUTPUT"

gimp -ib "(generate-wallpaper \"$3\" $1 $2 \"$OUTPUT/$3.jpg\")" -b '(gimp-quit 0)'

rm -f "$PATTERNS"/film-grain-vertical.pat
rm -f "$SCRIPTS"/generate-wallpaper.scm
