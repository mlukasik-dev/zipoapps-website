#!/bin/sh

set -e

if [ "${PWD##*/}" != "_generator" ]; then
    echo "Please cd into _generator"
    exit 1
fi

if [ -z "${slug+_}" ]; then
    echo "What is the slug the app? (https://zipoapps.com/{SLUG})"
    read slug
fi

sed -e "s/SLUGVARIABLE/$slug/g" _APP_dsr.tex > "../dsr/$slug.tex"

pdflatex -output-directory=../dsr "../dsr/$slug.tex"
