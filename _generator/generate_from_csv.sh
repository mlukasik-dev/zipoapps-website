#!/bin/sh

set -e

while IFS=, read -r slug fullname tagline summary email iconurl package
do
    gh workflow run generate-app-pages.yml \
        -f slug="$slug" \
        -f fullname="$fullname" \
        -f tagline="$tagline" \
        -f summary="$summary" \
        -f email="$email" \
        -f iconurl="$iconurl" \
        -f package="$package"
done < apps.csv
