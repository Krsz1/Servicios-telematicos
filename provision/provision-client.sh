#!/usr/bin/env bash
set -eux

apt-get update -y
apt-get install -y curl nodejs npm
npm install -g artillery
