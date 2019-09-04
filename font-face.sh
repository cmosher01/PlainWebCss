#!/bin/sh

ls *.ttf | \
grep -v Mono | grep -v Serif | grep -v Display | \
cut -d. -f1 | \
\
xargs -n 1 font-face-template.sh \
\
>>~/css/font-faces.css
