FROM alpine:3.18

LABEL maintainer="Martin BLD contact@bouillaudmartin.fr"

ENV TERM=xterm-256color

ENV PYTHONUNBUFFERED=1

RUN true && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories && \
    apk --update upgrade && \
    apk add --no-cache bash mysql-client curl doas runit python3 py3-pip icu-libs rsync ffmpeg build-base shadow && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools pipx watchdog && \
    python3 -m pipx ensurepath && \
    pipx install yt-dlp && \
    wget https://raw.githubusercontent.com/phusion/baseimage-docker/9f998e1a09bdcb228af03595092dbc462f1062d0/image/bin/setuser -O /sbin/setuser && \
    chmod +x /sbin/setuser && \
    rm -rf /var/cache/apk/* && \
    adduser -h /home/user-service -s /bin/sh -D user-service -u 2000 && \
    chown user-service:user-service /home/user-service && \
    mkdir -p /etc/run_once /etc/service && \
    chmod +x /root/.local/bin/yt-dlp

RUN adduser --uid 99 --disabled-password --ingroup users --no-create-home private && \
    echo 'permit private as root' > /etc/doas.d/doas.conf

# Boilerplate startup code
COPY ./boot.sh /sbin/boot.sh
RUN chmod +x /sbin/boot.sh
CMD [ "/sbin/boot.sh" ]

VOLUME ["/config", \
  "/dir1", "/dir2", "/dir3", "/dir4", "/dir5", "/dir6", "/dir7", "/dir8", "/dir9", "/dir10", \
  "/dir11", "/dir12", "/dir13", "/dir14", "/dir15", "/dir16", "/dir17", "/dir18", "/dir19", "/dir20"]

# Set the locale, to help Python and the user's applications deal with files that have non-ASCII characters
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV UMAP ""
ENV GMAP ""

COPY sample.conf monitor.py runas.sh /files/

# Make sure it's readable by $UID
RUN chmod a+rwX /files

# run-parts ignores files with "." in them
ADD 50_remap_ids.sh /etc/run_once/50_remap_ids
ADD 60_create_monitors.sh /etc/run_once/60_create_monitors
RUN chmod +x /etc/run_once/*