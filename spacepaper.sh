#!/bin/bash -e

[[ -z $1 ]] && { echo "error: missing object"; exit 1; }
[[ -z $2 ]] && { echo "error: missing width"; exit 1; }
[[ -z $3 ]] && { echo "error: missing height"; exit 1; }
[[ ! -f input/$1.xcf ]] && { echo "error: object not found"; exit 1; }

PAT=$(find ~ -path "*GIMP*/patterns")
SCM=$(find ~ -path "*GIMP*/scripts")
OUT=output/"$2"x"$3"

cp film-grain-vertical.pat "$PAT"/
cp generate-wallpaper.scm "$SCM"/
mkdir -p "$OUT"

gimp -ib "(generate-wallpaper \"$1\" $2 $3 \"$OUT/$1.jpg\")" -b '(gimp-quit 0)'

rm -f "$PATDIR"/film-grain-vertical.pat
rm -f "$SCMDIR"/generate-wallpaper.scm
