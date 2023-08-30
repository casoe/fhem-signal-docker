FROM ghcr.io/fhem/fhem/fhem-minimal-docker:bullseye

MAINTAINER holoarts<holoarts@yahoo.com>
ARG SIGNALVERSION="0.12.1"
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -q -y install openjdk-17-jre-headless zip
RUN apt-get clean && apt-get autoremove

WORKDIR "/tmp"
RUN wget -qN https://github.com/AsamK/signal-cli/releases/download/v$SIGNALVERSION/signal-cli-$SIGNALVERSION-Linux.tar.gz -O signal-cli-$SIGNALVERSION.tar.gz
RUN tar zxf signal-cli-$SIGNALVERSION.tar.gz
RUN mv signal-cli-$SIGNALVERSION  /opt/signal
RUN wget -qN https://github.com/exquo/signal-libs-build/releases/download/libsignal_v0.31.0/libsignal_jni.so-v0.31.0-armv7-unknown-linux-gnueabihf.tar.gz
RUN tar zxf libsignal_jni.so-v0.31.0-armv7-unknown-linux-gnueabihf.tar.gz
RUN zip -u /opt/signal/lib/libsignal-client-*.jar libsignal_jni.so

RUN rm -f signal-cli-$SIGNALVERSION.tar.gz libsignal_jni.so
RUN cpan -T install Protocol::DBus

COPY org.asamk.Signal.conf /etc/dbus-1/system.d/org.asamk.Signal.conf
COPY org.asamk.Signal.service /usr/share/dbus-1/system-services/org.asamk.Signal.service
COPY pre-start.sh /docker/

# End Dockerfile
