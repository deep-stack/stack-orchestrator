#!/bin/sh
set -e

yarn deploy

# TODO: Set deployed contract and event block number in environment

yarn test
