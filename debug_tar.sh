#!/bin/bash
set -x
URL="https://github.com/abenz1267/elephant/releases/download/v2.17.1/elephant-linux-amd64.tar.gz"
wget -O /tmp/debug_elephant.tar.gz "$URL"
mkdir -p /tmp/debug_elephant
tar -xzf /tmp/debug_elephant.tar.gz -C /tmp/debug_elephant
ls -R /tmp/debug_elephant
