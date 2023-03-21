FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y curl gnupg build-essential \
  && curl --silent --location https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get update \
  && apt-get install -y nodejs git busybox \
  && node -v

RUN corepack enable \
  && yarn --version

WORKDIR /app

COPY . .

RUN npm install -g serve

RUN echo "Building mobymask-ui" && \
    npm install

WORKDIR /app
