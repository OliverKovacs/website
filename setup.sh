#!/usr/bin/env bash

nix-shell -p bundler -p bundix --run 'bundler update; bundler lock; bundler package --no-install --path vendor; bundix; rm -rf vendor'

echo "ready for nix-shell"
