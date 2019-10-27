FROM nginx
USER root
RUN apt-get update && apt-get install -y unzip wget fontforge woff-tools woff2

COPY *.sh /usr/local/bin/

WORKDIR /srv






# Code 2000 fonts, by James Kaas
# As of 2019, these fonts have no official current web site, so
# get the latest archived versions from the Internet Archive.
# Version numbers as listed on the web site, and dates from the
# files in the ZIP archives.
#
# Code 2000: 1.171 (2008-06-13)
# Code 2001: 0.919 (2008-04-06)
# Code 2002: ?.??? (2005-04-04)
#
ENV CODE_2000_ARCHIVE 20101122142710
RUN wget -nv https://web.archive.org/web/$CODE_2000_ARCHIVE/http://code2000.net/CODE2000.ZIP
RUN unzip CODE2000.ZIP
RUN mv -nv CODE2000.TTF code2000.original
RUN convert.fontforge.sh code2000.original
RUN sfnt2woff code2000.ttf
RUN woff2_compress code2000.ttf

ENV CODE_2001_ARCHIVE 20101122142330
RUN wget -nv https://web.archive.org/web/$CODE_2001_ARCHIVE/http://code2000.net/CODE2001.ZIP
RUN unzip CODE2001.ZIP
RUN mv -nv CODE2001.TTF code2001.original
RUN convert.fontforge.sh code2001.original
RUN sfnt2woff code2001.ttf
RUN woff2_compress code2001.ttf

ENV CODE_2002_ARCHIVE 20110108105420
RUN wget -nv https://web.archive.org/web/$CODE_2002_ARCHIVE/http://code2000.net/CODE2002.ZIP
RUN unzip CODE2002.ZIP
RUN mv -nv CODE2002.TTF code2002.original
RUN convert.fontforge.sh code2002.original
RUN sfnt2woff code2002.ttf
RUN woff2_compress code2002.ttf







# Unicode.org Last Resort font http://unicode.org/policies/lastresortfont_eula.html
RUN wget -nv --method=POST https://unicode.org/cgi-bin/LastResortDownload.zip
RUN unzip LastResortDownload.zip
RUN sfnt2woff LastResort.ttf
RUN woff2_compress LastResort.ttf







# SIL Unicode BMP Fallback Font https://scripts.sil.org/UnicodeBMPFallbackFont
ENV SILBMP_VERSION 61
RUN wget -nv -O UnicodeBMPFallback.zip "https://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=UnicodeBMPFallback_$SILBMP_VERSION"
RUN unzip -j UnicodeBMPFallback.zip
RUN sfnt2woff UnicodeBMPFallback.ttf
RUN woff2_compress UnicodeBMPFallback.ttf







# GNU Free Font https://www.gnu.org/software/freefont/
ENV FREEFONT_VERSION 20120503
RUN wget -nv -O freefont.zip http://ftp.gnu.org/gnu/freefont/freefont-ttf-$FREEFONT_VERSION.zip
RUN unzip -j freefont.zip
RUN sfnt2woff FreeSans.ttf
RUN woff2_compress FreeSans.ttf
RUN sfnt2woff FreeSansOblique.ttf
RUN woff2_compress FreeSansOblique.ttf
RUN sfnt2woff FreeSansBold.ttf
RUN woff2_compress FreeSansBold.ttf
RUN sfnt2woff FreeSansBoldOblique.ttf
RUN woff2_compress FreeSansBoldOblique.ttf







# GNU Unifont (bitmap) https://savannah.gnu.org/projects/unifont
ENV UNIFONT_VERSION 12.1.03
RUN wget -nv -O unifont.ttf https://ftp.snt.utwente.nl/pub/software/gnu/unifont/unifont-$UNIFONT_VERSION/unifont-$UNIFONT_VERSION.ttf
RUN sfnt2woff unifont.ttf
RUN woff2_compress unifont.ttf
RUN wget -nv -O unifont_upper.ttf https://ftp.snt.utwente.nl/pub/software/gnu/unifont/unifont-$UNIFONT_VERSION/unifont_upper-$UNIFONT_VERSION.ttf
RUN sfnt2woff unifont_upper.ttf
RUN woff2_compress unifont_upper.ttf
RUN wget -nv -O unifont_jp.ttf https://ftp.snt.utwente.nl/pub/software/gnu/unifont/unifont-$UNIFONT_VERSION/unifont_jp-$UNIFONT_VERSION.ttf
RUN sfnt2woff unifont_jp.ttf
RUN woff2_compress unifont_jp.ttf
RUN wget -nv -O unifont_csur.ttf https://ftp.snt.utwente.nl/pub/software/gnu/unifont/unifont-$UNIFONT_VERSION/unifont_csur-$UNIFONT_VERSION.ttf
RUN sfnt2woff unifont_csur.ttf
RUN woff2_compress unifont_csur.ttf







RUN apt-get install -y fonts-noto-core fonts-noto-color-emoji

RUN mkdir ~/css

WORKDIR /usr/share/fonts/truetype/noto
RUN ls *.ttf | xargs -n 1 sfnt2woff
RUN ls *.ttf | xargs -n 1 woff2_compress


WORKDIR /usr/share/fonts/truetype/noto
RUN font-face.sh ../noto

RUN mkdir /srv/cjk
WORKDIR /srv/cjk
# Noto CJK region-specific subset fonts
RUN wget -nv https://noto-website-2.storage.googleapis.com/pkgs/NotoSansJP.zip
RUN unzip NotoSansJP.zip NotoSansJP-Regular.otf
RUN wget -nv https://noto-website-2.storage.googleapis.com/pkgs/NotoSansKR.zip
RUN unzip NotoSansKR.zip NotoSansKR-Regular.otf
RUN wget -nv https://noto-website-2.storage.googleapis.com/pkgs/NotoSansSC.zip
RUN unzip NotoSansSC.zip NotoSansSC-Regular.otf
RUN wget -nv https://noto-website-2.storage.googleapis.com/pkgs/NotoSansTC.zip
RUN unzip NotoSansTC.zip NotoSansTC-Regular.otf
RUN ls *.otf | xargs -n 1 sfnt2woff
RUN ls *.otf | xargs -n 1 woff2_compress



WORKDIR /srv
RUN font-face.sh ../fallback



RUN echo ".unicodeWebFonts { font-family:" >~/css/unifonts.css
RUN echo "'Noto Sans'," >>~/css/unifonts.css
RUN fc-scan --format="%{family}\n" /usr/share/fonts/truetype/noto/*.ttf | grep -v '^Noto Sans$' | grep -v Mono | grep -v Serif | grep -v Display | sort -u | cut -d, -f1 | sed "s/\(.*\)/'\1',/" >>~/css/unifonts.css
RUN echo "'Noto Sans TC'," >>~/css/unifonts.css
RUN echo "'Noto Sans SC'," >>~/css/unifonts.css
RUN echo "'Noto Sans JP'," >>~/css/unifonts.css
RUN echo "'Noto Sans KR'," >>~/css/unifonts.css
RUN echo "'FreeSans', 'Code2000', 'Code2001', 'Code2002'," >>~/css/unifonts.css
RUN echo "'Unifont', 'Unifont-JP', 'Unifont Upper', 'Unifont CSUR'," >>~/css/unifonts.css
RUN echo "'LastResort', 'Unicode BMP Fallback SIL'; }" >>~/css/unifonts.css



COPY *.css /root/css/
RUN chmod a+rx /root



WORKDIR /usr/share/nginx/html
COPY index.html ./
COPY test ./test
RUN ln -s /usr/share/fonts/truetype/noto
RUN ln -s /srv/cjk
RUN ln -s /srv fallback
RUN ln -s ~/css