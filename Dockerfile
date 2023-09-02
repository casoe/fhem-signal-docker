FROM ghcr.io/fhem/fhem/fhem-minimal-docker:3-bullseye
LABEL org.opencontainers.image.source https://github.com/casoe/fhem-signal-docker

MAINTAINER casoe@gmx.de
ARG VERSION=1.3
ARG SIGNALVERSION="0.12.1"
ARG LIBSIGVERSION="0.32.0"
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

WORKDIR "/tmp"

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -q -y install --no-install-recommends openjdk-17-jre-headless zip speedtest-cli && \
    apt-get clean && apt-get autoremove

# Get signal-cli, libsignal_jni.so and DBus for Perl
RUN wget -qN https://github.com/AsamK/signal-cli/releases/download/v$SIGNALVERSION/signal-cli-$SIGNALVERSION-Linux.tar.gz -O signal-cli-$SIGNALVERSION.tar.gz && \
    tar zxf signal-cli-$SIGNALVERSION.tar.gz && \
    mv signal-cli-$SIGNALVERSION  /opt/signal && \
    wget -qN https://github.com/exquo/signal-libs-build/releases/download/libsignal_v$LIBSIGVERSION/libsignal_jni.so-v$LIBSIGVERSION-armv7-unknown-linux-gnueabihf.tar.gz && \
    tar zxf libsignal_jni.so-v$LIBSIGVERSION-armv7-unknown-linux-gnueabihf.tar.gz && \
    zip -u /opt/signal/lib/libsignal-client-*.jar libsignal_jni.so && \
    rm -f signal-cli-$SIGNALVERSION.tar.gz libsignal_jni.so && \
    cpan -T install Protocol::DBus

# Establish service
COPY org.asamk.Signal.conf /etc/dbus-1/system.d/org.asamk.Signal.conf
COPY org.asamk.Signal.service /usr/share/dbus-1/system-services/org.asamk.Signal.service
COPY pre-start.sh /docker/

# End Dockerfile
