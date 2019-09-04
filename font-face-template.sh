#!/bin/sh

prefix=$1
font_file=$2

family=`fc-scan --format="%{family}\n" $font_file.ttf | cut -d, -f1`

case $font_file in
    *Bold*)
        weight=700 ;;
    *)
        weight=400 ;;
esac
case $font_file in
    *Italic*|*Oblique*)
        style=italic ;;
    *)
        style=normal ;;
esac

extra=
if [ "$family" = Code2000 ] ; then
    extra="unicode-range: U+00A0, U+0100-E6FF, U+F8D0-10FFFF;"
fi

cat <<EOF
@font-face {
    font-family: '$family';
    font-style: $style;
    font-weight: $weight;
    font-display: swap;
    $extra
    src:
        url('$prefix/$font_file.woff2') format('woff2'),
        url('$prefix/$font_file.woff') format('woff'),
        url('$prefix/$font_file.ttf') format('truetype');
}
EOF
