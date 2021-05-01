#!/bin/sh
set -e

echo "Running container entrypoint ..."

echo "Running bundle check entrypoint ..."
bundle check

echo "Running pid removal ..."
if [ -f tmp/pids/server.pid ]; then
  rm -rf tmp/pids/server.pid
fi

exec bundle exec "$@"
