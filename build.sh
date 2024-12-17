#!/bin/bash

export DOCKER_BUILDKIT=1

docker buildx build --file Dockerfile \
  --platform linux/amd64,linux/arm64 \
  --provenance false \
  --tag martinbouillaud/inotify-ytdlp:latest . \
  --push
