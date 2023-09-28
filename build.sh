#!/bin/bash

export DOCKER_BUILDKIT=1

docker buildx build --platform linux/amd64 -t martinbouillaud/inotify-ytdlp .

if [[ $? -eq 0 ]]; then
    docker tag martinbouillaud/inotify-ytdlp martinbouillaud/inotify-ytdlp:latest
    docker push martinbouillaud/inotify-ytdlp:latest
fi
