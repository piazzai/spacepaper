#!/bin/bash
set -euo pipefail

[[ -z ${1:-} ]] && { echo "error: width not provided"; exit 1; }
[[ -z ${2:-} ]] && { echo "error: height not provided"; exit 1; }

[[ $1 =~ ^[0-9]+$ ]] || { echo "error: width must be a positive integer"; exit 1; }
[[ $2 =~ ^[0-9]+$ ]] || { echo "error: height must be a positive integer"; exit 1; }

command -v gimp >/dev/null || { echo "error: gimp installation not found"; exit 1; }

GIMP_CONFIG_DIR=$(find ~/.config -maxdepth 1 -iname "GIMP" -type d)
[[ -z $GIMP_CONFIG_DIR ]] && { echo "error: gimp config directory not found"; exit 1; }

GIMP_VERSION_DIR=$(find "$GIMP_CONFIG_DIR" -maxdepth 1 -type d -regex ".*/[0-9]+\.[0-9]+" | sort -V | tail -n1)
[[ -z $GIMP_VERSION_DIR ]] && { echo "error: versioned gimp config not found"; exit 1; }
OUTPUT=output/"$1"x"$2"

cp gimp/patterns/film-grain-vertical.pat "$PATTERNS"/
cp gimp/scripts/generate-wallpaper.scm "$SCRIPTS"/

run_gimp() {
  local object=$1
  if ! gimp -i --batch-interpreter=plug-in-script-fu-eval -b "(generate-wallpaper \"$object\" $2 $3 \"$OUTPUT/$object.png\")" -b "(gimp-quit TRUE)"; then
    echo "error: gimp failed processing $object"
    return 1
  fi
}

if [[ -z ${3:-} ]]; then
  mkdir -p "$OUTPUT"
  for OBJECT in "${OBJECTS[@]}"; do
    run_gimp "$OBJECT" "$1" "$2" > spacepaper.log 2>&1 && echo "wallpaper saved to ./$OUTPUT/$OBJECT.png"
  done
elif [[ -f "gimp/$3.xcf" && $3 != "rings" && $3 != "mockup" ]]; then
  mkdir -p "$OUTPUT"
  run_gimp "$3" "$1" "$2" > spacepaper.log 2>&1 && echo "wallpaper saved to ./$OUTPUT/$3.png"
else
  echo "error: object not valid"
  exit 1
fi
