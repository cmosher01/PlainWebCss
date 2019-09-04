FROM nginx
USER root
RUN apt-get update && apt-get install -y unzip wget fontforge woff-tools woff2
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
#
#
# Archive:  CODE2000.ZIP
#  Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
# --------  ------  ------- ---- ---------- ----- --------  ----
#     4549  Defl:N     2080  54% 2008-06-15 16:49 2803940b  CODE2000.HTM
#  8377000  Defl:N  3858297  54% 2008-06-13 00:45 750abea1  CODE2000.TTF
# --------          -------  ---                            -------
#  8381549          3860377  54%                            2 files
#
#
#
# Archive:  CODE2001.ZIP
#  Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
# --------  ------  ------- ---- ---------- ----- --------  ----
#   497144  Defl:N   212157  57% 2008-04-06 18:54 161d8021  CODE2001.TTF
# --------          -------  ---                            -------
#   497144           212157  57%                            1 file
#
#
#
# Archive:  CODE2002.ZIP
#  Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
# --------  ------  ------- ---- ---------- ----- --------  ----
#  4293820  Defl:N  2369681  45% 2005-04-04 22:25 cfe88f00  CODE2002.TTF
# --------          -------  ---                            -------
#  4293820          2369681  45%                            1 file
RUN wget -nv https://web.archive.org/web/20101122142710/http://code2000.net/CODE2000.ZIP
RUN wget -nv https://web.archive.org/web/20101122142330/http://code2000.net/CODE2001.ZIP
RUN wget -nv https://web.archive.org/web/20110108105420/http://code2000.net/CODE2002.ZIP

COPY convert.fontforge.pe ./
COPY compare.fontforge.pe ./

RUN unzip CODE2000.ZIP
RUN mv -nv CODE2000.TTF code2000.original
RUN ./convert.fontforge.pe code2000.original
RUN ./compare.fontforge.pe code2000.original code2000.ttf >code2000.diff 2>&1
RUN sfnt2woff code2000.ttf
RUN woff2_compress code2000.ttf

RUN unzip CODE2001.ZIP
RUN mv -nv CODE2001.TTF code2001.original
RUN ./convert.fontforge.pe code2001.original
RUN ./compare.fontforge.pe code2001.original code2001.ttf >code2001.diff 2>&1
RUN sfnt2woff code2001.ttf
RUN woff2_compress code2001.ttf

RUN unzip CODE2002.ZIP
RUN mv -nv CODE2002.TTF code2002.original
RUN ./convert.fontforge.pe code2002.original
RUN ./compare.fontforge.pe code2002.original code2002.ttf >code2002.diff 2>&1
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
# TODO fonts-noto-cjk



WORKDIR /usr/share/fonts/truetype/noto
RUN ls *.ttf | xargs -n 1 sfnt2woff
RUN ls *.ttf | xargs -n 1 woff2_compress


RUN mkdir ~/css
COPY font-features.css ~/css/
COPY *.sh /usr/local/bin/

WORKDIR /usr/share/fonts/truetype/noto
RUN font-face.sh ../noto

WORKDIR /srv
RUN font-face.sh ../fallback

RUN echo ".unicodeWebFonts { font-family:" >~/css/unifonts.css
RUN echo "'Noto Sans'," >>~/css/unifonts.css
RUN fc-scan --format="%{family}\n" /usr/share/fonts/truetype/noto/*.ttf | grep -v '^Noto Sans$' | grep -v Mono | grep -v Serif | grep -v Display | sort -u | cut -d, -f1 | sed "s/\(.*\)/'\1',/" >>~/css/unifonts.css
RUN echo "'FreeSans', 'Code2000', 'Code2001', 'Code2002'," >>~/css/unifonts.css
RUN echo "'Unifont', 'Unifont-JP', 'Unifont Upper', 'Unifont CSUR'," >>~/css/unifonts.css
RUN echo "'LastResort', 'Unicode BMP Fallback SIL'; }" >>~/css/unifonts.css

COPY *.css /root/css/
RUN chmod a+rx /root

WORKDIR /usr/share/nginx/html
COPY index.html ./
COPY test ./test
RUN ln -s /usr/share/fonts/truetype/noto
RUN ln -s /srv fallback
RUN ln -s ~/css
