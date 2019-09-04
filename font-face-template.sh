#!/bin/sh

family=`fc-scan --format="%{family}\n" $1.ttf | cut -d, -f1`

case $1 in
    *Bold*)
        weight=700 ;;
    *)
        weight=400 ;;
esac
case $1 in
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
        url('$1.woff2') format('woff2'),
        url('$1.woff') format('woff'),
        url('$1.ttf') format('truetype');
}
EOF
