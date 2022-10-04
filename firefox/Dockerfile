FROM jlesage/firefox

RUN apk update && apk add py3-fonttools

RUN rm /usr/lib/firefox/fonts/*
RUN rm /opt/novnc/fonts/*
RUN rm /usr/share/imlib2/data/fonts/*

WORKDIR /usr/share/fonts
RUN apk update && apk del ttf-dejavu font-croscore
RUN rm -R ttf-dejavu noto 100dpi 75dpi cyrillic

WORKDIR /usr/share/fonts/misc
RUN rm *.gz fonts.alias
COPY minimal.xml ./
RUN ttx -v -o minimal.ttf minimal.xml

WORKDIR /usr/share/fonts
RUN mkfontdir -e encodings -e encodings/large misc
RUN cat misc/fonts.dir
RUN fc-cache -f -v
RUN fc-list
