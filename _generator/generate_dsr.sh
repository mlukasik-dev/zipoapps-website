#!/bin/sh

set -e

if [ -z "$SLUG" ]; then
  exit 1
fi

sed -e "s/SLUGVARIABLE/$SLUG/g" _generator/_APP_dsr.tex > "dsr/$SLUG.tex"

pdflatex -output-directory=./dsr ./dsr/"$SLUG".tex
