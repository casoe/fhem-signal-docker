FROM ghcr.io/fhem/fhem/fhem-minimal-docker:3-bullseye
LABEL org.opencontainers.image.source https://github.com/casoe/fhem-signal-docker

MAINTAINER casoe@gmx.de
ARG SIGNALVERSION="0.12.1"
ARG LIBSIGVERSION="0.32.0"
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get -q -y install openjdk-17-jre-headless zip speedtest-cli
RUN apt-get clean && apt-get autoremove

# Get signal-cli and libsignal_jni.so
WORKDIR "/tmp"
RUN wget -qN https://github.com/AsamK/signal-cli/releases/download/v$SIGNALVERSION/signal-cli-$SIGNALVERSION-Linux.tar.gz -O signal-cli-$SIGNALVERSION.tar.gz
RUN tar zxf signal-cli-$SIGNALVERSION.tar.gz
RUN mv signal-cli-$SIGNALVERSION  /opt/signal
RUN wget -qN https://github.com/exquo/signal-libs-build/releases/download/libsignal_v$LIBSIGVERSION/libsignal_jni.so-v$LIBSIGVERSION-armv7-unknown-linux-gnueabihf.tar.gz
RUN tar zxf libsignal_jni.so-v$LIBSIGVERSION-armv7-unknown-linux-gnueabihf.tar.gz
RUN zip -u /opt/signal/lib/libsignal-client-*.jar libsignal_jni.so

# Clean up
RUN rm -f signal-cli-$SIGNALVERSION.tar.gz libsignal_jni.so

# Get DBus for Perl and establish service
RUN cpan -T install Protocol::DBus
COPY org.asamk.Signal.conf /etc/dbus-1/system.d/org.asamk.Signal.conf
COPY org.asamk.Signal.service /usr/share/dbus-1/system-services/org.asamk.Signal.service
COPY pre-start.sh /docker/

# End Dockerfile
