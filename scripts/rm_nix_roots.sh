#!/usr/bin/env bash
# Removes all `result` symlinks hanging around the filesystem which are annoying to manually delete
nix-store --gc --print-roots | awk '{print $1}' | grep /result$ | sudo xargs rm
