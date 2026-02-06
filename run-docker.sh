#!/bin/sh

SHARED="$HOME/IRC/shared"
PLATFORM=$(uname)
ARCH=$(uname -m)

if [ -n "$1" ]; then
    SHARED=$(readlink -f $1)
    echo Using custom shared directory: $SHARED
else 
    echo Using default shared directory: $SHARED
fi

if [ ! -f ~/.ssh/id_ed25519.pub ]; then
    echo "Error: SSH public key ~/.ssh/id_ed25519.pub not found."
    echo "Please generate it using: ssh-keygen -t ed25519"
    exit 1
fi

if [ "$PLATFORM" = "Darwin" ]; then
xhost + 127.0.0.1
docker run -itd --rm \
    --name core \
    -p 2000:22 \
    -p 50051:50051 \
    -v $SHARED:/shared \
    -e SSHKEY="`cat ~/.ssh/id_ed25519.pub`" \
    -e DISPLAY=host.docker.internal:0 \
    --privileged \
    --entrypoint core-daemon \
    $IMAGE
else
xhost +local:root
docker run -itd --rm \
    --name core \
    -p 2000:22 \
    -p 50051:50051 \
    -v $SHARED:/shared \
    -e SSHKEY="`cat ~/.ssh/id_ed25519.pub`" \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --privileged \
    --entrypoint core-daemon \
    $IMAGE
fi
# afterwards you may run
sleep 3
status=$(docker ps --filter status=running | grep core)
while true; do
    if [ -n "$status" ]; then
        docker exec  core service ssh start
        docker exec -it core core-gui
        break
    else 
        sleep 1
        status=$(docker ps --filter status=running | grep core)
    fi
done

docker stop core
