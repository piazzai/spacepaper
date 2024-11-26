#!/bin/bash -e

[[ -z $1 ]] && { echo "error: width not provided"; exit 1; }
[[ -z $2 ]] && { echo "error: height not provided"; exit 1; }

PATTERNS=$(find ~ -path "*GIMP*patterns")
SCRIPTS=$(find ~ -path "*GIMP*scripts")
OBJECTS=$(find input -name "*.xcf" | sed -e "s/.*\/\(.*\).xcf/\1/" | grep -v rings | grep -v mockup)
OUTPUT=output/"$1"x"$2"

cp patterns/film-grain-vertical.pat "$PATTERNS"/
cp scripts/generate-wallpaper.scm "$SCRIPTS"/
mkdir -p "$OUTPUT"

if [[ -z $3 ]]; then
    for OBJECT in $OBJECTS; do
        gimp -ib "(generate-wallpaper \"$OBJECT\" $1 $2 \"$OUTPUT/$OBJECT.png\")" -b '(gimp-quit TRUE)'
        echo "$OBJECT wallpaper saved to ./$OUTPUT/$OBJECT.png"
    done
elif [[ -f input/"$3".xcf && $3 != "rings" && $3 != "mockup" ]]; then
    gimp -ib "(generate-wallpaper \"$3\" $1 $2 \"$OUTPUT/$3.png\")" -b '(gimp-quit TRUE)'
    echo "$3 wallpaper saved to ./$OUTPUT/$3.png"
else
    echo "error: object not valid"
fi

rm -f "$PATTERNS"/film-grain-vertical.pat
rm -f "$SCRIPTS"/generate-wallpaper.scm
