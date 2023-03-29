FROM node:18.15.0-alpine3.16

RUN apk --update --no-cache add git python3 alpine-sdk

WORKDIR /app

COPY . .

RUN echo "Building watcher-ts" && \
    git checkout v0.2.34 && \
    yarn && yarn build

WORKDIR /app/packages/erc721-watcher
