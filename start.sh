#!/usr/bin/env sh

# Copyright (c) 2023-2024 Datalayer, Inc.
#
# Datalayer License

# service ssh start

# /nfsplugin "$@"

# Store arguments passed from `docker run my-image ARG1 ARG2 ...`
export SUPERVISOR_CUSTOM_ARGS="$*"

# Start supervisord
exec /usr/bin/supervisord -n
