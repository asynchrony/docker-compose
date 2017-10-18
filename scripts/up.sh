#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset

docker-compose pull
docker-compose build --force-rm --pull
docker-compose up --remove-orphans -d

sleep $SLEEP

# check that all containers are healthy
docker-compose ps -q | xargs docker inspect -f '{{ .Name }} {{ .State.Status }} {{with .State.Health}}{{ .Status }}{{end}}' | grep -E " running$| running healthy$"
