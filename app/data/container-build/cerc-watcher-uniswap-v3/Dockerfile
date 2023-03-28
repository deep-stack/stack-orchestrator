FROM node:18.15.0-alpine3.16

RUN apk --update --no-cache add git python3 alpine-sdk

WORKDIR /app

COPY . .

# TODO: Use updated release
RUN echo "Building uniswap-watcher-ts" && \
    git checkout v0.3.4 && \
    yarn && yarn build && yarn build:contracts
