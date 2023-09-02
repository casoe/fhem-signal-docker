# Extension for FHEM-docker installation to communicate with Signal

Files to build a docker image with Signal support via Signalbot (Integration for signal messenger) and signal-cli. At the moment it's only tested on a Rapberry Pi 3 (armv7/armhf).

A pre-built package can be found here: https://github.com/users/casoe/packages/container/package/fhem-minimal-signal-docker

Updates for signal-cli here: https://github.com/AsamK/signal-cli

Updates for libsignal_jni.so here: https://github.com/exquo/signal-libs-build/releases

An original fhem/fhem-minimal-docker image is used as a foundation, see the documentation at https://github.com/fhem/fhem-docker/ . 

## Build and push the container to github container registry (ghcr.io)

* clone files 
* cd into this directory
* run `docker build -t fhem-minimal-signal-docker:1.0 .`
* run `export CR_PAT=YOUR_TOKEN`
* run `echo $CR_PAT | docker login ghcr.io -u YOUR_LOGIN --password-stdin`
* run `docker tag YOUR_IMAGE_ID ghcr.io/casoe/fhem-minimal-signal-docker`
* run `docker push ghcr.io/casoe/fhem-minimal-signal-docker`

## Build locally and test the container with minimal configuration

* clone files 
* cd into this directory
* run `docker compose up -d`
* go to http://YOUR_HOSTNAME:8083
* define a new entity with  `define signal Signalbot`

## More info

See the FHEM Wiki (German) for the usage of Signalbot.
https://wiki.fhem.de/wiki/Signalbot

See FHEM Forum (German) for more details
https://forum.fhem.de/index.php/topic,118370.0.html

This extension is based on the work of https://github.com/bublath/FHEM-Signalbot.     

For source and license of the lib libsignal_jni.so see
https://github.com/signalapp/libsignal-client
