FROM node:18.17.1-alpine3.18

RUN apk --update --no-cache add git alpine-sdk

WORKDIR /app

COPY . .

RUN echo "Installing packages" && \
    yarn && yarn compile
