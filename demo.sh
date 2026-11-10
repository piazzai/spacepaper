#!/bin/bash
set -euo pipefail

command -v gimp >/dev/null || { echo "error: gimp installation not found"; exit 1; }

GIMP_CONFIG_DIR=$(find ~/.config -maxdepth 1 -iname "GIMP" -type d)
[[ -z $GIMP_CONFIG_DIR ]] && { echo "error: gimp config directory not found"; exit 1; }

GIMP_VERSION_DIR=$(find "$GIMP_CONFIG_DIR" -maxdepth 1 -type d -regex ".*/[0-9]+\.[0-9]+" | sort -V | tail -n1)
[[ -z $GIMP_VERSION_DIR ]] && { echo "error: versioned gimp config not found"; exit 1; }

SCRIPTS="$GIMP_VERSION_DIR"/scripts

cleanup() {
  rm -f "$SCRIPTS/generate-demo.scm"
  rm -rf demo/
}
trap cleanup EXIT

cp gimp/scripts/generate-demo.scm "$SCRIPTS/"
mkdir -p "demo"

run_gimp() {
  local object1=$1
  local object2=$2
  local object3=$3
  local object4=$4
  if ! gimp -i --batch-interpreter=plug-in-script-fu-eval -b "(generate-demo \"$object1\" \"$object2\" \"$object3\" \"$object4\" \"$(mktemp -u demo/XXX).png\")" -b "(gimp-quit TRUE)" >> demo.log 2>&1; then
    echo "error: gimp failed processing objects '$object1 $object2 $object3 $object4'"
    return 1
  fi
}

COMBINATIONS=(
  "moon neptune saturn venus"
  "saturn moon venus neptune"
  "neptune venus moon saturn"
  "venus saturn neptune moon"
  "jupiter uranus earth mars"
  "earth jupiter mars uranus"
  "uranus mars jupiter earth"
  "mars earth uranus jupiter"
)

for combination in "${COMBINATIONS[@]}"; do
  run_gimp $combination
done

if ! magick -delay 150 -loop 0 demo/*.png -resize 35% demo.gif; then
  echo "error: failed to assemble demo"
  exit 1
fi
